import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<List<MealRecord>> futureMealRecords;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('統計資訊'),
      ),
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

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final record = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.date,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('描述: ${record.mealDescription}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('熱量: ${record.calories} kcal'),
                          Text('蛋白質: ${record.proteins} g'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('碳水: ${record.carbs} g'),
                          Text('脂肪: ${record.fats} g'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
