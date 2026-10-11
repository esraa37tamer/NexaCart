import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_categories.dart';
import '../../domain/use_cases/get_products.dart';
import '../../domain/use_cases/get_products_by_category.dart';
import '../../domain/use_cases/search_products.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(
    this.getProducts,
    this.searchProducts,
    this.getCategories,
    this.getByCategory,
  ) : super(const ProductsState());

  final GetProducts getProducts;
  final SearchProducts searchProducts;
  final GetCategories getCategories;
  final GetProductsByCategory getByCategory;
  Timer? _debounce;

  Future<void> load() async {
    emit(state.copyWith(status: ProductsStatus.loading));
    try {
      final products = await getProducts();
      final categories = await getCategories();
      emit(
        ProductsState(
          status: ProductsStatus.success,
          products: products,
          categories: categories,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductsStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.trim().isEmpty) {
        await load();
        return;
      }
      emit(state.copyWith(status: ProductsStatus.loading));
      try {
        final products = await searchProducts(query.trim());
        emit(
          state.copyWith(
            status: ProductsStatus.success,
            products: products,
            selectedCategory: 'all',
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: ProductsStatus.failure,
            message: error.toString(),
          ),
        );
      }
    });
  }

  Future<void> selectCategory(String category) async {
    if (category == 'all') {
      await load();
      return;
    }
    emit(
      state.copyWith(
        status: ProductsStatus.loading,
        selectedCategory: category,
      ),
    );
    try {
      final products = await getByCategory(category);
      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: products,
          selectedCategory: category,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductsStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
