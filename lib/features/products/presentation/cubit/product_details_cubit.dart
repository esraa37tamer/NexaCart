import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_cases/get_product.dart';
sealed class ProductDetailsState { const ProductDetailsState(); }
class ProductDetailsLoading extends ProductDetailsState { const ProductDetailsLoading(); }
class ProductDetailsSuccess extends ProductDetailsState { const ProductDetailsSuccess(this.product); final Product product; }
class ProductDetailsFailure extends ProductDetailsState { const ProductDetailsFailure(this.message); final String message; }
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this.getProduct):super(const ProductDetailsLoading()); final GetProduct getProduct;
  Future<void> load(int id) async { emit(const ProductDetailsLoading()); try{ emit(ProductDetailsSuccess(await getProduct(id))); }catch(e){ emit(ProductDetailsFailure(e.toString())); } }
}
