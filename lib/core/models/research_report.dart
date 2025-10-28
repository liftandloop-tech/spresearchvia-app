class ResearchReport {
  final String id;
  final String title;
  final String category;
  final String date;
  final String description;
  final String publishedDate;
  final String executiveSummary;
  final List<String> keyHighlights;
  final int pages;
  final String fileSize;
  final String researchTeam;
  final String language;
  bool isDownloaded;

  ResearchReport({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.publishedDate,
    required this.executiveSummary,
    required this.keyHighlights,
    required this.pages,
    required this.fileSize,
    required this.researchTeam,
    required this.language,
    this.isDownloaded = false,
  });
}
