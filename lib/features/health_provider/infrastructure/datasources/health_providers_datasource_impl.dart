import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/health_provider/domain/domain.dart';

import '../errors/health_provider_errors.dart';
import '../mappers/health_provider_mapper.dart';


class HealthProvidersDatasourceImpl extends HealthProvidersDatasource {

  late final Dio dio;
  final String accessToken;

  HealthProvidersDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );


  @override
  Future<HealthProvider> createUpdateHealthProvider(Map<String, dynamic> healthProviderLike, bool isAdmin) async {
    
    try {
      
      final String method = healthProviderLike['request'];
      final String url;

      if (method == 'POST') {
        url = '/superuser/create_health_provider/';
      } else {
        final String healthProviderEmail = healthProviderLike['original_email'];
        //PROBAR
        if  (isAdmin) {
          url = '/HP/edit_HP/?hp_key=$healthProviderEmail';
        } else {
          url = '/HP/edit_HP/';
          healthProviderLike.remove('code');
          healthProviderLike.remove('status');
        }

        healthProviderLike.remove('original_email');
      }
      healthProviderLike.remove('request');

      final response = await dio.request(
        url,
        data: healthProviderLike,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          method: method
        )
      );

      final healthProvider = HealthProviderMapper.jsonToEntity(response.data);

      return healthProvider;

    } catch (e) {
      throw Exception(e);
    }


  }

  @override
  Future<HealthProvider> getHealthProviderByEmail(String email, bool isAdmin) async {
    
    try {
      if (isAdmin){
        final response = await dio.get('/HP/get_HP/?hp_key=$email');
        final healthProvider = HealthProviderMapper.jsonToEntity(response.data);
        return healthProvider;
      }
      else{
        final response = await dio.get('/HP/get_HP/');
        final healthProvider = HealthProviderMapper.jsonToEntity(response.data);
        return healthProvider;
      }

    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw HealthProviderNotFound();
      throw Exception();

    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<List<HealthProvider>> getHealthProvidersByPage({int limit = 10, int offset = 0}) async {
    final response = await dio
        .get<List>('/superuser/get_all_HP/?limit=$limit&offset=$offset');
    final List<HealthProvider> healthProviders = [];
    for (final healthProvider in response.data ?? []) {
      healthProviders.add(HealthProviderMapper.jsonToEntity(healthProvider));
    }

    return healthProviders;
  }

  @override
  Future<List<HealthProvider>> searchHealthProviderByTerm(String term) {
    throw UnimplementedError();
  }

  @override
  Future<String> deleteHealthProvider(String email) async {
    try {
      final response = await dio.delete('/superuser/delete_HP/$email');
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        throw Exception("La eliminación del tratante no fue exitosa.");
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


  @override
  Future<String> unlinkPatientHealthProvider(String email, String hpEmail, String operation, bool isAdmin) async {
    try {
      final response;
      if (isAdmin){
        response = await dio.put('/HP/link_HP_user/$email/$operation/?hp_key=$hpEmail');
      }
      else{
        response = await dio.put('/HP/link_HP_user/$email/unlink/');
      }
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        throw Exception((operation == 'unlink')
            ? "La desvinculación de la paciente no fue exitosa."
            : "La vinculación de la paciente no fue exitosa.");
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

  @override
  Future<List<HealthInstitution>> getHealthInstitutions() async {
    final response = await dio.get('/HP/get_health_institutions');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      List<HealthInstitution> institutions = data.map((item) => HealthInstitution.fromJson({'name': item.toString()})).toList();
      return institutions;
    } else {
      throw Exception('Failed to load health institutions');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getHealthProvidersByCSV(
      String query) async {
    final response =
        await dio.get('/superuser/filter_hp/?query=$query');
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> healthProviderData =
          (response.data as List<dynamic>).cast<Map<String, dynamic>>();
      return healthProviderData;
    } else {
      throw Exception('Failed to load health providers from the database');
    }
  }

}