import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:crud_sqflite/db/notes_db.dart';
import 'package:crud_sqflite/model/restaurant.dart';
import 'package:crud_sqflite/page/edit_note_page.dart';
import 'package:crud_sqflite/page/note_detail_page.dart';
import 'package:crud_sqflite/widget/note_card_widget.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  late List<Restaurant> restaurants;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshRestaurants();
  }

  @override
  void dispose() {
    RestaurantsDatabase.instance.close();

    super.dispose();
  }

  Future refreshRestaurants() async {
    setState(() => isLoading = true);

    restaurants = await RestaurantsDatabase.instance.readAllRestaurants();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Restaurants',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          actions: const [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(width: 12)
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: isLoading
              ? const CircularProgressIndicator()
              : (restaurants.isEmpty
                  ? const Center(
                      child: Text(
                        'No Restaurants 🧑‍🦯',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  : buildRestaurants()),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditRestaurantPage()),
            );

            refreshRestaurants();
          },
        ),
      );

  Widget buildRestaurants() => StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        restaurants.length,
        (index) {
          final restaurant = restaurants[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RestaurantDetailPage(restaurantId: restaurant.id!),
                ));

                refreshRestaurants();
              },
              child: RestaurantCardWidget(restaurant: restaurant, index: index),
            ),
          );
        },
      ));
}
