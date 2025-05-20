class PredictionResult {
  final String predictedClass;
  final double confidence;
  String? precautions;
  final bool isValidPrediction;
  final List<double>? rawOutputArray; // Store the raw output array

  PredictionResult({
    required this.predictedClass,
    required this.confidence,
    this.precautions,
    this.isValidPrediction = true,
    this.rawOutputArray,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json['predicted_class'] as String,
      confidence:
          json['confidence'] is int
              ? (json['confidence'] as int) / 100.0
              : (json['confidence'] is double && json['confidence'] > 1.0)
              ? (json['confidence'] as double) / 100.0
              : json['confidence'] as double,
      precautions: json['precautions'] as String?,
      isValidPrediction: json['is_valid_prediction'] as bool? ?? true,
      rawOutputArray:
          json['raw_output_array'] != null
              ? List<double>.from(json['raw_output_array'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predicted_class': predictedClass,
      'confidence': confidence,
      'is_valid_prediction': isValidPrediction,
      if (precautions != null) 'precautions': precautions,
      if (rawOutputArray != null) 'raw_output_array': rawOutputArray,
    };
  }

  @override
  String toString() {
    return 'PredictionResult{predictedClass: $predictedClass, confidence: ${(confidence * 100).toStringAsFixed(2)}%, isValid: $isValidPrediction}';
  }
}
