import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/transaction.dart';
import '../../../routes/app_routes.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = _getMockPaymentTransactions();

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Payments',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to payment history
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade200,
              indent: AppConstants.paddingXL,
            ),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildPaymentItem(context, transaction);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, Transaction transaction) {
    final isOutgoing = transaction.amount < 0;
    final amountColor = isOutgoing ? AppColors.error : AppColors.success;
    final amountPrefix = isOutgoing ? '-' : '+';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingS,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getTransactionColor(transaction.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          _getTransactionIcon(transaction.type),
          color: _getTransactionColor(transaction.type),
          size: AppConstants.iconM,
        ),
      ),
      title: Text(
        transaction.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXS),
          Row(
            children: [
              Text(
                _formatDate(transaction.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              if (transaction.status != TransactionStatus.completed) ...[
                const SizedBox(width: AppConstants.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingS,
                    vertical: AppConstants.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: Text(
                    _getStatusText(transaction.status),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(transaction.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Text(
        '$amountPrefix${AppConstants.currencySymbol}${transaction.amount.abs().toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: amountColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        context.go('${AppRoutes.payments}/transaction/${transaction.id}');
      },
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.transfer:
        return Icons.send;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.topUp:
        return Icons.add_circle;
      case TransactionType.withdrawal:
        return Icons.remove_circle;
      case TransactionType.exchange:
        return Icons.swap_horiz;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.transfer:
        return AppColors.primary;
      case TransactionType.payment:
        return AppColors.secondary;
      case TransactionType.topUp:
        return AppColors.success;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.exchange:
        return AppColors.warning;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<Transaction> _getMockPaymentTransactions() {
    return [
      Transaction(
        id: '1',
        title: 'Alice Johnson',
        description: 'Dinner split payment',
        amount: -25.50,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.transfer,
        status: TransactionStatus.completed,
        recipientName: 'Alice Johnson',
      ),
      Transaction(
        id: '2',
        title: 'Bob Smith',
        description: 'Movie tickets',
        amount: 30.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.transfer,
        status: TransactionStatus.completed,
        recipientName: 'Bob Smith',
      ),
      Transaction(
        id: '3',
        title: 'Charlie Brown',
        description: 'Lunch payment',
        amount: -15.75,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.transfer,
        status: TransactionStatus.pending,
        recipientName: 'Charlie Brown',
      ),
      Transaction(
        id: '4',
        title: 'Diana Prince',
        description: 'Grocery shopping',
        amount: -45.20,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.transfer,
        status: TransactionStatus.completed,
        recipientName: 'Diana Prince',
      ),
    ];
  }
}
