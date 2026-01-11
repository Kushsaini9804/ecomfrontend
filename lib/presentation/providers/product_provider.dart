// // // import 'package:flutter/material.dart';
// // // import '../../core/services/api_service.dart';
// // // import '../../data/models/product.dart';

// // // class ProductProvider extends ChangeNotifier {
// // //   List<Product> _products = [];
// // //   bool loading = false;

// // //   List<Product> get products => _products;

// // //   Future<void> fetchProducts() async {
// // //     loading = true;
// // //     notifyListeners();

// // //     try {
// // //       final res = await ApiService.get('/products/get-products');

// // //       _products = (res['data'] as List)
// // //           .map((e) => Product.fromJson(e))
// // //           .toList();
// // //     } catch (e) {
// // //       debugPrint('Product fetch error: $e');
// // //       _products = [];
// // //     }

// // //     loading = false;
// // //     notifyListeners();
// // //   }

// // //   List<Product> search(String query) {
// // //     if (query.isEmpty) return _products;

// // //     return _products
// // //         .where((p) =>
// // //             p.title.toLowerCase().contains(query.toLowerCase()))
// // //         .toList();
// // //   }
// // // }


// // // lib/presentation/providers/product_provider.dart

// // import 'package:flutter/material.dart';
// // import '../../core/services/api_service.dart';
// // import '../../data/models/product.dart';

// // class ProductProvider extends ChangeNotifier {
// //   List<Product> _products = [];
// //   bool loading = false;

// //   String selectedCategory = "All";

// //   List<Product> get products => _products;

// //   Future<void> fetchProducts({String category = "All"}) async {
// //     loading = true;
// //     selectedCategory = category;
// //     notifyListeners();

// //     try {
// //       final query = category == "All"
// //           ? '/products/get-products'
// //           : '/products/get-products?category=$category';

// //       final res = await ApiService.get(query);

// //       _products = (res['data'] as List)
// //           .map((e) => Product.fromJson(e))
// //           .toList();
// //     } catch (e) {
// //       debugPrint('Product fetch error: $e');
// //       _products = [];
// //     }

// //     loading = false;
// //     notifyListeners();
// //   }

// //   List<Product> search(String query) {
// //     if (query.isEmpty) return _products;

// //     return _products
// //         .where((p) =>
// //             p.title.toLowerCase().contains(query.toLowerCase()))
// //         .toList();
// //   }
// // }

// import 'package:flutter/material.dart';
// import '../../core/services/api_service.dart';
// import '../../data/models/product.dart';

// class ProductProvider extends ChangeNotifier {
//   List<Product> _allProducts = [];
//   String selectedCategory = "All";
//   bool loading = false;

//   /// ✅ Filtered products (used by UI)
//   List<Product> get products {
//     if (selectedCategory == "All") {
//       return _allProducts;
//     }
//     return _allProducts
//         .where((p) =>
//             p.category.toLowerCase() ==
//             selectedCategory.toLowerCase())
//         .toList();
//   }

//   /// ✅ Fetch ALL products once
//   Future<void> fetchProducts() async {
//     loading = true;
//     notifyListeners();

//     try {
//       final res = await ApiService.get('/products/get-products');

//       _allProducts = (res['data'] as List)
//           .map((e) => Product.fromJson(e))
//           .toList();
//     } catch (e) {
//       debugPrint('Product fetch error: $e');
//       _allProducts = [];
//     }

//     loading = false;
//     notifyListeners();
//   }

//   /// ✅ Change category (called from Category screen)
//   void setCategory(String category) {
//     selectedCategory = category;
//     notifyListeners();
//   }

//   /// ✅ Search within selected category
//   List<Product> search(String query) {
//     final list = products;

//     if (query.isEmpty) return list;

//     return list
//         .where((p) =>
//             p.title.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }


import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool loading = false;

  String selectedCategory = "All";

  List<Product> get products => _products;

  Future<void> fetchProducts({String category = "All"}) async {
    loading = true;
    selectedCategory = category;
    notifyListeners();

    try {
      String endpoint = '/products/get-products';

      if (category != "All") {
        endpoint += '?category=$category';
      }

      final res = await ApiService.get(endpoint);

      _products = (res['data'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Product fetch error: $e');
      _products = [];
    }

    loading = false;
    notifyListeners();
  }

  /// ✅ For CategoryScreen
  void setCategory(String category) {
    fetchProducts(category: category);
  }

  /// ✅ FIX FOR SEARCH
  List<Product> search(String query) {
    if (query.isEmpty) return _products;

    return _products
        .where(
          (p) => p.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

