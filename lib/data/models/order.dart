class Order { 
  final String orderId;
  final double total;
  final String status;
  final String paymentType;
  final DateTime createdAt;
  final Address address;
  final List<OrderItem> items;
  final String? image; // Optional: representative image URL

  Order({
    required this.orderId,
    required this.total,
    required this.status,
    required this.paymentType,
    required this.createdAt,
    required this.address,
    required this.items,
    required this.image,
  });

factory Order.fromJson(Map<String, dynamic> json) {
  return Order(
    orderId: json['_id'] ?? json['orderId'] ?? '',
    total: (json['total'] ?? 0).toDouble(),
    status: json['status'] ?? 'Pending',
    paymentType: json['payment_type'] ?? json['paymentType'] ?? 'COD',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),

    address: json['address'] != null
        ? Address.fromJson(json['address'])
        : Address(
            fullName: '',
            phone: '',
            pincode: '',
            city: '',
            state: '',
            addressLine: '',
          ),

    items: (json['items'] as List? ?? [])
        .map((e) => OrderItem.fromJson(e))
        .toList(),

    image: json['image'],
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
      title: json['title'] ?? '',
      qty: json['qty'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
    );
  }
}
  class Address {
    final String fullName;
    final String phone;
    final String pincode;
    final String city;
    final String state;
    final String addressLine;
    final String? landmark;

    Address({
      required this.fullName,
      required this.phone,
      required this.pincode,
      required this.city,
      required this.state,
      required this.addressLine,
      this.landmark,
    });

    factory Address.fromJson(Map<String, dynamic> json) {
      return Address(
        fullName: json['fullName'] ?? '',
        phone: json['phone'] ?? '',
        pincode: json['pincode'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        addressLine: json['addressLine'] ?? '',
        landmark: json['landmark'],
      );
    }
  }

