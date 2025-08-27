class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final bool isFavorite;
  final DateTime? lastTransactionDate;
  final double? lastTransactionAmount;

  Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.isFavorite = false,
    this.lastTransactionDate,
    this.lastTransactionAmount,
  });

  String get displayIdentifier {
    return email ?? phone ?? '';
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastTransactionDate: json['lastTransactionDate'] != null
          ? DateTime.parse(json['lastTransactionDate'] as String)
          : null,
      lastTransactionAmount: (json['lastTransactionAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'isFavorite': isFavorite,
      'lastTransactionDate': lastTransactionDate?.toIso8601String(),
      'lastTransactionAmount': lastTransactionAmount,
    };
  }

  Contact copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? isFavorite,
    DateTime? lastTransactionDate,
    double? lastTransactionAmount,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isFavorite: isFavorite ?? this.isFavorite,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
      lastTransactionAmount: lastTransactionAmount ?? this.lastTransactionAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone)';
  }
}
