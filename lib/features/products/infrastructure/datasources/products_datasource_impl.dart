import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import '../errors/product_errors.dart';
import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;
  final String hpEmail;
  final bool isAdmin;
  ProductsDatasourceImpl({
    required this.accessToken,
    required this.hpEmail,
    required this.isAdmin
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );
  
  @override
  Future<Patient> createUpdatePatient(Map<String, dynamic> patientLike) async {
    
    try {
      
      // ARREGLAR EL CAMBIO ENTRE POST Y PUT
      // final String? patientEmail = patientLike['email'];
      final String method = patientLike['request'];
      final String medicalStaffEmail = patientLike['medical_staff'] ?? '';
      final String url;

      // Revisar cuando uno edita el mail del paciente, en el url del request
      // pone el mail nuevo entonces dice que no existe esa persona.
      // final String url = (method == 'POST') ? '/HP/add_patient/' : '/HP/edit_patient/$patientEmail';
      if (method == 'POST') {
        if (isAdmin) {
          url = '/HP/add_patient/?hp_key=$medicalStaffEmail';
        } else {
          url = '/HP/add_patient/';
        }
        patientLike.remove('medical_staff');
      } else {
        final String patientEmail = patientLike['original_email'];
        url = '/HP/edit_patient/$patientEmail';
        patientLike.remove('original_email');
      }
      patientLike.remove('request');
      
      final response = await dio.request(
        url,
        data: patientLike,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          method: method
        )
      );

      final product = ProductMapper.jsonToEntity(response.data, isAdmin: isAdmin);

      return product;

    } catch (e) {
      throw Exception(e);
    }


  }

  @override
  Future<Patient> getPatientByEmail(Email email) async {
    
    try {
      
      final response = await dio.get('/HP/find_patient/${email.value}');
      final product = ProductMapper.jsonToEntity(response.data, isAdmin: isAdmin);
      return product;

    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();

    }catch (e) {
      throw Exception();
    }

  }

  @override
  Future<List<Patient>> getPatientsByPage({int limit = 10, int offset = 0}) async {
    final response = isAdmin
      ? await dio.get<List>('/superuser/get_all_patients/?limit=$limit&offset=$offset')
      : await dio.get<List>('/HP/get_patients/?limit=$limit&offset=$offset');
    final List<Patient> products = [];
    for (final product in response.data ?? [] ) {
      products.add(  ProductMapper.jsonToEntity(product, isAdmin: isAdmin)  );
    }

    return products;
  }

  @override
  Future<List<Patient>> searchPatientByTerm(String term) {
    throw UnimplementedError();
  }

  // Get PDF of edimburgh test from specific patient
  @override
  Future<String> getEdimburghTestPDF(Email email) async {
    try {
      final response = await dio.get('/HP/generate_pdf_edinburgh/${email.value}');
      return response.data;
    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();
    }catch (e) {
      throw Exception();
    }
  }

   @override
  Future<String> getMyProgressPDF(Email email) async {
    try {
      final response = await dio.get('/HP/generate_pdf_myprogress/${email.value}');
      return response.data;
    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();
    }catch (e) {
      throw Exception();
    }
  }

  @override
  Future<String> getPatientWeightTrackerPDF(Email email) async {
    try {
      final response = await dio.get('/HP/generate_pdf_weighttracker/${email.value}');
      return response.data;
    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();
    }catch (e) {
      throw Exception();
    }
  }

  @override
  Future<String> unlinkPatient(Email email) async {
    try {
      String url;
      print(hpEmail);
      print(email);
      if (isAdmin){
        url = '/HP/link_HP_user/${email.value}/unlink/?hp_key=$hpEmail';
      }
      else {
        // HP/link_HP_user/<str:userkey>/<str:link_or_unlink>/
        url = '/HP/link_HP_user/${email.value}/unlink/';
      }
      
      final response = await dio.put(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        throw Exception("La desvinculación del paciente no fue exitosa.");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data.toString());
      } else {
        throw Exception("Error de conexión: ${e.message}");
      }
    } catch (e) {
      throw Exception("Error desconocido: $e");
    }
  }
}