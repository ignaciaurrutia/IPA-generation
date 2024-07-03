// import 'package:teslo_shop/config/config.dart';
// import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductMapper {
  static Patient jsonToEntity(Map<String, dynamic> json, {required bool isAdmin}) {
    Patient patient = Patient(
      firstName: FirstName.dirty(json['first_name'] ?? ''),
      lastName: LastName.dirty(json['last_name'] ?? ''),   // Adjust for LastName
      dueDate: DueDate.dirty(json['due_date'] ?? ''),      // Adjust for DueDate
      email: Email.dirty(json['email'] ?? 'no-email'),     // Adjust for Email
      bornDate: json['born_date'] != null ? BornDate.dirty(json['born_date']) : null,   // Adjust for BornDate
      height: Height.dirty(json['height'] ?? 0),
      images: List<String>.from(json['images'] ?? []),
      medicalStaff: List<Map<String, dynamic>>.from(json['health_providers'] ?? []),
      phone: Phone.dirty(json['phone'] ?? ''),
      comuneLiving: json['comune_living'] ?? '',
      rut: Rut.dirty(json['rut'] ?? ''),
      lastPeriodDate: LastPeriodDate.dirty(json['last_period_date'] ?? ''),
      pregnancyWeek: json['pregnancy_week'] ?? 0,
      pregnancyWeekDay: json['pregnancy_week_day'] ?? 0,
      subscriptionDate: json['subscription_date'] ?? '',
      planType: json['plan_type'] ?? '',
      healthInsurance: json['health_insurance'] ?? '',
      babyName: json['baby_name'] ?? '',
      partnerFirstName: FirstName.dirty(json['partner_first_name'] ?? ''),
      partnerLastName: LastName.dirty(json['partner_last_name'] ?? ''),
      partnerPhone: PartnerPhone.dirty(json['partner_phone'] ?? ''),
      gestationalAge: json['gestational_age'] ?? '',
      babyIsBorn: json['baby_is_born'] ?? false,
      region: json['region'] ?? '',
      province: json['province'] ?? '',
      address: json['address'] ?? '',
      midwife: json['midwife'] ?? '',
      group: json['group'] ?? '',
      category: json['category'] ?? '',
      medicalStaffEmail: MedicalStaffEmail.dirty(json['medicalStaffEmail'] ?? ''),  // Placeholder for now
    );
    final parsedCategory = _getParsedPregnancyStageCategory(patient);
    // Assign the category based on the pregnancy stage
    patient.category = parsedCategory;

    return patient;
  }
}

String _getParsedPregnancyStageCategory(Patient patient){
  if (patient.category == 'postpartum up to three months'){
    return 'Postparto';
  }
  else if (patient.category == 'past due'){
    return 'Past Due';
  }
  else if (patient.category == 'due within 14 days'){
    return '≤ 14 dias';
  }
  else if (patient.category == 'due within 30 days'){
    return '≤ 30 dias';
  }
  else if (patient.category == 'due in more than 30 days'){
    return '+ 30 dias';
  }
  else {
    return 'Desconocido';
  }
}
