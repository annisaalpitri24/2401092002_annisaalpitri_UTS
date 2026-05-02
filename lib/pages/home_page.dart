import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_services.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Meal> categoryList = [];
  List<Meal> filteredList = [];

  bool isGrid = false;
  bool isLoading = true;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await CategoryService.getCategory();
    setState(() {
      categoryList = data;
      filteredList = data;
      isLoading = false;
    });
  }

  void search(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredList = categoryList.where((w) {
          return w.strMeal.toLowerCase().contains(keyword.toLowerCase()) ||
              w.strArea.toLowerCase().contains(keyword.toLowerCase()) ||
              w.strCountry.toLowerCase().contains(keyword.toLowerCase());
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Makanan"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Search makanan...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: search,
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? const Center(child: Text("Maaf, masakan tidak ditemukan"))
                : isGrid
                ? buildGrid()
                : buildList(),
          )
        ],
      ),
    );
  }


  Widget buildList() {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final w = filteredList[index];

        return Card(
          child: ListTile(
            leading: Image.network(
              w.strMealThumb,
              width: 50,
              errorBuilder: (c, e, s) =>
              const Icon(Icons.broken_image),
            ),
            title: Text(w.strMeal),
            subtitle: Text("${w.strArea} - ${w.strCountry}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(meal: w),
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: filteredList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final w = filteredList[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(meal: w),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    w.strMealThumb,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w.strMeal,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${w.strArea} - ${w.strCountry}",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}