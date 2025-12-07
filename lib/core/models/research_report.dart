class ResearchReport {
  final String id;
  final String title;
  final String category;
  final String description;
  final String reportPath;
  final String reportOriginalName;
  final String reportName;
  final String publishedStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isDownloaded;

  final String? publishedDate;
  final String? executiveSummary;
  final List<String>? keyHighlights;
  final int? pages;
  final String? fileSize;
  final String? researchTeam;
  final String? language;

  ResearchReport({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.reportPath,
    required this.reportOriginalName,
    required this.reportName,
    required this.publishedStatus,
    this.createdAt,
    this.updatedAt,
    this.isDownloaded = false,
    this.publishedDate,
    this.executiveSummary,
    this.keyHighlights,
    this.pages,
    this.fileSize,
    this.researchTeam,
    this.language,
  });

  bool get isPublished => publishedStatus == 'published';
  String get date => createdAt?.toString().split(' ')[0] ?? '';

  factory ResearchReport.fromJson(Map<String, dynamic> json) {
    return ResearchReport(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      reportPath: json['reportPath']?.toString() ?? '',
      reportOriginalName: json['reportOriginalName']?.toString() ?? '',
      reportName: json['reportName']?.toString() ?? '',
      publishedStatus: json['publishedStatus']?.toString() ?? 'draft',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      publishedDate: json['createdAt']?.toString().split('T')[0],
      executiveSummary: json['description']?.toString(),
      keyHighlights: ['Key insights from ${json['title'] ?? 'report'}'],
      pages: 20,
      fileSize: '2.0 MB',
      researchTeam: 'Research Team',
      language: 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'category': category,
      'description': description,
      'reportPath': reportPath,
      'reportOriginalName': reportOriginalName,
      'reportName': reportName,
      'publishedStatus': publishedStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
