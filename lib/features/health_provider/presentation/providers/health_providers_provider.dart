import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';

import 'health_providers_repository_provider.dart';

import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';


final healthProvidersProvider = StateNotifierProvider<HealthProvidersNotifier, HealthProvidersState>((ref) {

  final healthProvidersRepository = ref.watch( healthProvidersRepositoryProvider );

  final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;

  return HealthProvidersNotifier(
    healthProvidersRepository: healthProvidersRepository,
    isAdmin: isAdmin
  );
  
});

class HealthProvidersNotifier extends StateNotifier<HealthProvidersState> {
  
  final HealthProvidersRepository healthProvidersRepository;
  final bool isAdmin;



  HealthProvidersNotifier({
    required this.healthProvidersRepository,
    required this.isAdmin
  }): super( HealthProvidersState() ) {
    loadNextPage(isAdmin);
  }

  Future<bool> createOrUpdateHealthProvider( Map<String,dynamic> healthProviderLike ) async {

    try {
      final healthProvider = await healthProvidersRepository.createUpdateHealthProvider(healthProviderLike, isAdmin);
      if (!isAdmin){
        return true;
      }
      final isHealthProviderInList = state.healthProviders.any((element) => element.email == healthProvider.email );

      if ( !isHealthProviderInList ) {
        state = state.copyWith(
          healthProviders: [...state.healthProviders, healthProvider]
        );
        await refreshHealthProviders();
        return true;
      }

      state = state.copyWith(
        healthProviders: state.healthProviders.map(
          (element) => ( element.email == healthProvider.email ) ? healthProvider : element,
        ).toList()
      );
      await refreshHealthProviders();
      return true;

    } catch (e) {
      return false;
    }


  }

  Future<void> loadNextPage(bool isAdmin) async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    if (isAdmin){

    final healthProviders = await healthProvidersRepository.getHealthProvidersByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (healthProviders.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    // Filtrar productos duplicados antes de actualizar el estado
    final uniqueHealthProviders = healthProviders.where((newHealthProvider) {
      return !state.healthProviders.any((existingHealthProvider) => existingHealthProvider.email == newHealthProvider.email);
    }).toList();

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      healthProviders: [...state.healthProviders, ...uniqueHealthProviders],
    );
    }
  }

  Future<void> refreshHealthProviders() async {
    Future.microtask(() async {
      state = state.copyWith(isLoading: true, offset: 0);
      final healthProviders = await healthProvidersRepository.getHealthProvidersByPage(
        limit: state.limit,
        offset: 0,
      );

      state = state.copyWith(
        isLoading: false,
        isLastPage: healthProviders.length < state.limit,
        healthProviders: healthProviders,
      );
    });
  }
}


class HealthProvidersState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<HealthProvider> healthProviders;

  HealthProvidersState({
    this.isLastPage = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.isLoading = false, 
    this.healthProviders = const[]
  });

  HealthProvidersState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<HealthProvider>? healthProviders,
  }) => HealthProvidersState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    healthProviders: healthProviders ?? this.healthProviders,
  );

}
