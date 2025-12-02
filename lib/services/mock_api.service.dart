import '../core/config/app_mode.dart';
import '../core/models/research_report.dart';
import '../core/models/user.dart';

class MockApiService {
  static Future<List<ResearchReport>> getResearchReports() async {
    if (AppMode.isDevelopment) {
      await Future.delayed(Duration(seconds: 1));
      return [
        ResearchReport(
          id: '1',
          title: 'Market Analysis Q4 2024',
          category: 'Market Analysis',
          description: 'Comprehensive market analysis for Q4',
          reportPath: '/mock/path/report1.pdf',
          reportOriginalName: 'market_analysis_q4_2024.pdf',
          reportName: 'Market Analysis Q4 2024',
          publishedStatus: 'published',
          publishedDate: '2024-01-15',
          executiveSummary: 'Key insights into market trends and opportunities',
          keyHighlights: ['Growth in tech sector', 'Emerging markets expansion'],
          pages: 25,
          fileSize: '2.5 MB',
          researchTeam: 'SP Research Team',
          language: 'English',
        ),
      ];
    } else {
      return [];
    }
  }

  static Future<User?> getCurrentUser() async {
    if (AppMode.isDevelopment) {
      await Future.delayed(Duration(milliseconds: 500));
      return User(
        id: 'mock_user_id',
        fullName: 'Test User',
        email: 'test@example.com',
        phone: '9876543210',
      );
    } else {
      return null;
    }
  }
}