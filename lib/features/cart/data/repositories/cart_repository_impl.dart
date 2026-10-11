import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this.local);
  final CartLocalDataSource local;
  @override List<CartItem> getItems(String userId) => local.getItems(userId);
  @override void saveItems(String userId, List<CartItem> items) => local.saveItems(userId, items);
  @override void clear(String userId) => local.clear(userId);
}
