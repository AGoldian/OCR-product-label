enum Validation { child3years, unknown }

extension AsValidation on String {
  Validation get asValidation {
    switch (this) {
      case 'child3years':
        return Validation.child3years;
    }
    return Validation.unknown;
  }
}

class ValidationResult {
  final bool isOk;
  final String validationTitle;

  const ValidationResult({
    required this.isOk,
    required this.validationTitle,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> jsonData) =>
      ValidationResult(
        isOk: jsonData['isOk'],
        validationTitle: jsonData['validationTitle'],
      );

  Map<String, dynamic> toMap() => {
        'isOk': isOk,
        'validationTitle': validationTitle,
      };
}
