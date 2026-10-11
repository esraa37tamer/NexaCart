import '../../domain/entities/product.dart';
class ProductModel extends Product {
  const ProductModel({required super.id,required super.title,required super.description,required super.category,required super.price,required super.rating,required super.stock,required super.brand,required super.thumbnail,required super.images,required super.availabilityStatus});
  factory ProductModel.fromJson(Map<String,dynamic> json) => ProductModel(
    id: (json['id'] as num).toInt(),
    title: json['title']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    category: json['category']?.toString() ?? '',
    price: (json['price'] as num? ?? 0).toDouble(),
    rating: (json['rating'] as num? ?? 0).toDouble(),
    stock: (json['stock'] as num? ?? 0).toInt(),
    brand: json['brand']?.toString() ?? '',
    thumbnail: json['thumbnail']?.toString() ?? '',
    images: (json['images'] as List<dynamic>? ?? const []).map((e)=>e.toString()).toList(),
    availabilityStatus: json['availabilityStatus']?.toString() ?? '',
  );
}
