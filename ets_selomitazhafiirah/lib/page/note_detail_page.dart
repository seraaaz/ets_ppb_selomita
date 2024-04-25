import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crud_sqflite/db/notes_db.dart';
import 'package:crud_sqflite/model/restaurant.dart';
import 'package:crud_sqflite/page/edit_note_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Restaurant restaurant;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshRestaurant();
  }

  Future refreshRestaurant() async {
    setState(() => isLoading = true);

    restaurant = await RestaurantsDatabase.instance.readRestaurant(widget.restaurantId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            restaurant.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            restaurant.description,
            style:
            const TextStyle(color: Colors.white70, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined, color: Colors.white,),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditRestaurantPage(restaurant: restaurant),
        ));

        refreshRestaurant();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete, color: Colors.white,),
    onPressed: () async {
      await RestaurantsDatabase.instance.delete(widget.restaurantId);

      if(mounted) {
        Navigator.of(context).pop();
      }
    },
  );
}