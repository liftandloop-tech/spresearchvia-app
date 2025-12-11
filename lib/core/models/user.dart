import 'research_report.dart';
import 'subscription_history.dart';

enum KycStatus { verified, pending, rejected, notStarted }

enum PlanType { basic, premium, enterprise }

class User {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? userType;
  final PersonalInformation? personalInformation;
  final AddressDetails? addressDetails;
  final ContactDetails? contactDetails;
  final KycStatus? kycStatus;
  final PlanType? currentPlan;
  final String? planName;
  final double? planAmount;
  final String? planValidity;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionExpiryDate;
  final int? daysRemaining;
  final String? paymentMethod;
  final String? cardNumber;
  final String? cardType;
  final List<String>? premiumBenefits;
  final List<SubscriptionHistory>? subscriptionHistory;
  final List<ResearchReport>? researchReports;
  final String? portfolioValue;
  final String? todayReturn;
  final String? totalInvestment;

  User({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.profileImage,
    this.userType,
    this.personalInformation,
    this.addressDetails,
    this.contactDetails,
    this.kycStatus,
    this.currentPlan,
    this.planName,
    this.planAmount,
    this.planValidity,
    this.subscriptionStartDate,
    this.subscriptionExpiryDate,
    this.daysRemaining,
    this.paymentMethod,
    this.cardNumber,
    this.cardType,
    this.premiumBenefits,
    this.subscriptionHistory,
    this.researchReports,
    this.portfolioValue,
    this.todayReturn,
    this.totalInvestment,
  });

  String get name => fullName ?? personalInformation?.fullName ?? 'User';

  factory User.fromJson(Map<String, dynamic> json) {
    final userObject = json['userObject'] as Map<String, dynamic>?;

    if (userObject?['APP_ERROR_CODE'] != null) {
      throw Exception(userObject?['APP_ERROR_DESC'] ?? 'Invalid user data');
    }

    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName:
          userObject?['APP_NAME'] as String? ?? json['fullName'] as String?,
      email: userObject?['APP_EMAIL'] as String? ?? json['email'] as String?,
      phone: userObject?['APP_MOB_NO']?.toString() ?? json['phone']?.toString(),
      profileImage: json['profileImage'] as String?,
      userType: json['userType'] as String?,
      personalInformation: json['personalInformation'] != null
          ? PersonalInformation.fromJson(json['personalInformation'])
          : null,
      addressDetails: json['addressDetails'] != null
          ? AddressDetails.fromJson(json['addressDetails'])
          : null,
      contactDetails: json['contactDetails'] != null
          ? ContactDetails.fromJson(json['contactDetails'])
          : null,
      kycStatus: _parseKycStatus(json['kycStatus'] ?? 'notStarted'),
      currentPlan: _parsePlanType(json['currentPlan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'userType': userType,
      'personalInformation': personalInformation?.toJson(),
      'addressDetails': addressDetails?.toJson(),
      'contactDetails': contactDetails?.toJson(),
    };
  }

  static KycStatus? _parseKycStatus(dynamic status) {
    if (status == null) return KycStatus.notStarted;
    final statusStr = status.toString().toLowerCase();
    if (statusStr.contains('verified')) return KycStatus.verified;
    if (statusStr.contains('pending')) return KycStatus.pending;
    if (statusStr.contains('rejected')) return KycStatus.rejected;
    if (statusStr.contains('notstarted') || statusStr.contains('not_started')) {
      return KycStatus.notStarted;
    }
    return KycStatus.notStarted;
  }

  static PlanType? _parsePlanType(dynamic plan) {
    if (plan == null) return null;
    final planStr = plan.toString().toLowerCase();
    if (planStr.contains('premium')) return PlanType.premium;
    if (planStr.contains('enterprise')) return PlanType.enterprise;
    return PlanType.basic;
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
    String? userType,
    PersonalInformation? personalInformation,
    AddressDetails? addressDetails,
    ContactDetails? contactDetails,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      personalInformation: personalInformation ?? this.personalInformation,
      addressDetails: addressDetails ?? this.addressDetails,
      contactDetails: contactDetails ?? this.contactDetails,
    );
  }
}

class PersonalInformation {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fatherName;

  PersonalInformation({
    this.firstName,
    this.middleName,
    this.lastName,
    this.fatherName,
  });

  String get fullName {
    final parts = [
      firstName,
      middleName,
      lastName,
    ].where((e) => e != null && e.isNotEmpty);
    return parts.join(' ');
  }

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
      firstName: json['firstName'] as String?,
      middleName:
          json['middiletName'] as String? ?? json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      fatherName: json['fatherName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middiletName': middleName,
      'lastName': lastName,
      'fatherName': fatherName,
    };
  }
}

class AddressDetails {
  final String? houseNo;
  final String? streetAddress;
  final String? area;
  final String? landmark;
  final dynamic pincode;
  final String? state;

  AddressDetails({
    this.houseNo,
    this.streetAddress,
    this.area,
    this.landmark,
    this.pincode,
    this.state,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      houseNo: json['houseNo'] as String?,
      streetAddress:
          json['streetAdress'] as String? ?? json['streetAddress'] as String?,
      area: json['area'] as String?,
      landmark: json['landMark'] as String? ?? json['landmark'] as String?,
      pincode: json['pincode'],
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseNo': houseNo,
      'streetAdress': streetAddress,
      'area': area,
      'landMark': landmark,
      'pincode': pincode,
      'state': state,
    };
  }
}

class ContactDetails {
  final String? email;
  final dynamic phone;

  ContactDetails({this.email, this.phone});

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(
      email: json['email'] as String?,
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }
}
