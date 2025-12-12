import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class MealRecord {
  final int rowNumber;
  final int userId;
  final String date;
  final String mealDescription;
  final int calories;
  final int proteins;
  final int carbs;
  final int fats;
  final String other;

  MealRecord({
    required this.rowNumber,
    required this.userId,
    required this.date,
    required this.mealDescription,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.other,
  });

  factory MealRecord.fromJson(Map<String, dynamic> json) {
    return MealRecord(
      rowNumber: json['row_number'] ?? 0,
      userId: json['user_id'] ?? 0,
      date: json['date'] ?? '',
      mealDescription: json['meal_description'] ?? '',
      calories: json['calories'] ?? 0,
      proteins: json['proteins'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fats: json['fats'] ?? 0,
      other: json['other'] ?? '',
    );
  }
}

class DailyStats {
  final String date;
  final int totalCalories;
  final int totalProteins;
  final int totalCarbs;
  final int totalFats;
  final List<MealRecord> meals;

  DailyStats({
    required this.date,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalCarbs,
    required this.totalFats,
    required this.meals,
  });
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<List<MealRecord>> futureMealRecords;
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    futureMealRecords = fetchMealRecords();
  }

  Future<List<MealRecord>> fetchMealRecords() async {
    final response = await http.get(Uri.parse(
        'https://www.chinglun.pro/webhook/e9919eb0-9661-4ca3-80da-fluterreport-input'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => MealRecord.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load meal records');
    }
  }

  Map<String, DailyStats> _processData(List<MealRecord> records) {
    Map<String, List<MealRecord>> grouped = {};
    for (var record in records) {
      if (!grouped.containsKey(record.date)) {
        grouped[record.date] = [];
      }
      grouped[record.date]!.add(record);
    }

    Map<String, DailyStats> dailyStatsMap = {};
    grouped.forEach((date, meals) {
      int cal = 0, pro = 0, carb = 0, fat = 0;
      for (var meal in meals) {
        cal += meal.calories;
        pro += meal.proteins;
        carb += meal.carbs;
        fat += meal.fats;
      }
      dailyStatsMap[date] = DailyStats(
        date: date,
        totalCalories: cal,
        totalProteins: pro,
        totalCarbs: carb,
        totalFats: fat,
        meals: meals,
      );
    });
    return dailyStatsMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('統計資訊')),
      body: FutureBuilder<List<MealRecord>>(
        future: futureMealRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final records = snapshot.data!;
          final dailyStatsMap = _processData(records);
          final sortedDates = dailyStatsMap.keys.toList()..sort();
          
          // Default to the last date if none selected
          final currentDisplayDate = selectedDate ?? sortedDates.last;
          final currentStats = dailyStatsMap[currentDisplayDate]!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Overview Card (Daily Summary)
                _buildDailySummaryCard(currentStats),
                const SizedBox(height: 24),

                // 2. Middle Trend Area (Calorie Trend)
                const Text('近期熱量變化',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTrendChart(dailyStatsMap, sortedDates),
                const SizedBox(height: 24),

                // 3. Bottom Detail List (Meal Breakdown)
                Text('$currentDisplayDate 餐點詳情',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildMealList(currentStats.meals),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailySummaryCard(DailyStats stats) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('今日攝取',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${stats.totalCalories} / 2000 kcal',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('蛋白質: ${stats.totalProteins}g'),
                  Text('碳水: ${stats.totalCarbs}g'),
                  Text('脂肪: ${stats.totalFats}g'),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: stats.totalProteins.toDouble(),
                        title: '${stats.totalProteins}g',
                        radius: 40,
                        titleStyle: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.yellow[700],
                        value: stats.totalCarbs.toDouble(),
                        title: '${stats.totalCarbs}g',
                        radius: 40,
                        titleStyle: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.redAccent,
                        value: stats.totalFats.toDouble(),
                        title: '${stats.totalFats}g',
                        radius: 40,
                        titleStyle: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(
      Map<String, DailyStats> dailyStatsMap, List<String> sortedDates) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5000, // Adjust based on data max roughly
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.blueGrey,
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                return;
              }
              final index = barTouchResponse.spot!.touchedBarGroupIndex;
              if (index >= 0 && index < sortedDates.length) {
                setState(() {
                  selectedDate = sortedDates[index];
                });
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < sortedDates.length) {
                    // Show month/day
                    final date = sortedDates[index];
                    // Simple parsing assuming YYYY-MM-DD
                    if (date.length >= 10) {
                      return Text(date.substring(5),
                          style: const TextStyle(fontSize: 10));
                    }
                    return Text(date, style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1000,
            getDrawingHorizontalLine: (value) {
              if (value == 2000) {
                return FlLine(
                  color: Colors.green.withOpacity(0.5),
                  strokeWidth: 2,
                  dashArray: [5, 5],
                );
              }
              return FlLine(color: Colors.grey[300]);
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: sortedDates.asMap().entries.map((entry) {
            int index = entry.key;
            String date = entry.value;
            double calories =
                dailyStatsMap[date]!.totalCalories.toDouble();
            bool isHigh = calories > 2000;
            bool isSelected = selectedDate == date || (selectedDate == null && index == sortedDates.length -1);

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: calories,
                  color: isHigh ? Colors.redAccent : Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                  borderSide: isSelected ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMealList(List<MealRecord> meals) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.mealDescription,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${meal.calories} kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    
                    // Mini Stacked Bar for Macros explanation
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                              flex: meal.proteins,
                              child: Container(color: Colors.blue)),
                          Flexible(
                              flex: meal.carbs,
                              child: Container(color: Colors.yellow[700])),
                          Flexible(
                              flex: meal.fats,
                              child: Container(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 4),
                 Text('P:${meal.proteins}g C:${meal.carbs}g F:${meal.fats}g', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
