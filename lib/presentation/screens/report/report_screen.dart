import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../common/constants/color_constans.dart';
import '../../controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final ReportController controller = Get.put(ReportController());

  Future<void> _generatePdfReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Laporan Perpustakaan",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Periode', 'Jumlah'],
                  data: List.generate(
                    controller.xLabels.length,
                    (index) => [
                      controller.xLabels[index],
                      controller.values[index].toInt().toString(),
                    ],
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Filter: ${controller.selectedFilter.value}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Perpustakaan"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
                  () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.filters.map((filter) {
                    bool isSelected = controller.selectedFilter.value == filter;
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? ColorConstant.primaryColor(context) : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(8, 36),
                          side: BorderSide(color: ColorConstant.secondaryColor(context)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          controller.selectedFilter.value = filter;
                          controller.fetchReportData();
                        },
                        child: Text(filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.xLabels.isEmpty) {
                  return const Center(child: Text("Tidak ada data"));
                }
                return AspectRatio(
                  aspectRatio: 1.4,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (controller.values.isNotEmpty)
                          ? (controller.values.reduce((a, b) => a > b ? a : b) + 2)
                          : 10,
                      barGroups: List.generate(
                        controller.values.length,
                            (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: controller.values[index],
                              color: ColorConstant.primaryColor(context),
                              width: 22,
                            ),
                          ],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index >= 0 &&
                                  index < controller.xLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    controller.xLabels[index],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.toInt().toString(),
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      gridData: FlGridData(show: true),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: MyButton(
                onPressed: _generatePdfReport,
                backgroundColor: ColorConstant.primaryColor(context),
                child: const Text(
                  "Ekspor Laporan (PDF)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}