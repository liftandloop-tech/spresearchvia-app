class Plan {
  final String id;
  final String userId;
  final String packageName;
  final int validity;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final bool expiryReminder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Additional properties for UI compatibility
  final String? name;
  final String? description;
  final double? amount;
  final int? validityDays;
  final DateTime? expiryDate;
  final DateTime? purchaseDate;
  final List<String>? features;

  Plan({
    required this.id,
    required this.userId,
    required this.packageName,
    required this.validity,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.expiryReminder = false,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.amount,
    this.validityDays,
    this.expiryDate,
    this.purchaseDate,
    this.features,
  });

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isExpired => status == 'expired';
  bool get isFailed => status == 'failed';

  int get daysRemaining {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      packageName: json['packageName']?.toString() ?? '',
      validity: json['validity'] ?? 0,
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      expiryReminder: json['expiryReminder'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      name: json['packageName']?.toString(),
      description: 'Plan for ${json['packageName'] ?? 'subscription'}',
      amount: (json['validity'] ?? 0) * 10.0, // ₹10 per day
      validityDays: json['validity'] ?? 0,
      expiryDate: DateTime.tryParse(json['endDate']?.toString() ?? ''),
      purchaseDate: DateTime.tryParse(json['startDate']?.toString() ?? ''),
      features: ['Access to premium content', 'Priority support'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'packageName': packageName,
      'validity': validity,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'expiryReminder': expiryReminder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Payment {
  final String id;
  final String userId;
  final String? packageId;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;
  final String? razorpayReceipt;
  final double amount;
  final String? razorpayCurrency;
  final String status;
  final DateTime? createdAt;

  Payment({
    required this.id,
    required this.userId,
    this.packageId,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
    this.razorpayReceipt,
    required this.amount,
    this.razorpayCurrency,
    required this.status,
    this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      packageId: json['packageId']?.toString(),
      razorpayOrderId: json['razorpayOrderId']?.toString(),
      razorpayPaymentId: json['razorpayPaymentId']?.toString(),
      razorpaySignature: json['razorpaySignature']?.toString(),
      razorpayReceipt: json['razorpayReceipt']?.toString(),
      amount: (json['amount'] ?? 0).toDouble(),
      razorpayCurrency: json['razorpayCurrency']?.toString(),
      status: json['status']?.toString() ?? 'created',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}