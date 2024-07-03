import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'health_providers_repository_provider.dart';

final healthProviderProvider = StateNotifierProvider.autoDispose
    .family<HealthProviderNotifier, HealthProviderState, String>((ref, healthProviderEmail) {
    final healthProvidersRepository = ref.watch(healthProvidersRepositoryProvider);
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;
  return HealthProviderNotifier(
      healthProvidersRepository: healthProvidersRepository, 
      healthProviderEmail: healthProviderEmail,
      isAdmin: isAdmin
    );
});


final healthInstitutionsProvider = FutureProvider<List<HealthInstitution>>((ref) async {
  final repository = ref.read(healthProvidersRepositoryProvider);
  return await repository.getHealthInstitutions();
});

// StateNotifier class for HealthProvider
class HealthProviderNotifier extends StateNotifier<HealthProviderState> {
  final HealthProvidersRepository healthProvidersRepository;

  HealthProviderNotifier({
    required this.healthProvidersRepository,
    required String healthProviderEmail,
    required bool isAdmin,
  }) : super(HealthProviderState(email: healthProviderEmail)) {
    loadHealthProvider(isAdmin);
  }

  HealthProvider newEmptyHealthProvider() {
    return HealthProvider(
      firstName: '',
      lastName: '',
      email: '',
      rut: '',
      phone: '',
      code: '',
      national_registration_number: '',
      occupation: '',
      health_institution_1: '',
      health_institution_2: '',
      health_institution_3: '',
      status: 'Activo',
      patients: [],
    );
  }


  Future<void> loadHealthProvider(bool isAdmin) async {

    try {
      if (state.email == 'new') {
        state = state.copyWith(
          isLoading: false,
          healthProvider: newEmptyHealthProvider(),
        );
        return;
      }

      final healthProvider = await healthProvidersRepository.getHealthProviderByEmail(state.email, isAdmin);

      state = state.copyWith(
        isLoading: false,
        healthProvider: healthProvider,
      );
    } catch (e) {
      // Handle 404 healthProvider not found or other errors
      print(e);
    }
  }
}

// State class for HealthProvider
class HealthProviderState {
  final String email;
  final HealthProvider? healthProvider;
  final bool isLoading;
  final bool isSaving;

  HealthProviderState({
    required this.email,
    this.healthProvider,
    this.isLoading = true,
    this.isSaving = false,
  });

  HealthProviderState copyWith({
    String? email,
    HealthProvider? healthProvider,
    bool? isLoading,
    bool? isSaving,
  }) =>
      HealthProviderState(
        email: email ?? this.email,
        healthProvider: healthProvider ?? this.healthProvider,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}