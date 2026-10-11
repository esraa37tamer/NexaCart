import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';
class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this.remote); final ProductsRemoteDataSource remote;
  @override Future<List<Product>> getProducts({int limit=30,int skip=0}) => remote.getProducts(limit:limit,skip:skip);
  @override Future<List<Product>> searchProducts(String query)=>remote.searchProducts(query);
  @override Future<List<String>> getCategories()=>remote.getCategories();
  @override Future<List<Product>> getProductsByCategory(String category)=>remote.getProductsByCategory(category);
  @override Future<Product> getProduct(int id)=>remote.getProduct(id);
}
