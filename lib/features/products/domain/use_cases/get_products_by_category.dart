import '../entities/product.dart';
import '../repositories/products_repository.dart';
class GetProductsByCategory { const GetProductsByCategory(this.repository); final ProductsRepository repository; Future<List<Product>> call(String category) => repository.getProductsByCategory(category); }
