import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
class CartItem extends Equatable {
  const CartItem({required this.productId,required this.title,required this.thumbnail,required this.price,required this.quantity});
  factory CartItem.fromProduct(Product p,{int quantity=1}) => CartItem(productId:p.id,title:p.title,thumbnail:p.thumbnail,price:p.price,quantity:quantity);
  final int productId; final String title; final String thumbnail; final double price; final int quantity;
  double get subtotal=>price*quantity;
  CartItem copyWith({int? quantity})=>CartItem(productId:productId,title:title,thumbnail:thumbnail,price:price,quantity:quantity??this.quantity);
  Map<String,dynamic> toJson()=>{'productId':productId,'title':title,'thumbnail':thumbnail,'price':price,'quantity':quantity};
  factory CartItem.fromJson(Map<String,dynamic> j)=>CartItem(productId:(j['productId'] as num).toInt(),title:j['title'].toString(),thumbnail:j['thumbnail'].toString(),price:(j['price'] as num).toDouble(),quantity:(j['quantity'] as num).toInt());
  @override List<Object?> get props=>[productId,title,thumbnail,price,quantity];
}
