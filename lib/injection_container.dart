import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  //Features - Products
  //  Bloc 
  sl.registerFactory(() => ProductBloc(getProducts: sl()));

  //  Use cases 
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  //  Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // External (HTTP Client)
  sl.registerLazySingleton(() => http.Client());
}