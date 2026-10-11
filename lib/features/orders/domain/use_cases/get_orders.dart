import '../entities/order.dart';
import '../repositories/orders_repository.dart';
class GetOrders {
  const GetOrders(this.repository);
  final OrdersRepository repository;
  Future<List<OrderEntity>> call(String userId) => repository.getOrders(userId);
}
