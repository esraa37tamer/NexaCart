import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'favorites_state.dart';
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.repository):super(const FavoritesState());
  final FavoritesRepository repository;
  Future<void> switchUser(String userId) async {
    if(state.userId==userId)return;
    emit(FavoritesState(userId:userId,products:List.unmodifiable(await repository.getFavorites(userId))));
  }
  Future<void> toggle(Product product) async {
    final userId=state.userId; if(userId==null)return;
    final list=[...state.products]; final index=list.indexWhere((p)=>p.id==product.id);
    if(index>=0){list.removeAt(index);}else{list.add(product);} await repository.saveFavorites(userId,list);
    emit(FavoritesState(userId:userId,products:List.unmodifiable(list)));
  }
  void detachUser()=>emit(const FavoritesState());
}
