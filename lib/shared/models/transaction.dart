enum TransactionType {
  transfer,
  payment,
  topUp,
  withdrawal,
  exchange,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? category;
  final String? recipientId;
  final String? recipientName;
  final String? currency;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.category,
    this.recipientId,
    this.recipientName,
    this.currency,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.payment,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
      category: json['category'] as String?,
      recipientId: json['recipientId'] as String?,
      recipientName: json['recipientName'] as String?,
      currency: json['currency'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'status': status.name,
      'category': category,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'currency': currency,
      'metadata': metadata,
    };
  }

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    TransactionType? type,
    TransactionStatus? status,
    String? category,
    String? recipientId,
    String? recipientName,
    String? currency,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      category: category ?? this.category,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      currency: currency ?? this.currency,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, type: $type, status: $status)';
  }
}

class TransactionFilter {
  final TransactionType? type;
  final TransactionStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? category;
  final String? searchQuery;

  TransactionFilter({
    this.type,
    this.status,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.category,
    this.searchQuery,
  });

  bool matches(Transaction transaction) {
    if (type != null && transaction.type != type) return false;
    if (status != null && transaction.status != status) return false;
    if (startDate != null && transaction.date.isBefore(startDate!)) return false;
    if (endDate != null && transaction.date.isAfter(endDate!)) return false;
    if (minAmount != null && transaction.amount.abs() < minAmount!) return false;
    if (maxAmount != null && transaction.amount.abs() > maxAmount!) return false;
    if (category != null && transaction.category != category) return false;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      if (!transaction.title.toLowerCase().contains(query) &&
          !transaction.description.toLowerCase().contains(query)) {
        return false;
      }
    }
    return true;
  }

  TransactionFilter copyWith({
    TransactionType? type,
    TransactionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? category,
    String? searchQuery,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
