import '../entities/product.dart';
import '../repositories/products_repository.dart';
class GetProduct { const GetProduct(this.repository); final ProductsRepository repository; Future<Product> call(int id) => repository.getProduct(id); }
