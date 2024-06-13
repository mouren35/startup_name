import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:startup_namer/db/task_db.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务统计'),
      ),
      body: Consumer<TaskDB>(
        builder: (context, taskDB, child) {
          return FutureBuilder<Map<Color, int>>(
            future: taskDB.getCompletedTasksByColor(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('没有已完成的任务'));
              } else {
                final data = snapshot.data!;
                final totalTasks = data.values.reduce((a, b) => a + b);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '任务完成数量',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.transparent,
                                tooltipPadding: EdgeInsets.zero,
                                tooltipMargin: 8,
                                getTooltipItem: (
                                  BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex,
                                ) {
                                  return BarTooltipItem(
                                    rod.toY.round().toString(),
                                    const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              leftTitles: const AxisTitles(
                                axisNameWidget: Text("完成数"),
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                axisNameWidget: const Text('分类'),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: getTitles,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            barGroups: data.entries.map((entry) {
                              return BarChartGroupData(
                                showingTooltipIndicators: [0],
                                x: data.keys.toList().indexOf(entry.key),
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.toDouble(),
                                    color: entry.key.withOpacity(0.5),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '任务完成情况占比',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: data.entries.map((entry) {
                              final percentage =
                                  (entry.value / totalTasks) * 100;
                              return PieChartSectionData(
                                color: entry.key.withOpacity(0.5),
                                value: percentage,
                                title: '${percentage.toStringAsFixed(1)}%',
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('心智');
        break;
      case 1:
        text = const Text('健康');
        break;
      case 2:
        text = const Text('工作');
        break;
      case 3:
        text = const Text('人际');
        break;
      case 4:
        text = const Text('兴趣');
        break;
      default:
        text = const Text('');
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
