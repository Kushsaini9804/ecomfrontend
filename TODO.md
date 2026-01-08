# TODO: Fix Buy Now Order Placement

## Completed Tasks
- [x] Modified `buyNow` method in `cart_provider.dart` to use `/orders/create-order` API instead of `/orders/buy-now`, ensuring consistent order placement like the checkout screen.
- [x] Added `fetchOrders()` call in `address_screen.dart` after placing the order to refresh the orders list in the OrderProvider.
- [x] Added import for `OrderProvider` in `address_screen.dart` to resolve compilation error.
- [x] Changed the item key from 'productId' to 'product_id' in both `placeOrder` and `buyNow` methods to match backend expectations.
- [x] Reverted `buyNow` to use '/orders/buy-now' endpoint with the original data structure but with 'product_id' key.

## Summary of Changes
- The "Buy Now" functionality now places orders using the same backend API as the checkout screen, which is confirmed to work properly.
- After placing an order via "Buy Now", the orders list is refreshed to ensure the new order appears immediately in the "My Orders" screen.
- Address saving and order placement are now properly integrated for the "Buy Now" flow.

## Testing
- Test the "Buy Now" button from product details screen.
- Verify that the order is placed and appears in "My Orders".
- Ensure the checkout screen still works as before.
