import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/neumorphic_surface.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key,required this.product,required this.onTap,required this.onAdd,required this.isFavorite,required this.onFavorite});
  final Product product; final VoidCallback onTap; final VoidCallback onAdd; final bool isFavorite; final VoidCallback onFavorite;
  @override Widget build(BuildContext context) {
    final colors=Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween:Tween(begin:.97,end:1),duration:const Duration(milliseconds:300),curve:Curves.easeOutBack,
      builder:(context,value,child)=>Transform.scale(scale:value,child:child),
      child:NeumorphicSurface(
        padding:const EdgeInsets.all(10),borderRadius:22,onTap:onTap,
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Expanded(child:Stack(children:[
            Positioned.fill(child:ClipRRect(borderRadius:BorderRadius.circular(16),child:CachedNetworkImage(imageUrl:product.thumbnail,fit:BoxFit.contain,placeholder:(_,_)=>const Center(child:CircularProgressIndicator(strokeWidth:2)),errorWidget:(_,_,_)=>const Icon(Icons.image_not_supported_outlined)))),
            Positioned(top:2,right:2,child:Material(color:Colors.transparent,child:InkWell(borderRadius:BorderRadius.circular(30),onTap:onFavorite,child:CircleAvatar(radius:17,backgroundColor:Theme.of(context).cardColor.withValues(alpha:.92),child:AnimatedSwitcher(duration:const Duration(milliseconds:220),transitionBuilder:(child,animation)=>ScaleTransition(scale:animation,child:child),child:Icon(isFavorite?Icons.favorite_rounded:Icons.favorite_border_rounded,key:ValueKey(isFavorite),size:19,color:isFavorite?Colors.redAccent:colors.onSurface))))))
          ])),
          const SizedBox(height:8),
          Text(product.title,maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(fontWeight:FontWeight.w900,color:colors.onSurface)),
          Text(product.brand.isEmpty?product.category:product.brand,maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(fontSize:11,color:colors.onSurfaceVariant)),
          const SizedBox(height:3),
          Row(children:[const Icon(Icons.star_rounded,size:16,color:Colors.amber),Text(product.rating.toStringAsFixed(1),style:const TextStyle(fontSize:12)),const Spacer(),Text('\$${product.price.toStringAsFixed(2)}',style:TextStyle(fontWeight:FontWeight.w900,color:colors.onSurface)),IconButton.filled(onPressed:onAdd,iconSize:17,visualDensity:VisualDensity.compact,icon:const Icon(Icons.add_shopping_cart_rounded))])
        ]),
      ),
    );
  }
}
