import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/research_report.dart';
import 'package:spresearchvia2/screens/research/widgets/report_header_card.dart';
import 'package:spresearchvia2/screens/research/widgets/key_highlight_item.dart';
import 'package:spresearchvia2/screens/research/widgets/report_detail_row.dart';
import 'package:spresearchvia2/screens/research/widgets/subscriber_badge.dart';
import 'package:spresearchvia2/widgets/button.dart';

class ResearchReportDetailScreen extends StatelessWidget {
  const ResearchReportDetailScreen({super.key, required this.report});

  final ResearchReport report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: ReportHeaderCard(
                category: 'Market Analysis',
                title: report.title,
                publishedDate: report.publishedDate,
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Executive Summary',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    report.executiveSummary,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff374151),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              color: Color(0xffF9FAFB),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Highlights',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  SizedBox(height: 16),
                  ...report.keyHighlights.map((highlight) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: KeyHighlightItem(text: highlight),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Pages',
                                value: report.pages.toString(),
                              ),
                            ),
                            Expanded(
                              child: ReportDetailRow(
                                label: 'File Size',
                                value: report.fileSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Research Team',
                                value: report.researchTeam,
                              ),
                            ),
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Language',
                                value: report.language,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SubscriberBadge(),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Button(
                    title: 'Download PDF',
                    buttonType: ButtonType.green,
                    icon: Icons.download,
                    onTap: () {},
                  ),
                  SizedBox(height: 12),
                  Button(
                    title: 'Download Excel',
                    buttonType: ButtonType.greyBorder,
                    icon: Icons.download,
                    onTap: () {},
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
