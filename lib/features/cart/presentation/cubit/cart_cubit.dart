import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product.dart';
import '../../../orders/domain/use_cases/create_order.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_state.dart';
class CartCubit extends Cubit<CartState> {
  CartCubit(this.repository,this.createOrder):super(const CartState());
  final CartRepository repository;
  final CreateOrder createOrder;
  String? _userId;

  void switchUser(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    emit(CartState(items: List.unmodifiable(repository.getItems(userId))));
  }
  void detachUser() { _userId = null; emit(const CartState()); }
  void add(Product p,{int quantity=1}){ if(_userId==null)return; final list=[...state.items]; final i=list.indexWhere((e)=>e.productId==p.id); if(i>=0){list[i]=list[i].copyWith(quantity:list[i].quantity+quantity);}else{list.add(CartItem.fromProduct(p,quantity:quantity));} _save(list); }
  void increase(int id){ if(_userId==null)return; final list=state.items.map((e)=>e.productId==id?e.copyWith(quantity:e.quantity+1):e).toList(); _save(list); }
  void decrease(int id){ if(_userId==null)return; final list=<CartItem>[]; for(final e in state.items){ if(e.productId!=id){list.add(e);}else if(e.quantity>1){list.add(e.copyWith(quantity:e.quantity-1));} } _save(list); }
  void remove(int id){ if(_userId==null)return; _save(state.items.where((e)=>e.productId!=id).toList()); }
  void clear(){ final id=_userId; if(id==null)return; repository.clear(id);emit(const CartState()); }
  void _save(List<CartItem> list){ final id=_userId; if(id==null)return; repository.saveItems(id,list);emit(CartState(items:List.unmodifiable(list))); }
  Future<bool> checkout() async { final id=_userId; if(id==null||state.items.isEmpty)return false; emit(state.copyWith(checkingOut:true,clearMessage:true)); try{await createOrder(id,state.items); repository.clear(id); emit(const CartState(checkoutMessage: 'Order placed successfully')); return true;}catch(e){emit(state.copyWith(checkingOut: false, checkoutMessage: e.toString(), checkoutFailed: true)); return false;} }
}
