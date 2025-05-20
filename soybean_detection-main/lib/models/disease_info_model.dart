class DiseaseInfo {
  final String className;
  final String precautions;

  DiseaseInfo({required this.className, required this.precautions});

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      className: json['predicted_class_label'],
      precautions: json['precautions'],
    );
  }

  static List<DiseaseInfo> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DiseaseInfo.fromJson(json)).toList();
  }
}
