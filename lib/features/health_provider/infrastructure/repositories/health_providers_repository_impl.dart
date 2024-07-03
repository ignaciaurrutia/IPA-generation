import 'package:teslo_shop/features/health_provider/domain/domain.dart';



class HealthProvidersRepositoryImpl extends HealthProvidersRepository {

  final HealthProvidersDatasource datasource;

  HealthProvidersRepositoryImpl(this.datasource);


  @override
  Future<HealthProvider> createUpdateHealthProvider(Map<String, dynamic> healthProviderLike, bool isAdmin) {
    return datasource.createUpdateHealthProvider(healthProviderLike, isAdmin);
  }

  @override
  Future<HealthProvider> getHealthProviderByEmail(String email, bool isAdmin) {
    return datasource.getHealthProviderByEmail(email, isAdmin);
  }

  @override
  Future<List<HealthProvider>> getHealthProvidersByPage({int limit = 10, int offset = 0}) {
    return datasource.getHealthProvidersByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<HealthProvider>> searchHealthProviderByTerm(String term) {
    return datasource.searchHealthProviderByTerm(term);
  }

  @override
  Future<String> deleteHealthProvider(email) {
    return datasource.deleteHealthProvider(email);
  }

  @override
  Future<String> unlinkPatientHealthProvider(email, hpEmail, operation, isAdmin) {
    return datasource.unlinkPatientHealthProvider(email, hpEmail, operation, isAdmin);
  }

  @override
  Future<List<HealthInstitution>> getHealthInstitutions() async {
    return await datasource.getHealthInstitutions();
  }

  @override
  Future<List<Map<String, dynamic>>> getHealthProvidersByCSV(query) async {
    return await datasource.getHealthProvidersByCSV(query);
  }

}
