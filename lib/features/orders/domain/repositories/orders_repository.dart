import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
abstract interface class OrdersRepository {
  Future<List<OrderEntity>> getOrders(String userId);
  Future<OrderEntity> createOrder(String userId, List<CartItem> items);
}
