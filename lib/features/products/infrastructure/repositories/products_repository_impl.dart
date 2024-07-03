import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';



class ProductsRepositoryImpl extends ProductsRepository {

  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);


  @override
  Future<Patient> createUpdatePatient(Map<String, dynamic> patientLike) {
    return datasource.createUpdatePatient(patientLike);
  }

  @override
  Future<Patient> getPatientByEmail(Email email) {
    return datasource.getPatientByEmail(email);
  }

  @override
  Future<List<Patient>> getPatientsByPage({int limit = 10, int offset = 0}) {
    return datasource.getPatientsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Patient>> searchPatientByTerm(String term) {
    return datasource.searchPatientByTerm(term);
  }

  @override
  Future<String> getEdimburghTestPDF(Email email) {
    return datasource.getEdimburghTestPDF(email);
  }

   @override
  Future<String> getMyProgressPDF(Email email) {
    return datasource.getMyProgressPDF(email);
  }

  @override
  Future<String> getPatientWeightTrackerPDF(Email email) {
    return datasource.getPatientWeightTrackerPDF(email);
  }

  @override
  Future<String> unlinkPatient(Email email) {
    return datasource.unlinkPatient(email);
  }

}