import 'package:spresearchvia2/core/models/research_report.dart';
import 'package:spresearchvia2/core/models/subscription_history.dart';

enum KycStatus { verified, pending, rejected, notStarted }

enum PlanType { basic, premium, enterprise }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final KycStatus kycStatus;

  final PlanType currentPlan;
  final String planName;
  final double planAmount;
  final String planValidity;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionExpiryDate;
  final int daysRemaining;
  final String paymentMethod;
  final String cardNumber;
  final String cardType;

  final List<String> premiumBenefits;

  final List<SubscriptionHistory> subscriptionHistory;

  final List<ResearchReport> researchReports;

  final String portfolioValue;
  final String todayReturn;
  final String totalInvestment;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.kycStatus,
    required this.currentPlan,
    required this.planName,
    required this.planAmount,
    required this.planValidity,
    required this.subscriptionStartDate,
    required this.subscriptionExpiryDate,
    required this.daysRemaining,
    required this.paymentMethod,
    required this.cardNumber,
    required this.cardType,
    required this.premiumBenefits,
    required this.subscriptionHistory,
    required this.researchReports,
    required this.portfolioValue,
    required this.todayReturn,
    required this.totalInvestment,
  });
}

final User dummyUser = User(
  id: 'USER_001',
  name: 'Rajesh Kumar',
  email: 'rajesh.kumar@example.com',
  phone: '+91 98765 43210',
  profileImage: 'https://i.pravatar.cc/150?img=12',
  kycStatus: KycStatus.verified,

  currentPlan: PlanType.premium,
  planName: 'Premium Plan',
  planAmount: 29.99,
  planValidity: '30 days',
  subscriptionStartDate: DateTime(2024, 12, 15),
  subscriptionExpiryDate: DateTime(2025, 1, 14),
  daysRemaining: 15,
  paymentMethod: 'Credit Card',
  cardNumber: '**** **** **** 4532',
  cardType: 'Visa',

  premiumBenefits: [
    'Access to all premium research reports',
    'Real-time market alerts and notifications',
    'Priority customer support',
    'Advanced portfolio analytics',
    'Exclusive webinars and training sessions',
  ],

  subscriptionHistory: [
    SubscriptionHistory(
      id: '1',
      paymentDate: 'Dec 15, 2024',
      amountPaid: '\$29.99',
      validityDays: '30 days',
      expiryDate: 'Jan 14, 2025',
      headerStatus: SubscriptionStatus.active,
      footerStatus: SubscriptionStatus.success,
    ),
    SubscriptionHistory(
      id: '2',
      paymentDate: 'Nov 10, 2024',
      amountPaid: '\$29.99',
      validityDays: '30 days',
      expiryDate: 'Dec 10, 2024',
      headerStatus: SubscriptionStatus.expired,
      footerStatus: SubscriptionStatus.success,
    ),
    SubscriptionHistory(
      id: '3',
      paymentDate: 'Oct 28, 2024',
      amountPaid: '\$0.00',
      validityDays: '0 days',
      expiryDate: '-',
      headerStatus: SubscriptionStatus.failed,
      footerStatus: SubscriptionStatus.failed,
    ),
    SubscriptionHistory(
      id: '4',
      paymentDate: 'Sep 18, 2024',
      amountPaid: '\$29.99',
      validityDays: '30 days',
      expiryDate: 'Oct 18, 2024',
      headerStatus: SubscriptionStatus.expired,
      footerStatus: SubscriptionStatus.success,
    ),
  ],

  researchReports: [
    ResearchReport(
      id: '1',
      title: 'Q4 2024 Market Analysis - Technology Sector Outlook',
      category: 'Equity',
      date: 'Dec 15, 2024',
      description:
          'Comprehensive analysis of the technology sector performance and future prospects for Q4 2024.',
      publishedDate: 'December 15, 2024',
      executiveSummary:
          'This comprehensive report analyzes the technology sector\'s performance in Q4 2024, highlighting key trends in AI, cloud computing, and semiconductor industries. Our research indicates strong growth potential with moderate risk factors.',
      keyHighlights: [
        'Technology sector showed 12% growth in Q4 2024',
        'AI and Machine Learning stocks outperformed by 18%',
        'Cloud computing market expanded to \$250B globally',
        'Semiconductor shortage expected to ease in Q1 2025',
        'Recommended portfolio allocation: 35% tech stocks',
      ],
      pages: 24,
      fileSize: '2.4 MB',
      researchTeam: 'Technology Research Division',
      language: 'English',
      isDownloaded: true,
    ),
    ResearchReport(
      id: '2',
      title: 'Gold & Silver Price Forecast 2025',
      category: 'Commodity',
      date: 'Dec 12, 2024',
      description:
          'In-depth analysis of precious metals market trends and price predictions for 2025.',
      publishedDate: 'December 12, 2024',
      executiveSummary:
          'An in-depth examination of gold and silver markets, analyzing supply-demand dynamics, geopolitical factors, and inflation trends. Our forecast suggests bullish momentum for both precious metals through 2025.',
      keyHighlights: [
        'Gold prices expected to reach \$2,300/oz by mid-2025',
        'Silver demand increasing due to industrial applications',
        'Central bank gold purchases at 10-year high',
        'Inflation concerns supporting precious metals rally',
        'Recommended allocation: 15-20% in precious metals',
      ],
      pages: 18,
      fileSize: '1.8 MB',
      researchTeam: 'Commodities Research Team',
      language: 'English',
      isDownloaded: false,
    ),
    ResearchReport(
      id: '3',
      title: 'Banking Sector Performance Review - FY 2024',
      category: 'Equity',
      date: 'Dec 10, 2024',
      description:
          'Detailed review of banking sector performance and outlook for major financial institutions.',
      publishedDate: 'December 10, 2024',
      executiveSummary:
          'This report examines the Indian banking sector\'s FY 2024 performance, focusing on credit growth, asset quality, and digital transformation initiatives. Key findings show strong fundamentals with improving NPA ratios.',
      keyHighlights: [
        'Banking sector credit growth at 14.5% YoY',
        'Net NPA ratio improved to 2.8% from 3.9%',
        'Digital banking adoption increased by 45%',
        'Private banks outperforming PSU banks',
        'Target price upside of 15-20% for top banking stocks',
      ],
      pages: 32,
      fileSize: '3.2 MB',
      researchTeam: 'Financial Services Team',
      language: 'English',
      isDownloaded: false,
    ),
    ResearchReport(
      id: '4',
      title: 'Crude Oil Market Dynamics & Price Projections',
      category: 'Commodity',
      date: 'Dec 8, 2024',
      description:
          'Analysis of global crude oil supply-demand factors and price forecasts for Q1 2025.',
      publishedDate: 'December 8, 2024',
      executiveSummary:
          'A comprehensive analysis of global crude oil markets, examining OPEC+ policies, US shale production, and geopolitical tensions. Our research indicates balanced supply-demand with potential volatility.',
      keyHighlights: [
        'Brent crude expected to trade in \$75-85/barrel range',
        'OPEC+ production cuts extended through Q2 2025',
        'US crude inventory levels below 5-year average',
        'Renewable energy transition impacting long-term demand',
        'Short-term bullish, long-term neutral outlook',
      ],
      pages: 20,
      fileSize: '2.1 MB',
      researchTeam: 'Energy Research Division',
      language: 'English',
      isDownloaded: true,
    ),
    ResearchReport(
      id: '5',
      title: 'Pharmaceutical Industry Outlook 2025',
      category: 'Equity',
      date: 'Dec 5, 2024',
      description:
          'Strategic analysis of pharmaceutical sector trends and investment opportunities.',
      publishedDate: 'December 5, 2024',
      executiveSummary:
          'This report provides a detailed analysis of the pharmaceutical industry, covering regulatory updates, pipeline drugs, and export opportunities. The sector shows resilient growth with strong export potential.',
      keyHighlights: [
        'Indian pharma exports grew 15% in FY 2024',
        'Generic drug approvals increased by 22%',
        'API manufacturing gaining momentum domestically',
        'Healthcare spending increased post-pandemic',
        'Top pharma stocks showing 25% upside potential',
      ],
      pages: 28,
      fileSize: '2.8 MB',
      researchTeam: 'Healthcare Research Team',
      language: 'English',
      isDownloaded: false,
    ),
  ],

  portfolioValue: '₹12,45,680',
  todayReturn: '+₹2,340 (1.92%)',
  totalInvestment: '₹10,00,000',
);
