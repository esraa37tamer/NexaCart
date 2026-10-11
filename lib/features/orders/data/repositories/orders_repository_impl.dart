import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_data_source.dart';
class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this.local);
  final OrdersLocalDataSource local;
  @override Future<List<OrderEntity>> getOrders(String userId)=>local.getOrders(userId);
  @override Future<OrderEntity> createOrder(String userId,List<CartItem> items)=>local.createOrder(userId,items);
}
