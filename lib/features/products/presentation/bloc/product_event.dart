import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductEvent {}

class ToggleFavoriteEvent extends ProductEvent {
  final int productId;
  const ToggleFavoriteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategoryEvent extends ProductEvent {
  final String category;
  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}