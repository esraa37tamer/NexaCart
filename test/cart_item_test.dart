import 'package:flutter_test/flutter_test.dart'; import 'package:nexacart/features/cart/domain/entities/cart_item.dart';
void main(){test('cart subtotal is price times quantity',(){const item=CartItem(productId:1,title:'Test',thumbnail:'',price:12.5,quantity:3);expect(item.subtotal,37.5);});}
