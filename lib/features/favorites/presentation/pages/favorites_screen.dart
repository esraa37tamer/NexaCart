import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../../../products/presentation/widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override Widget build(BuildContext context){
    final colors=Theme.of(context).colorScheme;
    return Scaffold(
      body:AppBackground(child:SafeArea(child:Padding(
        padding:const EdgeInsets.fromLTRB(18,10,18,20),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[IconButton.filledTonal(onPressed:getIt<AppNavigationController>().pop,icon:const Icon(Icons.arrow_back)),const SizedBox(width:12),Text('Favorites',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:colors.onSurface))]),
          const SizedBox(height:16),
          Expanded(child:BlocBuilder<FavoritesCubit,FavoritesState>(builder:(context,state){
            if(state.products.isEmpty)return const Center(child:Text('No favorites yet. Tap the heart on any product.'));
            return GridView.builder(
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:.70),
              itemCount:state.products.length,
              itemBuilder:(_,i){final p=state.products[i];return ProductCard(product:p,isFavorite:true,onFavorite:()=>context.read<FavoritesCubit>().toggle(p),onTap:()=>getIt<AppNavigationController>().push(RouteNames.details,id:p.id),onAdd:()=>context.read<CartCubit>().add(p));},
            );
          }))
        ]),
      )))
    );
  }
}
