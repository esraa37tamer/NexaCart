import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
enum ProductsStatus { initial, loading, success, failure }
class ProductsState extends Equatable {
  const ProductsState({this.status=ProductsStatus.initial,this.products=const [],this.categories=const [],this.selectedCategory='all',this.message});
  final ProductsStatus status; final List<Product> products; final List<String> categories; final String selectedCategory; final String? message;
  ProductsState copyWith({ProductsStatus? status,List<Product>? products,List<String>? categories,String? selectedCategory,String? message}) => ProductsState(status:status??this.status,products:products??this.products,categories:categories??this.categories,selectedCategory:selectedCategory??this.selectedCategory,message:message);
  @override List<Object?> get props=>[status,products,categories,selectedCategory,message];
}
