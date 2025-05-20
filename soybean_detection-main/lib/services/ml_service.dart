import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/prediction_model.dart';

class MLService {
  static final Logger _logger = Logger();
  bool _modelLoaded = false;
  Interpreter? _interpreter;
  List<String>? _labels;

  // TensorFlow Lite input/output details
  List<int>? _inputShape;
  List<int>? _outputShape;

  // Match the threshold used in Python training (0.7)
  static const double defaultThreshold = 0.7;

  // Image dimensions should match the model input size (224x224)
  static const int inputImageWidth = 224;
  static const int inputImageHeight = 224;

  // VGG16 preprocessing uses these mean values for each channel (BGR)
  // These are the ImageNet means used by VGG16
  static const double meanR = 123.68;
  static const double meanG = 116.779;
  static const double meanB = 103.939;

  Future<bool> loadModel() async {
    try {
      // Close any existing interpreter
      _interpreter?.close();

      // Copy model from assets to a temp file that can be accessed by the interpreter
      final modelPath = await _getModel('lib/models/soybean_model.tflite');

      _logger.i("Loading model from: $modelPath");

      try {
        // Set up options for maximum compatibility
        final options =
            InterpreterOptions()
              ..threads = 4
              ..useNnApiForAndroid = false; // Use CPU for consistent results

        // Load interpreter from file - match Python tf.lite.Interpreter
        _interpreter = Interpreter.fromFile(File(modelPath), options: options);

        // Allocate tensors - match Python interpreter.allocate_tensors()
        _interpreter!.allocateTensors();

        // Get input and output details like Python code
        var inputDetails = _interpreter!.getInputTensor(0);
        var outputDetails = _interpreter!.getOutputTensor(0);

        _inputShape = inputDetails.shape;
        _outputShape = outputDetails.shape;

        _logger.i("Model input shape: $_inputShape");
        _logger.i("Model output shape: $_outputShape");

        // Load labels
        _labels = await _loadLabels();
        if (_labels == null || _labels!.isEmpty) {
          _logger.e("Failed to load labels");
          return false;
        }

        _modelLoaded = true;
        _logger.i("Model loaded successfully with ${_labels?.length} classes");
        return true;
      } catch (e) {
        _logger.e("Error loading interpreter: $e");
        return false;
      }
    } catch (e) {
      _logger.e("Error in loadModel: $e");
      return false;
    }
  }

  Future<List<String>> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString('lib/models/labels.txt');
      return labelsData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();
    } catch (e) {
      _logger.e("Error loading labels: $e");
      // Fallback labels from Python code
      return [
        "Bacterial Pustule",
        "Frogeye Leaf Spot",
        "Healthy",
        "Rust",
        "Sudden Death Syndrome",
        "Target Leaf Spot",
        "Yellow Mosaic",
      ];
    }
  }

  Future<String> _getModel(String assetPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/${assetPath.split('/').last}');

    if (!file.existsSync()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }

    return file.path;
  }

  Future<PredictionResult?> predictImage(
    File image, {
    double threshold = defaultThreshold,
  }) async {
    if (_interpreter == null) {
      bool loaded = await loadModel();
      if (!loaded) {
        _logger.e("Failed to load model");
        return null;
      }
    }

    try {
      // Decode image
      img.Image? imageInput = img.decodeImage(await image.readAsBytes());
      if (imageInput == null) {
        _logger.e("Could not decode image");
        return null;
      }

      // Resize to 224x224 as used in training
      final resizedImage = img.copyResize(
        imageInput,
        width: inputImageWidth,
        height: inputImageHeight,
        interpolation: img.Interpolation.linear,
      );

      // Get input shape from model
      var inputShape = _interpreter!.getInputTensor(0).shape;
      _logger.d("Input tensor shape: $inputShape");

      // Create input tensor in the correct format
      var input = [
        List.generate(
          inputImageHeight,
          (y) => List.generate(inputImageWidth, (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r.toDouble() - meanR,
              pixel.g.toDouble() - meanG,
              pixel.b.toDouble() - meanB,
            ];
          }),
        ),
      ];

      try {
        // Get output shape
        var outputShape = _interpreter!.getOutputTensor(0).shape;
        _logger.d("Output shape from model: $outputShape");

        // Create a properly shaped output buffer - must match [1, 7]
        List<List<double>> outputs = [List<double>.filled(outputShape[1], 0)];

        // Run inference with properly shaped input and output
        _interpreter!.run(input, outputs);

        // Get probabilities from first row (since shape is [1, 7])
        List<double> probabilities = outputs[0];

        _logger.i("Raw outputs: $probabilities");

        // Find class with highest probability
        int maxIndex = 0;
        double maxConfidence = probabilities[0];

        for (int i = 1; i < probabilities.length; i++) {
          if (probabilities[i] > maxConfidence) {
            maxConfidence = probabilities[i];
            maxIndex = i;
          }
        }

        // Get predicted class name
        String predictedClass = "Unknown";
        if (_labels != null && maxIndex < _labels!.length) {
          predictedClass = _labels![maxIndex];
        }

        // Match Python threshold check
        if (maxConfidence < threshold) {
          _logger.w("Confidence below threshold: $maxConfidence < $threshold");
          return PredictionResult(
            predictedClass: "It's not a leaf, please click the leaf's image.",
            confidence: maxConfidence,
            isValidPrediction: false,
            rawOutputArray: probabilities,
          );
        }

        _logger.i(
          "Prediction: $predictedClass with ${maxConfidence * 100}% confidence",
        );
        return PredictionResult(
          predictedClass: predictedClass,
          confidence: maxConfidence,
          isValidPrediction: true,
          rawOutputArray: probabilities,
        );
      } catch (e) {
        _logger.e("Error during inference: $e");
        return null;
      }
    } catch (e) {
      _logger.e("Error in prediction pipeline: $e");
      return null;
    }
  }

  void dispose() {
    _interpreter?.close();
    _modelLoaded = false;
  }
}
