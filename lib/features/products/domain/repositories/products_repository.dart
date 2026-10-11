import '../entities/product.dart';
abstract interface class ProductsRepository {
  Future<List<Product>> getProducts({int limit=30,int skip=0});
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
  Future<Product> getProduct(int id);
}
