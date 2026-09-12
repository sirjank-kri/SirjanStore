import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final Set<int> favoriteIds;
  final String searchQuery;
  final String selectedCategory;

  const ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.favoriteIds = const {},
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  List<String> get categories {
    final cats = allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  ProductLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    Set<int>? favoriteIds,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ProductLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        favoriteIds,
        searchQuery,
        selectedCategory,
      ];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}