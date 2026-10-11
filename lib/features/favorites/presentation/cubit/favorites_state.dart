import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
class FavoritesState extends Equatable {
  const FavoritesState({this.products=const[],this.userId});
  final List<Product> products;
  final String? userId;
  bool contains(int productId)=>products.any((p)=>p.id==productId);
  @override List<Object?> get props=>[products,userId];
}
