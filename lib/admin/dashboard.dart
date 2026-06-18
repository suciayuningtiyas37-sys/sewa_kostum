import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // ===== DUMMY DATA =====
  List<FlSpot> get pesananChart => const [
        FlSpot(0, 4),
        FlSpot(1, 9),
        FlSpot(2, 6),
        FlSpot(3, 11),
        FlSpot(4, 14),
        FlSpot(5, 10),
        FlSpot(6, 8),
      ];

  List<FlSpot> get pendapatanChart => const [
        FlSpot(0, 400),
        FlSpot(1, 900),
        FlSpot(2, 650),
        FlSpot(3, 1300),
        FlSpot(4, 1700),
        FlSpot(5, 1200),
        FlSpot(6, 1000),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard CosRent",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E3B2A),
              ),
            ),

            const SizedBox(height: 20),

            // ===== PESANAN CHART =====
            _chartBox(
              title: "Pesanan Harian",
              child: LineChart(_buildLine(pesananChart)),
            ),

            const SizedBox(height: 16),

            // ===== PENDAPATAN CHART =====
            _chartBox(
              title: "Pendapatan Harian",
              child: LineChart(_buildLine(pendapatanChart, isMoney: true)),
            ),

            const SizedBox(height: 16),

            // ===== TOP PRODUK =====
            _chartBox(
              title: "Top Produk Disewa",
              child: BarChart(_buildBar()),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LINE CHART =================
  LineChartData _buildLine(List<FlSpot> data, {bool isMoney = false}) {
    return LineChartData(
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Color(0xFF4E3B2A),
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
              return Text(
                days[value.toInt()],
                style: const TextStyle(
                  color: Color(0xFF4E3B2A),
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          color: const Color(0xFF7F5539),
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],

      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => const Color(0xFF4E3B2A),
          getTooltipItems: (spots) {
            return spots.map((e) {
              return LineTooltipItem(
                isMoney ? "Rp ${e.y.toInt()}" : e.y.toInt().toString(),
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // ================= BAR CHART =================
  BarChartData _buildBar() {
    return BarChartData(
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),

      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => const Color(0xFF4E3B2A),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.toY.toInt().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),

      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Color(0xFF4E3B2A),
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      barGroups: [
        _bar(0, 22),
        _bar(1, 18),
        _bar(2, 15),
        _bar(3, 11),
        _bar(4, 9),
      ],
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF7F5539),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // ================= CARD WRAPPER =================
  Widget _chartBox({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E6D8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0CBB3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4E3B2A),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}