class PredictionResponse {
  final List<Prediction> predictions;

  PredictionResponse({required this.predictions});

  factory PredictionResponse.fromJson(List<dynamic> json) {
    return PredictionResponse(
      predictions: json.map((e) => Prediction.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions.map((e) => e.toJson()).toList(),
    };
  }
}

class Prediction {
  final String label;
  final double score;

  Prediction({
    required this.label,
    required this.score,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      label: json['label'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'score': score,
    };
  }
}
