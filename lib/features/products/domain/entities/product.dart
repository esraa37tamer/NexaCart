import 'package:equatable/equatable.dart';
class Product extends Equatable {
  const Product({required this.id,required this.title,required this.description,required this.category,required this.price,required this.rating,required this.stock,required this.brand,required this.thumbnail,required this.images,required this.availabilityStatus});
  final int id; final String title; final String description; final String category; final double price; final double rating; final int stock; final String brand; final String thumbnail; final List<String> images; final String availabilityStatus;
  @override List<Object?> get props => [id,title,description,category,price,rating,stock,brand,thumbnail,images,availabilityStatus];
}
