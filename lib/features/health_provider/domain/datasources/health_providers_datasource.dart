import '../entities/health_provider.dart';
import '../entities/health_institution.dart';  // Adjust the path as necessary


abstract class HealthProvidersDatasource {

  Future<List<HealthProvider>> getHealthProvidersByPage({ int limit = 10, int offset = 0 });

  Future<HealthProvider> getHealthProviderByEmail(String email, bool isAdmin);

  Future<List<HealthProvider>> searchHealthProviderByTerm( String term );
  
  Future<HealthProvider> createUpdateHealthProvider( Map<String,dynamic> healthProviderLike, bool isAdmin);

  Future<String> deleteHealthProvider( String email );

  Future<String> unlinkPatientHealthProvider( String email, String hpEmail, String operation, bool isAdmin);

  Future<List<HealthInstitution>> getHealthInstitutions();

  Future<List<Map<String, dynamic>>> getHealthProvidersByCSV( String query );
}
