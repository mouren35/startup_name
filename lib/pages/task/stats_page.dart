import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/db/task_db.dart';
import 'package:startup_namer/widget/custom_appbar.dart';

class TaskStatisticsPage extends StatelessWidget {
  final User user;
  const TaskStatisticsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<int>(
              future: provider.getCompletedTaskCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final completedTaskCount = snapshot.data ?? 0;
                return Text('完成的任务数量: $completedTaskCount');
              },
            ),
            FutureBuilder<int>(
              future: provider.getTotalTaskCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final totalTaskCount = snapshot.data ?? 0;
                return Text('所有任务数量: $totalTaskCount');
              },
            ),
            FutureBuilder<Map<String, int>>(
              future: provider.getDailyTimeSpent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final dailyTimeSpent = snapshot.data ?? {};
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: dailyTimeSpent.entries
                            .map(
                              (entry) => BarChartGroupData(
                                x: int.parse(entry.key.split('-').last),
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.toDouble(),
                                    color: Colors.lightBlueAccent,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
