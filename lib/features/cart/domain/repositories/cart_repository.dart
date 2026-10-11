import '../entities/cart_item.dart';
abstract interface class CartRepository {
  List<CartItem> getItems(String userId);
  void saveItems(String userId, List<CartItem> items);
  void clear(String userId);
}
