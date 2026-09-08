class ReportedBy {
  final int id;
  final String technicianCode;
  final String? fullName;

  const ReportedBy({
    required this.id,
    required this.technicianCode,
    this.fullName,
  });

  /// Prioriza fullName. Si no está disponible, utiliza technicianCode.
  /// Si ninguno está disponible, retorna 'Técnico'.
  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      return fullName!;
    }
    if (technicianCode.trim().isNotEmpty) {
      return technicianCode;
    }
    return 'Técnico';
  }
}
