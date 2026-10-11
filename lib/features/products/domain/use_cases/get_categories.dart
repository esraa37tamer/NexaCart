import '../repositories/products_repository.dart';
class GetCategories { const GetCategories(this.repository); final ProductsRepository repository; Future<List<String>> call() => repository.getCategories(); }
