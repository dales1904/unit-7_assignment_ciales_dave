import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
      Uri.parse("https://digi-api.com/api/v1/digimon?pageSize=20"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<dynamic>.from(data['content']);
    } else {
      throw Exception("Failed to load Digimon data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digimon List"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ExpansionTile(
                  title: Text(item['name'] ?? 'No Name'),
                  leading: Image.network(
                    item['image'] ?? 'https://digi-api.com/images/digimon/w/default.png', 
                    width: 50, 
                    height: 50, 
                    fit: BoxFit.cover, 
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Link to Digimon:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item['href'] ?? 'No Link',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
