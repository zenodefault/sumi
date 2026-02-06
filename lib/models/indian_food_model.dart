// lib/models/indian_food_model.dart
import 'package:hive/hive.dart';

part 'indian_food_model.g.dart';

@HiveType(typeId: 2)
class IndianFoodModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String hindiName;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String region;
  @HiveField(5)
  final double calories;
  @HiveField(6)
  final double protein;
  @HiveField(7)
  final double carbs;
  @HiveField(8)
  final double fats;
  @HiveField(9)
  final double fiber;
  @HiveField(10)
  final String servingSize;
  @HiveField(11)
  final List<String> keywords;
  @HiveField(12)
  final bool isVeg;
  @HiveField(13)
  final String imageUrl;
  @HiveField(14)
  final String dataSource;
  @HiveField(15)
  final String lastUpdated;
  @HiveField(16)
  final double? sugar;
  @HiveField(17)
  final int? novaGroup;
  @HiveField(18)
  final bool? isProcessed;

  IndianFoodModel({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.category,
    required this.region,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.servingSize,
    required this.keywords,
    required this.isVeg,
    required this.imageUrl,
    required this.dataSource,
    required this.lastUpdated,
    this.sugar,
    this.novaGroup,
    this.isProcessed,
  });

  factory IndianFoodModel.fromJson(Map<String, dynamic> json) {
    return IndianFoodModel(
      id: json['id'],
      name: json['name'],
      hindiName: json['hindiName'] ?? '',
      category: json['category'],
      region: json['region'],
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
      fiber: json['fiber'].toDouble(),
      servingSize: json['servingSize'],
      keywords: List<String>.from(json['keywords'] ?? []),
      isVeg: json['isVeg'] ?? true,
      imageUrl: json['imageUrl'],
      dataSource: json['dataSource'],
      lastUpdated: json['lastUpdated'] ?? '2017-12-31',
      sugar: json['sugar']?.toDouble(),
      novaGroup: json['novaGroup'],
      isProcessed: json['isProcessed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hindiName': hindiName,
      'category': category,
      'region': region,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'servingSize': servingSize,
      'keywords': keywords,
      'isVeg': isVeg,
      'imageUrl': imageUrl,
      'dataSource': dataSource,
      'lastUpdated': lastUpdated,
      'sugar': sugar,
      'novaGroup': novaGroup,
      'isProcessed': isProcessed,
    };
  }

  // Calculate nutrients for actual serving size
  Map<String, double> getNutrientsForServing(double servingMultiplier) {
    return {
      'calories': calories * servingMultiplier,
      'protein': protein * servingMultiplier,
      'carbs': carbs * servingMultiplier,
      'fats': fats * servingMultiplier,
      'fiber': fiber * servingMultiplier,
      if (sugar != null) 'sugar': sugar! * servingMultiplier,
    };
  }

  // Get serving size in grams
  double get servingWeightInGrams {
    try {
      final match = RegExp(r'(\d+\.?\d*)\s*g').firstMatch(servingSize);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
      // For non-gram units like cups, glasses, etc., return a default weight
      if (servingSize.toLowerCase().contains('cup')) {
        return 240.0; // Standard cup
      } else if (servingSize.toLowerCase().contains('glass')) {
        return 200.0; // Standard glass
      } else if (servingSize.toLowerCase().contains('bowl')) {
        return 200.0; // Standard bowl
      } else if (servingSize.toLowerCase().contains('plate')) {
        return 250.0; // Standard plate
      } else if (servingSize.toLowerCase().contains('piece')) {
        return 30.0; // Standard piece (like roti)
      }
      return 100.0; // Default to 100g
    } catch (e) {
      return 100.0;
    }
  }
}
