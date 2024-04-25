import 'package:flutter/material.dart';
import 'package:crud_sqflite/db/notes_db.dart';
import 'package:crud_sqflite/model/restaurant.dart';
import 'package:crud_sqflite/widget/note_form_widget.dart';

class AddEditRestaurantPage extends StatefulWidget {
  final Restaurant? restaurant;
  const AddRestaurantPage({
    super.key,
    this.Restaurant
  });

  @override
  State<AddEditRestaurantPage> createState() => _AddEditRestaurantPageState();
}

class _AddEditRestaurantPageState extends State<AddEditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late int rating;

  @override
  void initState() {
    super.initState();

    name = widget.restaurant?.name ?? '';
    description = widget.restaurant?.description ?? '';
    rating = widget.restaurant?.rating ?? 0;
  }

  Widget buildButton() {
    final isFormValid = name.isNotEmpty && description.isNotEmpty && rating.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade300,
        ),
        onPressed: addOrUpdateRestaurant,
        child: const Text(
          'Save',
          style: TextStyle(
              color: Colors.black54
          ),
        ),
      ),
    );
  }

  void addOrUpdateRestaurant() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.restaurant != null;

      if (isUpdating) {
        await updateRestaurant();
      } else {
        await addRestaurant();
      }

      if(mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future updateRestaurant() async {
    final restaurant = widget.restaurant!.copy(
      name: name,
      description: description,
      rating: rating,
    );

    await RestaurantsDatabase.instance.update(restaurant);
  }

  Future addRestaurant() async {
    final restaurant = Restaurant(
      name: name,
      rating: rating,
      description: description,
    );

    await RestaurantsDatabase.instance.create(restaurant);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: RestaurantFormWidget(
        rating: rating,
        name: name,
        description: description,
        onChangedRating: (rating) => setState(() => this.rating = rating),
        onChangedName: (name) => setState(() => this.name = name),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );
}
