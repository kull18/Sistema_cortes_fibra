class PhotoEvidence {
  final String id;
  final String fileName;
  final String label;
  final String timeLabel;
  final String sizeLabel;
  final String? localPath;

  const PhotoEvidence({
    required this.id,
    required this.fileName,
    required this.label,
    required this.timeLabel,
    required this.sizeLabel,
    this.localPath,
  });
}