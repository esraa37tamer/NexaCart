import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';
class CreateOrder {
  const CreateOrder(this.repository);
  final OrdersRepository repository;
  Future<OrderEntity> call(String userId, List<CartItem> items) => repository.createOrder(userId, items);
}
