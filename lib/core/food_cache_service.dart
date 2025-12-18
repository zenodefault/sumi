import 'dart:collection';
import '../core/models.dart';

class FoodCacheService {
  static final FoodCacheService _instance = FoodCacheService._internal();
  factory FoodCacheService() => _instance;
  FoodCacheService._internal();

  // A simple LRU cache for food items
  final LinkedHashMap<String, FoodItem> _cache = LinkedHashMap();
  static const int _maxCacheSize = 50; // Maximum number of items to cache

  /// Get a food item from cache by ID or barcode
  FoodItem? getFromCache(String id) {
    return _cache[id];
  }

  /// Add a food item to cache
  void addToCache(FoodItem foodItem) {
    // Remove the item if it already exists to update its position
    _cache.remove(foodItem.id);
    
    // Add the item to the cache
    _cache[foodItem.id] = foodItem;
    
    // If cache exceeds max size, remove the oldest item
    if (_cache.length > _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
  }

  /// Clear the entire cache
  void clearCache() {
    _cache.clear();
  }

 /// Get all cached items
  List<FoodItem> getAllCachedItems() {
    return _cache.values.toList();
  }

  /// Check if an item exists in cache
  bool isInCache(String id) {
    return _cache.containsKey(id);
  }
}