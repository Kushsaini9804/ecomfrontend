// lib/data/models/product.dart
class Product {
  final String id;
  final String title;
  final double price;
  final double? discount;
  final String image;
  // final List<String>? images;
  final List<String>? colors;
  final List<String>? highlights;
  final String? description;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.discount,
    required this.image,
    // this.images,
    this.colors,
    this.highlights,
    this.description,
    this.rating = 4.5,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      // images: (json['images'] as List<dynamic>?)
      //     ?.map((e) => e.toString())
      //     .toList(),
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
    );
  }
}
