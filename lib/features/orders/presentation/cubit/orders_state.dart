import 'package:equatable/equatable.dart'; import '../../domain/entities/order.dart';
enum OrdersStatus { initial, loading, success, failure }
class OrdersState extends Equatable { const OrdersState({this.status=OrdersStatus.initial,this.orders=const [],this.message}); final OrdersStatus status; final List<OrderEntity> orders; final String? message; @override List<Object?> get props=>[status,orders,message]; }
