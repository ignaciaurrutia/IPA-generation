import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';
import 'products_repository_provider.dart';


final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {

  final productsRepository = ref.watch( productsRepositoryProvider );

  return ProductsNotifier(
    productsRepository: productsRepository
  );
  
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository
  }): super( ProductsState() ) {
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct( Map<String,dynamic> patientLike ) async {

    try {
      final product = await productsRepository.createUpdatePatient(patientLike);
      final isProductInList = state.products.any((element) => element.email == product.email );
      

      if ( !isProductInList ) {
        state = state.copyWith(
          products: [...state.products, product]
        );
        final patientNotifier = PatientNotifier(productsRepository: productsRepository, patientEmail: product.email);
        await patientNotifier.loadPatient();
        await refreshPatients();
        return true;
      }

      state = state.copyWith(
        products: state.products.map(
          (element) => ( element.email == product.email ) ? product : element,
        ).toList()
      );
      final patientNotifier = PatientNotifier(productsRepository: productsRepository, patientEmail: product.email);
      await patientNotifier.loadPatient();
      await refreshPatients();
      return true;

    } catch (e) {
      return false;
    }


  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getPatientsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    // Filtrar productos duplicados antes de actualizar el estado
    final uniqueProducts = products.where((newProduct) {
      return !state.products.any((existingProduct) => existingProduct.email == newProduct.email);
    }).toList();

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...uniqueProducts],
    );
  }

  Future<void> refreshPatients() async {
    Future.microtask(() async {
      state = state.copyWith(isLoading: true, offset: 0);
      final patients = await productsRepository.getPatientsByPage(
        limit: state.limit,
        offset: 0,
      );

      state = state.copyWith(
        isLoading: false,
        isLastPage: patients.length < state.limit,
        products: patients,
      );
    });
  }
}


class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Patient> products;

  ProductsState({
    this.isLastPage = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.isLoading = false, 
    this.products = const[]
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Patient>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );

}
