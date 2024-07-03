
import '../entities/user.dart';

abstract class AuthRepository {

  Future<User> login( String email, String token );
  Future<User> register( String email, String password, String fullName );
  Future<User> checkAuthStatus( String token );

}

