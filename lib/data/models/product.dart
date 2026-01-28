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
  final String category;

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
    required this.category,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // id: json['_id'] ?? '',
      id: json['_id']?.toString() ?? '', // 🔥 THIS WAS THE BUG
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
      category: json['category'] ?? 'All',

      
    );
  }
   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
