import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';
import 'package:teslo_shop/features/health_provider/infrastructure/datasources/health_providers_datasource_impl.dart';
import 'package:teslo_shop/features/health_provider/infrastructure/repositories/health_providers_repository_impl.dart';


final healthProvidersRepositoryProvider = Provider<HealthProvidersRepository>((ref) {
  
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  
  final healthProvidersRepository = HealthProvidersRepositoryImpl(
    HealthProvidersDatasourceImpl(accessToken: accessToken )
  );

  return healthProvidersRepository;
});

