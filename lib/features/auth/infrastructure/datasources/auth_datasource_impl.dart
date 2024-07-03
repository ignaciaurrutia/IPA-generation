import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    
    try {
      
      final response = await dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;


    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ){
         throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  // @override
  // Future<User> login(String email, String token) async {
    
  //   try {
  //     final response = await dio.post('/auth/login', data: {
  //       'email': email,
  //       'password': password
  //     });

  //     final user = UserMapper.userJsonToEntity(response.data);
  //     final user = [email, token]; 
  //     return user;
      
  //   } on DioException catch (e) {
  //     if( e.response?.statusCode == 401 ){
  //        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas' );
  //     }
  //     if ( e.type == DioExceptionType.connectionTimeout ){
  //       throw CustomError('Revisar conexión a internet');
  //     }
  //     throw Exception();
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  @override
  Future<User> login(String email, String token) async {
    // Assuming the `User` class has the `email` and `token` fields
    // Adjust this to fit your `User` entity's structure

    try {
      final response = await dio.get('/superuser/verify',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final user = User(
          email: email,
          token: token,
          isAdmin: true,
        );
        return Future.value(user);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        final user = User(
          email: email,
          token: token,
          isAdmin: false,
        );
        return Future.value(user);
      }
      throw Exception('Failed to verify superuser status: $e');
    }
    throw Exception();
  }


  @override
  Future<User> register(String email, String password, String fullName) {
    
    throw UnimplementedError();
  }
  
}
