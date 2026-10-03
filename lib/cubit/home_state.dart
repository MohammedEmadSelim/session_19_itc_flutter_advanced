part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeGetProductsLoading extends HomeState {}

final class HomeGetProductsSuccess extends HomeState {
  final List<Product> products;

  HomeGetProductsSuccess(this.products);
}

final class HomeGetProductsFailure extends HomeState {
  final String message;

  HomeGetProductsFailure(this.message);
}
