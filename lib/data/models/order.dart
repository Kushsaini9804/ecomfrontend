class Order {
  final String orderId;
  final double total;
  final String status;
  final String paymentType;
  final DateTime createdAt;
  final Address address;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.total,
    required this.status,
    required this.paymentType,
    required this.createdAt,
    required this.address,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'],
      paymentType: json['payment_type'],
      createdAt: DateTime.parse(json['createdAt']),
      address: Address.fromJson(json['address']),
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

/* =====================
   ADDRESS MODEL
===================== */
class Address {
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zip;

  Address({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
    );
  }
}

/* =====================
   ORDER ITEM MODEL
===================== */
class OrderItem {
  final String title;
  final int qty;
  final double price;
  final String? image;

  OrderItem({
    required this.title,
    required this.qty,
    required this.price,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      title: json['title'],
      qty: json['qty'],
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
    );
  }
}
