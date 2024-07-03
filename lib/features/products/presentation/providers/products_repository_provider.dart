import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_repository_impl.dart';


final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  final email = ref.watch( authProvider ).user?.email ?? '';
  final isAdmin = ref.watch( authProvider ).user?.isAdmin;
  
  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(accessToken: accessToken, hpEmail: email, isAdmin: isAdmin!)
  );

  return productsRepository;
});

