import '../entities/product.dart';
import '../repositories/products_repository.dart';
class SearchProducts { const SearchProducts(this.repository); final ProductsRepository repository; Future<List<Product>> call(String query) => repository.searchProducts(query); }
