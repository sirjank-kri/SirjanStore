import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc({required this.getProducts}) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterByCategoryEvent>(_onFilterByCategory);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await getProducts();
      emit(ProductLoaded(
        allProducts: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final updatedFavorites = Set<int>.from(currentState.favoriteIds);

      if (updatedFavorites.contains(event.productId)) {
        updatedFavorites.remove(event.productId);
      } else {
        updatedFavorites.add(event.productId);
      }

      emit(currentState.copyWith(favoriteIds: updatedFavorites));
    }
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = _filter(
        currentState.allProducts,
        event.query,
        currentState.selectedCategory,
      );
      emit(currentState.copyWith(
        searchQuery: event.query,
        filteredProducts: filtered,
      ));
    }
  }

  void _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = _filter(
        currentState.allProducts,
        currentState.searchQuery,
        event.category,
      );
      emit(currentState.copyWith(
        selectedCategory: event.category,
        filteredProducts: filtered,
      ));
    }
  }

  List<Product> _filter(List<Product> products, String query, String category) {
    return products.where((product) {
      final matchesQuery = product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == 'All' || product.category.toLowerCase() == category.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();
  }
}