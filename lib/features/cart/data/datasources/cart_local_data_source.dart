import '../../../../core/storage/realm_database.dart';
import '../../../../core/storage/realm_models.dart';
import '../../domain/entities/cart_item.dart';
class CartLocalDataSource {
  CartLocalDataSource(this.database);
  final RealmDatabase database;
  List<CartItem> getItems(String userId) => database.forUser(userId).all<CartItemRecord>().map(
        (r) => CartItem(productId: r.productId, title: r.title, thumbnail: r.thumbnail, price: r.price, quantity: r.quantity),
      ).toList();
  void saveItems(String userId, List<CartItem> items) {
    final realm = database.forUser(userId);
    realm.write(() {
      realm.deleteMany(realm.all<CartItemRecord>());
      for (final i in items) {
        realm.add(CartItemRecord(i.productId, i.title, i.thumbnail, i.price, i.quantity));
      }
    });
  }
  void clear(String userId) {
    final realm = database.forUser(userId);
    realm.write(() => realm.deleteMany(realm.all<CartItemRecord>()));
  }
}
