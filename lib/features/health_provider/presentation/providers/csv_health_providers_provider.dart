import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';

import 'health_providers_repository_provider.dart';

final csvhealthProvidersProvider = StateNotifierProvider.autoDispose<
    CSVHealthProvidersNotifier, CSVHealthProvidersState>(
  (ref) {
    final healthProvidersRepository =
        ref.watch(healthProvidersRepositoryProvider);
    return CSVHealthProvidersNotifier(
      healthProvidersRepository: healthProvidersRepository,
    );
  },
);

class CSVHealthProvidersNotifier
    extends StateNotifier<CSVHealthProvidersState> {
  final HealthProvidersRepository healthProvidersRepository;

  CSVHealthProvidersNotifier({
    required this.healthProvidersRepository,
  }) : super(CSVHealthProvidersState());

  void loadCSVNextPage(String query) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, healthProviders: []);

    try {
      final healthProviders =
          await healthProvidersRepository.getHealthProvidersByCSV(query);

      if (healthProviders.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No se encontraron resultados.',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          healthProviders: healthProviders,
          errorMessage: '',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se encontraron resultados.',
      );
    }
  }
}

class CSVHealthProvidersState {
  final bool isLoading;
  final List<Map<String, dynamic>> healthProviders;
  final String errorMessage;

  CSVHealthProvidersState({
    this.isLoading = false,
    this.healthProviders = const [],
    this.errorMessage = '',
  });

  CSVHealthProvidersState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? healthProviders,
    String? errorMessage,
  }) =>
      CSVHealthProvidersState(
        isLoading: isLoading ?? this.isLoading,
        healthProviders: healthProviders ?? this.healthProviders,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
