import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../products/domain/entities/product.dart';
class FavoritesLocalDataSource {
  FavoritesLocalDataSource(this.preferences);
  final SharedPreferencesAsync preferences;
  String _key(String userId) => 'favorites_$userId';
  Future<List<Product>> getFavorites(String userId) async {
    final raw = await preferences.getString(_key(userId));
    if (raw == null || raw.isEmpty) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e){
      final j=Map<String,dynamic>.from(e as Map);
      return Product(
        id:j['id'] as int,title:j['title'] as String,description:j['description'] as String,
        category:j['category'] as String,price:(j['price'] as num).toDouble(),rating:(j['rating'] as num).toDouble(),
        stock:j['stock'] as int,brand:j['brand'] as String,thumbnail:j['thumbnail'] as String,
        images:(j['images'] as List).cast<String>(),availabilityStatus:j['availabilityStatus'] as String,
      );
    }).toList();
  }
  Future<void> saveFavorites(String userId,List<Product> products) => preferences.setString(
    _key(userId),
    jsonEncode(products.map((p)=>{
      'id':p.id,'title':p.title,'description':p.description,'category':p.category,'price':p.price,
      'rating':p.rating,'stock':p.stock,'brand':p.brand,'thumbnail':p.thumbnail,'images':p.images,
      'availabilityStatus':p.availabilityStatus,
    }).toList()),
  );
}
