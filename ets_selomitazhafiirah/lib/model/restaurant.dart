const String tableNotes = 'restaurant';

class RestaurantFields {
  static final List<String> values = [
    id, name, description, rating
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String rating = 'rating';
}

class Restaurant {
  final int? id;
  final String name;
  final String description;
  final int rating;



  const Restaurant({
    this.id,
    required this.name,
    required this.description,
    required this.rating
  });

  Restaurant copy({
    int? id,
    String? name,
    String? description,
    int? rating,

  }) => Restaurant(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    rating: rating ?? this.rating,

  );

  static Restaurant fromJson(Map<String, Object?> json) => Restaurant(
    id: json[RestaurantFields.id] as int?,
    name: json[RestaurantFields.name] as String,
    description: json[RestaurantFields.description] as String,
    rating: json[RestaurantFields.rating] as int,
  );

  Map<String, Object?> toJson() => {
    RestaurantFields.id: id,
    RestaurantFields.name: name,
    RestaurantFields.description: description,
    RestaurantFields.rating: rating,
  };

}