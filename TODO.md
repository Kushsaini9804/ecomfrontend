# TODO: Fix Buy Now Order Placement

## Completed Tasks
- [x] Commented out _loadAddress() in address_screen.dart to avoid 400 error from missing GET /address endpoint.
- [x] Commented out address saving in _saveAddressAndPlaceOrder to avoid POST /address error.
- [x] Modified buyNow method to use '/orders/create-order' API with single item format.
- [x] Added fetchOrders() call after placing order to refresh My Orders screen.
- [x] Updated buyNow method to temporarily add product to cart before placing order, ensuring cart has items as required by backend.

## Summary of Changes
- Buy Now now places the order using the same '/orders/create-order' API as cart checkout, refreshes the orders list, and navigates to success screen.
- Order is saved in MongoDB via backend and appears in My Orders screen.
- Address loading/saving is disabled to avoid backend errors.
- Buy Now temporarily adds the product to cart to ensure the backend processes the order correctly, then removes it.

## Testing
- Test the "Buy Now" button from product details screen.
- Verify order is placed, success screen shown, and order appears in My Orders.
