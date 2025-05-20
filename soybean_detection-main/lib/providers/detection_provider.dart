import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soybean_detection/models/prediction_model.dart';
import 'package:soybean_detection/services/ml_service.dart';
import 'package:soybean_detection/services/permission_service.dart';
import 'package:soybean_detection/services/disease_service.dart';
import 'package:logger/logger.dart';

enum DetectionState { initial, loading, success, error }

class DetectionProvider extends ChangeNotifier {
  final MLService _mlService = MLService();
  final DiseaseService _diseaseService = DiseaseService();
  final ImagePicker _imagePicker = ImagePicker();
  final Logger _logger = Logger();

  File? _selectedImage;
  DetectionState _state = DetectionState.initial;
  String? _errorMessage;
  PredictionResult? _predictionResult;
  bool _modelLoaded = false;

  File? get selectedImage => _selectedImage;
  DetectionState get state => _state;
  String? get errorMessage => _errorMessage;
  PredictionResult? get predictionResult => _predictionResult;
  bool get isLoading => _state == DetectionState.loading;
  bool get hasImage => _selectedImage != null;
  bool get modelLoaded => _modelLoaded;

  DetectionProvider() {
    _initServices();
  }

  Future<void> _initServices() async {
    _state = DetectionState.loading;
    notifyListeners();

    // Initialize disease service
    await _diseaseService.initialize();

    // Load ML model
    _modelLoaded = await _mlService.loadModel();

    if (_modelLoaded) {
      _state = DetectionState.initial;
    } else {
      _state = DetectionState.error;
      _errorMessage = 'Failed to load the model. Please restart the app.';
    }

    notifyListeners();
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    try {
      bool permissionGranted = false;

      // Check which permission to request based on the source
      if (source == ImageSource.camera) {
        permissionGranted = await PermissionService.requestCameraPermission(
          context,
        );
      } else {
        permissionGranted = await PermissionService.requestStoragePermission(
          context,
        );
      }

      if (!permissionGranted) {
        _state = DetectionState.error;
        _errorMessage =
            'Permission denied. Please grant the required permissions.';
        notifyListeners();
        return;
      }

      // Pick image
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90, // Higher quality for better disease detection
        maxWidth: 1200, // Limit max dimensions for performance
        maxHeight: 1200,
      );

      if (pickedFile == null) {
        _logger.i("No image selected");
        return;
      }

      _selectedImage = File(pickedFile.path);
      _state = DetectionState.initial;
      _predictionResult = null; // Reset previous result
      notifyListeners();
    } catch (e) {
      _logger.e("Error picking image: $e");
      _state = DetectionState.error;
      _errorMessage = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> analyzeDisease({
    double confidenceThreshold = MLService.defaultThreshold,
  }) async {
    if (_selectedImage == null) {
      _state = DetectionState.error;
      _errorMessage = 'Please select an image first.';
      notifyListeners();
      return;
    }

    try {
      _state = DetectionState.loading;
      notifyListeners();

      // Ensure model is loaded
      if (!_modelLoaded) {
        _modelLoaded = await _mlService.loadModel();
        if (!_modelLoaded) {
          _state = DetectionState.error;
          _errorMessage = 'Failed to load the model. Please restart the app.';
          notifyListeners();
          return;
        }
      }

      // Perform prediction with threshold
      final result = await _mlService.predictImage(
        _selectedImage!,
        threshold: confidenceThreshold,
      );

      if (result == null) {
        _state = DetectionState.error;
        _errorMessage = 'Failed to process the image. Please try again.';
      } else {
        // If valid prediction, append precautions
        if (result.isValidPrediction) {
          final diseaseInfo = _diseaseService.getInfoForDisease(
            result.predictedClass,
          );
          if (diseaseInfo != null) {
            result.precautions = diseaseInfo.precautions;
          }
        } else {
          // For invalid predictions (below threshold), set custom message
          result.precautions =
              "This doesn't appear to be a soybean leaf or the image is unclear. Please take a clearer picture of a soybean leaf.";
        }

        _predictionResult = result;
        _state = DetectionState.success;
      }
    } catch (e) {
      _logger.e("Error during disease detection: $e");
      _state = DetectionState.error;
      _errorMessage = 'Error during disease detection: $e';
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = DetectionState.initial;
    _errorMessage = null;
    _predictionResult = null;
    _selectedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _mlService.dispose();
    super.dispose();
  }
}
