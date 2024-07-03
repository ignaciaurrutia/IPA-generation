import '../entities/product.dart';
import 'package:teslo_shop/features/shared/shared.dart';


abstract class ProductsRepository {

  Future<List<Patient>> getPatientsByPage({int limit = 10, int offset = 0});
  
  Future<Patient> getPatientByEmail(Email email);

  Future<List<Patient>> searchPatientByTerm(String term);
  
  Future<Patient> createUpdatePatient(Map<String, dynamic> patientLike);

  Future<String> getEdimburghTestPDF(Email email);
  
  Future<String> getMyProgressPDF(Email email);

  Future<String> getPatientWeightTrackerPDF(Email email);

  Future<String> unlinkPatient( Email email );


}

