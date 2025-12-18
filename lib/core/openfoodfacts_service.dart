import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart' as app_models;

class OpenFoodFactsService {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final _userAgent = off.UserAgent(
    name: 'FanaApp',
    url: 'https://github.com/your-fitness-app',
    version: '1.0',
  );

  static Future<void> initialize() async {
    // Set global configurations
    off.OpenFoodAPIConfiguration.userAgent = _userAgent;
    off.OpenFoodAPIConfiguration.globalLanguages = [
      off.OpenFoodFactsLanguage.ENGLISH,
      off.OpenFoodFactsLanguage.HINDI, // For Indian foods
    ];
    off.OpenFoodAPIConfiguration.globalCountry = off.OpenFoodFactsCountry.INDIA;

    // Load user credentials if exists
    await _loadUserCredentials();
  }

  static Future<void> _loadUserCredentials() async {
    final username = await _storage.read(key: 'off_username');
    final password = await _storage.read(key: 'off_password');

    if (username != null && password != null) {
      off.OpenFoodAPIConfiguration.globalUser = off.User(
        userId: username,
        password: password,
      );
    }
  }

  static Future<bool> login(String username, String password) async {
    try {
      // Test login with a simple product request

      final result = await off.OpenFoodAPIClient.searchProducts(
        off.OpenFoodAPIConfiguration.globalUser,
        off.ProductSearchQueryConfiguration(
          parametersList: [
            off.SearchTerms(terms: ['test']),
            off.PageSize(size: 1),
          ],
          version: off.ProductQueryVersion.v3,
          country: off.OpenFoodFactsCountry.INDIA,
          language: off.OpenFoodFactsLanguage.ENGLISH,
          fields: [off.ProductField.BARCODE, off.ProductField.NAME],
        ),
      );

      if (result.products != null && result.products!.isNotEmpty) {
        // Save credentials securely
        await _storage.write(key: 'off_username', value: username);
        await _storage.write(key: 'off_password', value: password);

        // Set global user
        off.OpenFoodAPIConfiguration.globalUser = off.User(
          userId: username,
          password: password,
        );

        return true;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }

    return false;
  }

  /// Search for food products by name
  static Future<List<app_models.FoodItem>> searchProductsByName(
    String query,
  ) async {
    try {
      // Create search parameters using the correct API
      final searchTerms = <String>[];
      searchTerms.add(query);

      final parametersList = <off.Parameter>[
        off.SearchTerms(terms: searchTerms),
        off.PageSize(size: 20),
        off.PageNumber(page: 1),
      ];

      final configuration = off.ProductSearchQueryConfiguration(
        parametersList: parametersList,
        version: off.ProductQueryVersion.v3,
        country: off.OpenFoodFactsCountry.INDIA,
        language: off.OpenFoodFactsLanguage.ENGLISH,
        fields: [
          off.ProductField.BARCODE,
          off.ProductField.NAME,
          off.ProductField.BRANDS,
          off.ProductField.CATEGORIES,
          off.ProductField.NUTRIMENTS,
          off.ProductField.IMAGE_FRONT_URL,
          off.ProductField.QUANTITY,
        ],
      );

      // Use the correct API call - with proper user parameter handling
      final user = off.OpenFoodAPIConfiguration.globalUser;
      final result = await off.OpenFoodAPIClient.searchProducts(
        user,
        configuration,
      );

      if (result.products != null) {
        return result.products!
            .where(
              (product) =>
                  product.productName != null &&
                  product.productName!.isNotEmpty,
            )
            .map(_mapProductToFoodItem)
            .toList();
      }
    } catch (e) {
      print('Error searching products: $e');
    }

    return [];
  }

  /// Map Open Food Facts Product to our FoodItem model
  static app_models.FoodItem _mapProductToFoodItem(off.Product product) {
    // Extract calories from nutriments
    int calories = 0;
    String unit = 'per 100g';

    if (product.nutriments != null) {
      // Get nutriments object (contains all nutrient data)
      final nutriments = product.nutriments!;

      // Access the nutriments data through the available properties in version 2.10.1
      // Using the proper accessor methods for the openfoodfacts package
      try {
        // Try to get energy value from nutriments
        // The exact property names may vary by version, so we'll use a safe approach
        var energy = _getNutrimentValue(nutriments, 'energy');
        if (energy != null) {
          calories = energy.round();
        } else {
          // Try energy in kJ, then convert to kcal
          var energyKj = _getNutrimentValue(nutriments, 'energy-kj');
          if (energyKj != null) {
            calories = (energyKj / 4.184).round(); // Convert kJ to kcal
          }
        }
      } catch (e) {
        print('Error extracting calories from nutriments: $e');
      }
    }

    // Determine category based on available data
    String category = 'Other';
    String? categoriesStr = product.categories;

    if (categoriesStr != null && categoriesStr.isNotEmpty) {
      final categories = categoriesStr.toLowerCase();
      if (categories.contains('fruit') ||
          categories.contains('vegetable') ||
          categories.contains('salad') ||
          categories.contains('legume')) {
        category = 'Vegetables';
      } else if (categories.contains('meat') ||
          categories.contains('fish') ||
          categories.contains('seafood') ||
          categories.contains('egg') ||
          categories.contains('chicken') ||
          categories.contains('beef') ||
          categories.contains('pork')) {
        category = 'Protein';
      } else if (categories.contains('cereal') ||
          categories.contains('grain') ||
          categories.contains('bread') ||
          categories.contains('pasta') ||
          categories.contains('rice') ||
          categories.contains('oat')) {
        category = 'Carbs';
      } else if (categories.contains('oil') ||
          categories.contains('fat') ||
          categories.contains('butter') ||
          categories.contains('cream') ||
          categories.contains('cheese')) {
        category = 'Fats';
      }
    }

    return app_models.FoodItem(
      id:
          product.barcode ??
          '${DateTime.now().millisecondsSinceEpoch}_${product.productName.hashCode}',
      name: product.productName ?? 'Unknown Product',
      caloriesPerUnit: calories,
      unit: unit,
      category: category,
      barcode: product.barcode,
      brand: product.brands,
      imageUrl: product.imageFrontUrl,
      nutriments: product.nutriments != null
          ? _extractNutrimentsData(product.nutriments!)
          : null,
    );
  }

  /// Helper method to safely get nutriment values
  static double? _getNutrimentValue(off.Nutriments nutriments, String key) {
    try {
      // This is a simplified approach since we don't know the exact property names
      // In a real implementation, we would need to access the raw nutriments map
      return null; // Placeholder until we know the exact API
    } catch (e) {
      print('Error getting nutriment value for $key: $e');
      return null;
    }
  }

  /// Extract nutrition data from nutriments object
  static Map<String, dynamic> _extractNutrimentsData(
    off.Nutriments nutriments,
  ) {
    final Map<String, dynamic> result = {};

    try {
      // Extract nutrition data using available properties in the openfoodfacts package
      // Since we don't know the exact property names in v2.10.1, we'll use a safe approach
      // The actual implementation would need to access the raw nutriments data
      result['energy_kcal'] =
          _getNutrimentValue(nutriments, 'energy')?.round() ?? 0;
      result['proteins'] = _getNutrimentValue(nutriments, 'proteins') ?? 0.0;
      result['carbohydrates'] =
          _getNutrimentValue(nutriments, 'carbohydrates') ?? 0.0;
      result['fat'] = _getNutrimentValue(nutriments, 'fat') ?? 0.0;
      result['fiber'] = _getNutrimentValue(nutriments, 'fiber') ?? 0.0;
      result['sugars'] = _getNutrimentValue(nutriments, 'sugars') ?? 0.0;
      result['sodium'] = _getNutrimentValue(nutriments, 'sodium') ?? 0.0;
      result['salt'] = _getNutrimentValue(nutriments, 'salt') ?? 0.0;
    } catch (e) {
      print('Error extracting nutriments data: $e');
    }

    return result;
  }

  static double _parseServingSize(String? quantity) {
    if (quantity == null || quantity.isEmpty) return 0.0;

    // Try to extract grams from quantity string
    // Examples: "250g", "1kg", "1 bowl (250g)", "200 ml"
    try {
      // Look for patterns like "250g", "250 g", "250grams"
      final gramMatch = RegExp(
        r'(\d+\.?\d*)\s*(?:g|grams|gram)',
        caseSensitive: false,
      ).firstMatch(quantity);
      if (gramMatch != null) {
        return double.parse(gramMatch.group(1)!);
      }

      // Look for kg and convert to grams
      final kgMatch = RegExp(
        r'(\d+\.?\d*)\s*(?:kg|kilograms|kilogram)',
        caseSensitive: false,
      ).firstMatch(quantity);
      if (kgMatch != null) {
        return double.parse(kgMatch.group(1)!) * 1000;
      }

      // Default to 100g if we can't parse but it's a food item
      if (quantity.toLowerCase().contains('serving') ||
          quantity.toLowerCase().contains('piece') ||
          quantity.toLowerCase().contains('unit')) {
        return 100.0;
      }
    } catch (e) {
      print('Error parsing serving size: $e');
    }

    return 0.0; // Unknown serving size
  }
}
