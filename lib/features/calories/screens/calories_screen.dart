import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import '../../../core/utils.dart';
import 'food_search_screen.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
 State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> with TickerProviderStateMixin {
  int _activeTab = 0;

  late TabController _tabController;
  int _initialActiveTab = 0;

  @override
  void initState() {
    super.initState();
    
    // Initialize the tab controller immediately with default values to prevent LateInitializationError
    _tabController = TabController(length: 2, vsync: this, initialIndex: _initialActiveTab);
    
    // Defer accessing ModalRoute.of(context) until the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Map<String, dynamic> && arguments.containsKey('activeTab')) {
        String tabName = arguments['activeTab'] as String;
        if (tabName == 'Indian Foods') {
          _initialActiveTab = 1; // Assuming Indian Foods is the second tab
        }
      }
      // Update the state after we've determined the initial tab
      if (mounted) {
        setState(() {
          _activeTab = _initialActiveTab;
        });
        // Update the tab controller index if needed
        _tabController.animateTo(_initialActiveTab);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Food Log'),
            Tab(text: 'Indian Foods'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Food Log Tab
          _buildFoodLogTab(provider),
          
          // Indian Foods Tab
          _buildIndianFoodsTab(provider),
        ],
      ),
    );
  }

  Widget _buildFoodLogTab(FitnessProvider provider) {
    // Get today's log to show consumed calories
    int consumedToday = provider.getTodaysTotalCalories(); // Updated to use provider's method
    int goal = 2500; // Daily goal
    double progress = goal > 0 ? consumedToday / goal : 0;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Progress section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${consumedToday.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")} / ${goal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")} kcal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFF333333),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.9 ? Colors.red : Colors.green
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: progress > 0.9 ? Colors.red : Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Add food button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoodSearchScreen()),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Search & Add Food'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          
          // Today's food logs
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Food Log',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Show food logs
                Expanded(
                  child: Consumer<FitnessProvider>(
                    builder: (context, provider, child) {
                      final foodLogs = provider.getTodaysFoodLogs();
                      
                      if (foodLogs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'No food items logged yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: foodLogs.length,
                        itemBuilder: (context, index) {
                          final foodLog = foodLogs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodLog.foodName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${foodLog.quantity} ${foodLog.unit} • ${foodLog.getTotalCalories()} kcal',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () async {
                                    await provider.deleteFoodLog(foodLog.id);
                                    await provider.updateDailyLogWithCalories(); // Update daily calorie count
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndianFoodsTab(FitnessProvider provider) {
    // Get Indian food database
    final indianFoods = AppUtils.getIndianFoodDatabase();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Indian Foods Database',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: indianFoods.length,
              itemBuilder: (context, index) {
                final food = indianFoods[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${food.caloriesPerUnit} kcal per ${food.unit}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          food.category,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}