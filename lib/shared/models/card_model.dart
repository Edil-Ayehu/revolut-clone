import 'package:flutter/material.dart';

enum CardType {
  virtual,
  physical,
}

enum CardStatus {
  active,
  inactive,
  blocked,
  expired,
}

class CardModel {
  final String id;
  final String name;
  final CardType type;
  final String lastFourDigits;
  final DateTime expiryDate;
  final bool isActive;
  final bool isFrozen;
  final double balance;
  final String currency;
  final LinearGradient gradient;
  final String? holderName;
  final String? fullNumber;
  final String? cvv;
  final DateTime? createdAt;
  final Map<String, dynamic>? settings;

  CardModel({
    required this.id,
    required this.name,
    required this.type,
    required this.lastFourDigits,
    required this.expiryDate,
    required this.isActive,
    required this.isFrozen,
    required this.balance,
    required this.currency,
    required this.gradient,
    this.holderName,
    this.fullNumber,
    this.cvv,
    this.createdAt,
    this.settings,
  });

  CardStatus get status {
    if (!isActive) return CardStatus.inactive;
    if (isFrozen) return CardStatus.blocked;
    if (expiryDate.isBefore(DateTime.now())) return CardStatus.expired;
    return CardStatus.active;
  }

  String get maskedNumber {
    return '**** **** **** $lastFourDigits';
  }

  String get expiryString {
    return '${expiryDate.month.toString().padLeft(2, '0')}/${expiryDate.year.toString().substring(2)}';
  }

  bool get isExpired {
    return expiryDate.isBefore(DateTime.now());
  }

  bool get canBeUsed {
    return isActive && !isFrozen && !isExpired;
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CardType.virtual,
      ),
      lastFourDigits: json['lastFourDigits'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      isActive: json['isActive'] as bool,
      isFrozen: json['isFrozen'] as bool,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      gradient: _parseGradient(json['gradient'] as Map<String, dynamic>),
      holderName: json['holderName'] as String?,
      fullNumber: json['fullNumber'] as String?,
      cvv: json['cvv'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'lastFourDigits': lastFourDigits,
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
      'isFrozen': isFrozen,
      'balance': balance,
      'currency': currency,
      'gradient': _gradientToJson(gradient),
      'holderName': holderName,
      'fullNumber': fullNumber,
      'cvv': cvv,
      'createdAt': createdAt?.toIso8601String(),
      'settings': settings,
    };
  }

  CardModel copyWith({
    String? id,
    String? name,
    CardType? type,
    String? lastFourDigits,
    DateTime? expiryDate,
    bool? isActive,
    bool? isFrozen,
    double? balance,
    String? currency,
    LinearGradient? gradient,
    String? holderName,
    String? fullNumber,
    String? cvv,
    DateTime? createdAt,
    Map<String, dynamic>? settings,
  }) {
    return CardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      isFrozen: isFrozen ?? this.isFrozen,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      gradient: gradient ?? this.gradient,
      holderName: holderName ?? this.holderName,
      fullNumber: fullNumber ?? this.fullNumber,
      cvv: cvv ?? this.cvv,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
    );
  }

  static LinearGradient _parseGradient(Map<String, dynamic> json) {
    // Simple gradient parsing - in a real app, you'd want more robust parsing
    return const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Map<String, dynamic> _gradientToJson(LinearGradient gradient) {
    // Simple gradient serialization - in a real app, you'd want more robust serialization
    return {
      'colors': gradient.colors.map((c) => c.value).toList(),
      'begin': 'topLeft',
      'end': 'bottomRight',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CardModel(id: $id, name: $name, type: $type, lastFourDigits: $lastFourDigits, status: $status)';
  }
}

class CardSettings {
  final bool contactlessEnabled;
  final bool onlinePaymentsEnabled;
  final bool atmWithdrawalsEnabled;
  final bool internationalPaymentsEnabled;
  final double? dailySpendingLimit;
  final double? monthlySpendingLimit;
  final List<String> blockedMerchantCategories;
  final bool notificationsEnabled;

  CardSettings({
    this.contactlessEnabled = true,
    this.onlinePaymentsEnabled = true,
    this.atmWithdrawalsEnabled = true,
    this.internationalPaymentsEnabled = true,
    this.dailySpendingLimit,
    this.monthlySpendingLimit,
    this.blockedMerchantCategories = const [],
    this.notificationsEnabled = true,
  });

  factory CardSettings.fromJson(Map<String, dynamic> json) {
    return CardSettings(
      contactlessEnabled: json['contactlessEnabled'] as bool? ?? true,
      onlinePaymentsEnabled: json['onlinePaymentsEnabled'] as bool? ?? true,
      atmWithdrawalsEnabled: json['atmWithdrawalsEnabled'] as bool? ?? true,
      internationalPaymentsEnabled: json['internationalPaymentsEnabled'] as bool? ?? true,
      dailySpendingLimit: (json['dailySpendingLimit'] as num?)?.toDouble(),
      monthlySpendingLimit: (json['monthlySpendingLimit'] as num?)?.toDouble(),
      blockedMerchantCategories: List<String>.from(json['blockedMerchantCategories'] as List? ?? []),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactlessEnabled': contactlessEnabled,
      'onlinePaymentsEnabled': onlinePaymentsEnabled,
      'atmWithdrawalsEnabled': atmWithdrawalsEnabled,
      'internationalPaymentsEnabled': internationalPaymentsEnabled,
      'dailySpendingLimit': dailySpendingLimit,
      'monthlySpendingLimit': monthlySpendingLimit,
      'blockedMerchantCategories': blockedMerchantCategories,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  CardSettings copyWith({
    bool? contactlessEnabled,
    bool? onlinePaymentsEnabled,
    bool? atmWithdrawalsEnabled,
    bool? internationalPaymentsEnabled,
    double? dailySpendingLimit,
    double? monthlySpendingLimit,
    List<String>? blockedMerchantCategories,
    bool? notificationsEnabled,
  }) {
    return CardSettings(
      contactlessEnabled: contactlessEnabled ?? this.contactlessEnabled,
      onlinePaymentsEnabled: onlinePaymentsEnabled ?? this.onlinePaymentsEnabled,
      atmWithdrawalsEnabled: atmWithdrawalsEnabled ?? this.atmWithdrawalsEnabled,
      internationalPaymentsEnabled: internationalPaymentsEnabled ?? this.internationalPaymentsEnabled,
      dailySpendingLimit: dailySpendingLimit ?? this.dailySpendingLimit,
      monthlySpendingLimit: monthlySpendingLimit ?? this.monthlySpendingLimit,
      blockedMerchantCategories: blockedMerchantCategories ?? this.blockedMerchantCategories,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
