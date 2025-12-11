import 'package:flutter/material.dart';
import '../../core/models/research_report.dart';
import 'widgets/report_header_card.dart';
import 'widgets/key_highlight_item.dart';
import 'widgets/report_detail_row.dart';
import 'widgets/subscriber_badge.dart';
import '../../widgets/button.dart';

class ResearchReportDetailScreen extends StatelessWidget {
  const ResearchReportDetailScreen({super.key, required this.report});

  final ResearchReport report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
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
              padding: const EdgeInsets.all(16),
              child: ReportHeaderCard(
                category: 'Market Analysis',
                title: report.title,
                publishedDate: report.publishedDate ?? 'Not available',
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Executive Summary',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    report.executiveSummary ?? 'No summary available',
                    style: const TextStyle(
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
            const SizedBox(height: 12),
            Container(
              color: const Color(0xffF9FAFB),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Highlights',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(report.keyHighlights ?? []).map((highlight) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KeyHighlightItem(text: highlight),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Pages',
                                value: (report.pages ?? 0).toString(),
                              ),
                            ),
                            Expanded(
                              child: ReportDetailRow(
                                label: 'File Size',
                                value: report.fileSize ?? 'Unknown size',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Research Team',
                                value: report.researchTeam ?? 'Research Team',
                              ),
                            ),
                            Expanded(
                              child: ReportDetailRow(
                                label: 'Language',
                                value: report.language ?? 'English',
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SubscriberBadge(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Button(
                    title: 'Download PDF',
                    buttonType: ButtonType.green,
                    icon: Icons.download,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  Button(
                    title: 'Download Excel',
                    buttonType: ButtonType.greyBorder,
                    icon: Icons.download,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
