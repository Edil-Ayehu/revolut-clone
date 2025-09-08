import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/transaction.dart';
import '../../../routes/app_routes.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from provider
    final transactions = _getMockTransactions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all transactions
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        Container(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade200,
              indent: AppConstants.paddingXL,
              endIndent: AppConstants.paddingM,
            ),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildTransactionItem(context, transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final isIncome = transaction.amount > 0;
    final amountColor = isIncome ? AppColors.success : AppColors.textPrimary;
    final amountPrefix = isIncome ? '+' : '-';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingL,
        vertical: AppConstants.paddingS,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getTransactionIconColor(transaction.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          _getTransactionIcon(transaction.type),
          color: _getTransactionIconColor(transaction.type),
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
          Text(
            _formatDate(transaction.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$amountPrefix${AppConstants.currencySymbol}${transaction.amount.abs().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (transaction.status != TransactionStatus.completed)
            Container(
              margin: const EdgeInsets.only(top: AppConstants.paddingXS),
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

  Color _getTransactionIconColor(TransactionType type) {
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

  List<Transaction> _getMockTransactions() {
    return [
      Transaction(
        id: '1',
        title: 'Coffee Shop',
        description: 'Starbucks Downtown',
        amount: -4.50,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.payment,
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '2',
        title: 'Salary',
        description: 'Monthly salary deposit',
        amount: 3500.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.topUp,
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '3',
        title: 'John Smith',
        description: 'Dinner split',
        amount: -25.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.transfer,
        status: TransactionStatus.pending,
      ),
      Transaction(
        id: '4',
        title: 'ATM Withdrawal',
        description: 'Bank of America ATM',
        amount: -100.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.withdrawal,
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '5',
        title: 'Currency Exchange',
        description: 'USD to EUR',
        amount: -500.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.exchange,
        status: TransactionStatus.completed,
      ),
    ];
  }
}
