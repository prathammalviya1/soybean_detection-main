import 'package:soybean_detection/models/disease_info_model.dart';
import 'package:logger/logger.dart';

class DiseaseService {
  static final Logger _logger = Logger();
  List<DiseaseInfo> _diseaseInfoList = [];
  static final DiseaseService _instance = DiseaseService._internal();

  factory DiseaseService() => _instance;

  DiseaseService._internal();

  Future<void> initialize() async {
    try {
      // Load disease info from JSON data
      final diseasesJson = [
        {
          "predicted_class_label": "Bacterial Pustule",
          "precautions":
              "Use certified disease-free seeds. Practice crop rotation (avoid planting soybeans repeatedly). Use resistant soybean varieties. Apply copper-based fungicides if necessary. Control insects (they help spread the bacteria).",
        },
        {
          "predicted_class_label": "Frogeye Leaf Spot",
          "precautions":
              "Use resistant soybean cultivars. Rotate crops (prefer 2 years gap from soybean). Apply foliar fungicides during early reproductive stages. Avoid overhead irrigation.",
        },
        {
          "predicted_class_label": "Healthy",
          "precautions":
              "Maintain field sanitation. Regularly monitor plant health. Use quality seeds and proper fertilization. Control pests early to prevent diseases.",
        },
        {
          "predicted_class_label": "Rust",
          "precautions":
              "Use rust-resistant soybean varieties. Apply fungicides preventatively at early signs. Remove and destroy infected plant debris. Monitor weather (rust spreads faster in moist, humid conditions).",
        },
        {
          "predicted_class_label": "Sudden Death Syndrome",
          "precautions":
              "Plant SDS-resistant soybean varieties. Avoid early planting in cold, wet soils. Improve field drainage. Manage nematodes (they worsen SDS severity).",
        },
        {
          "predicted_class_label": "Target Leaf Spot",
          "precautions":
              "Rotate soybean with non-host crops like corn or wheat. Use tillage practices to bury infected debris. Apply fungicides during early disease development. Avoid dense plant canopies (promotes air circulation).",
        },
        {
          "predicted_class_label": "Yellow Mosaic",
          "precautions":
              "Use virus-resistant soybean varieties. Control aphid population (they spread the virus). Remove and destroy infected plants. Avoid growing soybean near leguminous weeds.",
        },
      ];

      _diseaseInfoList = DiseaseInfo.fromJsonList(diseasesJson);
      _logger.i(
        "Disease info loaded successfully: ${_diseaseInfoList.length} entries",
      );
    } catch (e) {
      _logger.e("Error loading disease info: $e");
    }
  }

  DiseaseInfo? getInfoForDisease(String diseaseName) {
    try {
      return _diseaseInfoList.firstWhere(
        (info) => info.className.toLowerCase() == diseaseName.toLowerCase(),
      );
    } catch (e) {
      _logger.w("Disease info not found for: $diseaseName");
      return null;
    }
  }
}
