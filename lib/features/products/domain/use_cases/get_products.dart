import '../entities/product.dart';
import '../repositories/products_repository.dart';
class GetProducts { const GetProducts(this.repository); final ProductsRepository repository; Future<List<Product>> call({int limit=30,int skip=0}) => repository.getProducts(limit: limit, skip: skip); }
