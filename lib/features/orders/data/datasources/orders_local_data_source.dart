import 'dart:convert';
import '../../../../core/storage/realm_database.dart';
import '../../../../core/storage/realm_models.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
class OrdersLocalDataSource {
  OrdersLocalDataSource(this.database);
  final RealmDatabase database;
  Future<List<OrderEntity>> getOrders(String userId) async {
    final realm = database.forUser(userId);
    final records = realm.all<OrderRecord>().toList()..sort((a,b)=>b.createdAt.compareTo(a.createdAt));
    return records.map((r)=>OrderEntity(
      id:r.id,
      createdAt:DateTime.fromMillisecondsSinceEpoch(r.createdAt),
      total:r.total,
      status:r.status,
      items:(jsonDecode(r.itemsJson) as List).map((e)=>CartItem.fromJson(Map<String,dynamic>.from(e as Map))).toList(),
    )).toList();
  }
  Future<OrderEntity> createOrder(String userId, List<CartItem> items) async {
    final now=DateTime.now();
    final id='NC${now.microsecondsSinceEpoch.toString().substring(7)}';
    final total=items.fold<double>(0,(s,i)=>s+i.subtotal);
    final order=OrderEntity(id:id,createdAt:now,total:total,items:List.unmodifiable(items),status:'Delivered');
    final realm = database.forUser(userId);
    realm.write(()=>realm.add(OrderRecord(id,now.millisecondsSinceEpoch,total,jsonEncode(items.map((e)=>e.toJson()).toList()),order.status)));
    return order;
  }
}
