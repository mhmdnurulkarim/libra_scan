import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:libra_scan/presentation/widgets/button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../common/constants/color_constans.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<String> filters = ['Hari Ini', 'Mingguan', 'Bulanan', 'Tahunan'];
  String selectedFilter = 'Tahunan';

  final List<double> values = [59.95, 66.59, 36.76, 82.17, 90.61];
  final List<String> xLabels = ['2020', '2021', '2022', '2023', '2024'];

  List<BarChartGroupData> get barData {
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: Colors.lightBlue,
            width: 22,
          ),
        ],
      );
    });
  }

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
                  headers: ['Tahun', 'Jumlah'],
                  data: List.generate(
                    xLabels.length,
                    (index) => [
                      xLabels[index],
                      values[index].toStringAsFixed(2),
                    ],
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Filter: $selectedFilter',
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
            // Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  filters.map((filter) {
                    bool isSelected = selectedFilter == filter;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.black : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Text(filter),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            // Chart
            AspectRatio(
              aspectRatio: 1.4,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: barData,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return Text(xLabels[index]);
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
                          rod.toY.toStringAsFixed(2),
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),

            const Spacer(),

            // Tombol Ekspor PDF
            SizedBox(
              width: double.infinity,
              child: MyButton(
                onPressed: _generatePdfReport,
                color: ColorConstant.greenColor,
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
