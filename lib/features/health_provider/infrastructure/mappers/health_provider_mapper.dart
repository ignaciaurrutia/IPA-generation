import 'package:teslo_shop/features/health_provider/domain/domain.dart';


class HealthProviderMapper {

  static jsonToEntity( Map<String, dynamic> json ) => HealthProvider(
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    rut: json['rut'] ?? '',  
    email: json['email'] ?? '', 
    phone: json['phone'] ?? '',
    code: json['code'] ?? '',
    national_registration_number: json['national_registration_number'].toString(),
    occupation: json['occupation'] ?? '',
    health_institution_1: json['health_institution_1'] ?? '',
    health_institution_2: json['health_institution_2'] ?? '',
    health_institution_3: json['health_institution_3'] ?? '',
    status: json['status'] ?? '',
    patients: List<Map<String, dynamic>>.from( (json['patients'] ?? []) ),
  );

}
