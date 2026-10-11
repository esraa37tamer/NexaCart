import '../../../products/domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this.local);
  final FavoritesLocalDataSource local;
  @override Future<List<Product>> getFavorites(String userId)=>local.getFavorites(userId);
  @override Future<void> saveFavorites(String userId,List<Product> products)=>local.saveFavorites(userId,products);
}
