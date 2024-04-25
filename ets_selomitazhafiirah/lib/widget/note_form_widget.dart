import 'package:flutter/material.dart';

class RestaurantFormWidget extends StatelessWidget {
  final int? rating;
  final String? name;
  final String? description;
  final ValueChanged<int> onChangedRating;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDescription;

  const RestaurantFormWidget({
    super.key,
    this.rating = 0,
    this.name = '',
    this.description = '',
    required this.onChangedRating,
    required this.onChangedName,
    required this.onChangedDescription,
  });

  Widget buildName() => TextFormField(
    maxLines: 1,
    initialValue: name,
    style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24
    ),
    decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Name',
        hintStyle: TextStyle(
            color: Colors.white70
        )
    ),
    validator: (name) =>
    name != null &&
        name.isEmpty ? 'The name cannot be empty' : null,
    onChanged: onChangedName,
  );

  Widget buildDescription() => TextFormField(
    initialValue: description,
    style: const TextStyle(
        color: Colors.white60,
        fontSize: 18
    ),
    decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something...',
        hintStyle: TextStyle(
            color: Colors.white60
        )
    ),
    validator: (name) =>
    name != null &&
        name.isEmpty ? 'The description cannot be empty' : null,
    onChanged: onChangedDescription,
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (rating ?? 0).toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (rating) => onChangedRating(rating.toInt()),
                  activeColor: Colors.blue,
                ),
              )
            ],
          ),
          buildName(),
          const SizedBox(height: 8),
          buildDescription(),
          const SizedBox(height: 16)
        ],
      ),
    ),
  );
}
