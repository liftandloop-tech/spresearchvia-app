import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/research_report.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/screens/research/widgets/active_filter_chip.dart';
import 'package:spresearchvia2/screens/research/widgets/filter_chip_button.dart';
import 'package:spresearchvia2/screens/research/widgets/report_card.dart';
import 'package:spresearchvia2/screens/research/research_report_detail.screen.dart';

class ResearchReportsScreen extends StatefulWidget {
  const ResearchReportsScreen({super.key});

  @override
  State<ResearchReportsScreen> createState() => _ResearchReportsScreenState();
}

class _ResearchReportsScreenState extends State<ResearchReportsScreen> {
  String? selectedCategory;
  String? selectedDate;

  List<ResearchReport> get filteredReports {
    return dummyUser.researchReports.where((report) {
      if (selectedCategory != null && report.category != selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  void clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Research Reports',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    FilterChipButton(
                      label: 'Category',
                      icon: Icons.category_outlined,
                      isActive: selectedCategory != null,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(
                                    'Equity',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  onTap: () {
                                    setState(() => selectedCategory = 'Equity');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text(
                                    'Commodity',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  onTap: () {
                                    setState(
                                      () => selectedCategory = 'Commodity',
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    FilterChipButton(
                      label: 'Date',
                      icon: Icons.calendar_today,
                      isActive: selectedDate != null,
                      onTap: () {},
                    ),
                    if (selectedCategory != null || selectedDate != null)
                      GestureDetector(
                        onTap: clearFilters,
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff2C7F38),
                          ),
                        ),
                      ),
                  ],
                ),
                if (selectedCategory != null) ...[
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ActiveFilterChip(label: selectedCategory!),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: filteredReports.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return ReportCard(
                  title: report.title,
                  category: report.category,
                  date: report.date,
                  description: report.description,
                  isDownloaded: report.isDownloaded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResearchReportDetailScreen(report: report),
                      ),
                    );
                  },
                  onDownload: () {
                    setState(() {
                      report.isDownloaded = !report.isDownloaded;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
