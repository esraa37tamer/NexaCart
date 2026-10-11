import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
class OrderEntity extends Equatable {
  const OrderEntity({required this.id,required this.createdAt,required this.total,required this.items,required this.status});
  final String id; final DateTime createdAt; final double total; final List<CartItem> items; final String status;
  @override List<Object?> get props=>[id,createdAt,total,items,status];
}
