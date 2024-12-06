import 'package:flutter/material.dart';
import 'package:responsi/screens/meals_screen.dart';
import '../../services/shared_preferences_service.dart';
import '../auth/login_screen.dart';
import '../../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _prefsService = SharedPreferencesService();
  final ApiService apiService = ApiService();
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    String? user = await _prefsService.getUser();
    setState(() {
      username = user ?? '';
    });
  }

  void _logout() async {
    await _prefsService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meal Categories'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hello, $username', style: TextStyle(fontSize: 18)),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: _logout,
                    child:
                        Text('Logout', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final categories = snapshot.data['categories'];
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Image.network(
                              category['strCategoryThumb'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(category['strCategory']),
                            subtitle: Text(category['strCategoryDescription']),
                            onTap: () {
                              // Navigate to meals screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealsScreen(
                                      category: category['strCategory']),
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
            ),
          ],
        ));
  }
}
