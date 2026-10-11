import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  const CartState({
    this.items = const [],
    this.checkingOut = false,
    this.checkoutMessage,
    this.checkoutFailed = false,
  });

  final List<CartItem> items;
  final bool checkingOut;
  final String? checkoutMessage;
  final bool checkoutFailed;

  double get total =>
      items.fold<double>(0.0, (sum, item) => sum + item.subtotal);

  int get count => items.fold<int>(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? checkingOut,
    String? checkoutMessage,
    bool? checkoutFailed,
    bool clearMessage = false,
  }) {
    return CartState(
      items: items ?? this.items,
      checkingOut: checkingOut ?? this.checkingOut,
      checkoutMessage:
          clearMessage ? null : checkoutMessage ?? this.checkoutMessage,
      checkoutFailed: clearMessage
          ? false
          : checkoutFailed ?? this.checkoutFailed,
    );
  }

  @override
  List<Object?> get props => [
        items,
        checkingOut,
        checkoutMessage,
        checkoutFailed,
      ];
}
