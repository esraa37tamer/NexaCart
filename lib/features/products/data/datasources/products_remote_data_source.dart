import 'package:dio/dio.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  ProductsRemoteDataSource(this.dio);
  final Dio dio;

  Future<List<ProductModel>> getProducts({int limit=30,int skip=0}) async => _list('/products', {'limit':limit,'skip':skip});
  Future<List<ProductModel>> searchProducts(String q) async => _list('/products/search', {'q':q,'limit':100});
  Future<List<ProductModel>> getProductsByCategory(String c) async => _list('/products/category/$c', {'limit':100});
  Future<ProductModel> getProduct(int id) async {
    try { final r=await dio.get<Map<String,dynamic>>('/products/$id'); return ProductModel.fromJson(r.data!); }
    on DioException catch(e){ throw AppException(e.message ?? 'Unable to load product'); }
  }
  Future<List<String>> getCategories() async {
    try {
      final r=await dio.get<List<dynamic>>('/products/categories');
      return (r.data ?? const []).map((e){ if(e is Map<String,dynamic>) return (e['slug'] ?? e['name'] ?? '').toString(); return e.toString(); }).where((e)=>e.isNotEmpty).toList();
    } on DioException catch(e){ throw AppException(e.message ?? 'Unable to load categories'); }
  }
  Future<List<ProductModel>> _list(String path, Map<String,dynamic> params) async {
    try {
      final r=await dio.get<Map<String,dynamic>>(path,queryParameters:params);
      final list=(r.data?['products'] as List<dynamic>? ?? const []);
      return list.map((e)=>ProductModel.fromJson(Map<String,dynamic>.from(e as Map))).toList();
    } on DioException catch(e){ throw AppException(e.message ?? 'Unable to load products'); }
  }
}
