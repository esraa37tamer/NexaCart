import '../../../products/domain/entities/product.dart';
abstract interface class FavoritesRepository {
  Future<List<Product>> getFavorites(String userId);
  Future<void> saveFavorites(String userId, List<Product> products);
}
