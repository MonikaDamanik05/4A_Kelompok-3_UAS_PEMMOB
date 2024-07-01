// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/screens/edit_ulasan.dart';

class ReadUlasanScreen extends StatefulWidget {
  const ReadUlasanScreen({super.key});

  @override
  _ReadUlasanScreenState createState() => _ReadUlasanScreenState();
}

class _ReadUlasanScreenState extends State<ReadUlasanScreen> {
  List<dynamic> ulasanList = [];
  List<dynamic> filteredUlasanList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUlasan();
  }

  Future<void> fetchUlasan() async {
    final response = await http.get(Uri.parse('http://192.168.53.185:5000/api/v1/ulasan/read'));

    if (response.statusCode == 200) {
      setState(() {
        ulasanList = json.decode(response.body)['datas'];
        filteredUlasanList = ulasanList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load ulasan');
    }
  }

  void filterUlasan(String query) {
    setState(() {
      filteredUlasanList = ulasanList
          .where((ulasan) =>
              ulasan['nama_kuliner'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterUlasan(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search by Kuliner Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredUlasanList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/mangan.png'),
                              radius: 40.0,
                            ),
                            const SizedBox(width: 24.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredUlasanList[index]['username'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Kuliner: ${filteredUlasanList[index]['nama_kuliner']}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    filteredUlasanList[index]['deskripsi'],
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      int starCount;
                                      try {
                                        starCount = int.parse(filteredUlasanList[index]['bintang']);
                                      } catch (e) {
                                        starCount = 0;
                                      }
                                      return Icon(
                                        starIndex < starCount ? Icons.star : Icons.star_border,
                                        color: Colors.yellow[600],
                                        size: 24.0,
                                      );
                                    }),
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditUlasanScreen()),
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}