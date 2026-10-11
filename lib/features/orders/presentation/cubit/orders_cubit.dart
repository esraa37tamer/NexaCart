import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_orders.dart';
import 'orders_state.dart';
class OrdersCubit extends Cubit<OrdersState>{
  OrdersCubit(this.getOrders):super(const OrdersState());
  final GetOrders getOrders;
  Future<void> load(String userId)async{
    emit(const OrdersState(status:OrdersStatus.loading));
    try{emit(OrdersState(status:OrdersStatus.success,orders:await getOrders(userId)));}
    catch(e){emit(OrdersState(status:OrdersStatus.failure,message:e.toString()));}
  }
}
