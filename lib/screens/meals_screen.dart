import 'package:flutter/material.dart';
import 'package:responsi/screens/detail_screen.dart';
import 'package:responsi/services/api_services.dart';

class MealsScreen extends StatelessWidget {
  final String category;
  final ApiService apiService = ApiService();

  MealsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Meals'),
      ),
      body: FutureBuilder(
        future: apiService.getMeals(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final meals = snapshot.data['meals'];

            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(meals[index]['strMealThumb']),
                    title: Text(meals[index]['strMeal']),
                    onTap: () {
                      // Navigate to meal detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MealDetailScreen(mealId: meals[index]['idMeal']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
