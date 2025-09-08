import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/widgets/custom_button.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String transactionId;
  
  const TransactionDetailsPage({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    // In a real app, fetch transaction by ID from a repository or provider
    // For now, we'll use mock data
    final transaction = _getMockTransactionById(transactionId);
    
    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Transaction not found'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTransactionHeader(context, transaction),
            const SizedBox(height: AppConstants.paddingL),
            _buildTransactionDetails(context, transaction),
            const SizedBox(height: AppConstants.paddingL),
            _buildActionButtons(context, transaction),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionHeader(BuildContext context, Transaction transaction) {
    final isIncome = transaction.amount > 0;
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final amountPrefix = isIncome ? '+' : '-';
    final currency = transaction.currency ?? 'USD';
    final currencySymbol = _getCurrencySymbol(currency);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        color: _getTransactionColor(transaction.type).withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: _getTransactionColor(transaction.type),
              size: 32,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            transaction.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            '$amountPrefix$currencySymbol${transaction.amount.abs().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM,
              vertical: AppConstants.paddingS,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Text(
              _getStatusText(transaction.status),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getStatusColor(transaction.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionDetails(BuildContext context, Transaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(context, 'Date & Time', _formatDateTime(transaction.date)),
          Divider(color: Colors.grey.shade300),
          _buildDetailRow(context, 'Description', transaction.description),
          Divider(color: Colors.grey.shade300),
          _buildDetailRow(context, 'Transaction Type', _getTransactionTypeText(transaction.type)),
          Divider(color: Colors.grey.shade300),
          _buildDetailRow(context, 'Transaction ID', transaction.id),
          if (transaction.recipientName != null) ...[  
            Divider(color: Colors.grey.shade300),
            _buildDetailRow(context, 'Recipient', transaction.recipientName!),
          ],
          if (transaction.category != null) ...[  
            Divider(color: Colors.grey.shade300),
            _buildDetailRow(context, 'Category', transaction.category!),
          ],
          // Add additional metadata if available
          if (transaction.metadata != null && transaction.metadata!.isNotEmpty) ...
            transaction.metadata!.entries.map((entry) {
              return Column(
                children: [
                  Divider(color: Colors.grey.shade300),
                  _buildDetailRow(context, _formatMetadataKey(entry.key), entry.value.toString()),
                ],
              );
            }),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label copied to clipboard')),
                );
              },
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      child: Column(
        children: [
          if (transaction.type == TransactionType.transfer) ...[  
            CustomButton(
              text: 'Repeat Transaction',
              onPressed: () {
                // TODO: Implement repeat transaction functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Repeat transaction functionality coming soon')),
                );
              },
            ),
            const SizedBox(height: AppConstants.paddingM),
          ],
          if (transaction.status == TransactionStatus.pending) ...[  
            CustomButton(
              text: 'Cancel Transaction',
              onPressed: () {
                // TODO: Implement cancel transaction functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cancel transaction functionality coming soon')),
                );
              },
              buttonType: ButtonType.secondary,
            ),
            const SizedBox(height: AppConstants.paddingM),
          ],
          CustomButton(
            text: 'Report an Issue',
            onPressed: () {
              // TODO: Implement report issue functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report issue functionality coming soon')),
              );
            },
            buttonType: ButtonType.text,
          ),
        ],
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  String _formatMetadataKey(String key) {
    return key.split('_').map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }
  
  String _getTransactionTypeText(TransactionType type) {
    switch (type) {
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.topUp:
        return 'Top Up';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.exchange:
        return 'Currency Exchange';
    }
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
  
  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return '\$';
    }
  }
  
  // Mock data - in a real app, this would come from a repository or provider
  Transaction? _getMockTransactionById(String id) {
    final transactions = [
      Transaction(
        id: '1',
        title: 'Coffee Shop',
        description: 'Starbucks Downtown',
        amount: -4.50,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.payment,
        status: TransactionStatus.completed,
        category: 'Food & Drinks',
      ),
      Transaction(
        id: '2',
        title: 'Salary',
        description: 'Monthly salary deposit',
        amount: 3500.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.topUp,
        status: TransactionStatus.completed,
        category: 'Income',
        metadata: {
          'employer_name': 'Acme Inc.',
          'reference_number': 'SAL-2023-05-28',
        },
      ),
      Transaction(
        id: '3',
        title: 'John Smith',
        description: 'Dinner split',
        amount: -25.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.transfer,
        status: TransactionStatus.pending,
        recipientName: 'John Smith',
        category: 'Friends',
      ),
      Transaction(
        id: '4',
        title: 'ATM Withdrawal',
        description: 'Bank of America ATM',
        amount: -100.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.withdrawal,
        status: TransactionStatus.completed,
        category: 'Cash',
        metadata: {
          'atm_location': '123 Main St, New York, NY',
          'atm_id': 'ATM-NYC-123',
        },
      ),
      Transaction(
        id: '5',
        title: 'Currency Exchange',
        description: 'USD to EUR',
        amount: -500.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.exchange,
        status: TransactionStatus.completed,
        category: 'Exchange',
        metadata: {
          'from_currency': 'USD',
          'to_currency': 'EUR',
          'exchange_rate': '0.92',
          'received_amount': '460.00 EUR',
        },
      ),
    ];
    
    return transactions.firstWhere(
      (transaction) => transaction.id == id,
      orElse: () => null as Transaction,
    );
  }
}

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.primary:
        return _buildPrimaryButton(context);
      case ButtonType.secondary:
        return _buildSecondaryButton(context);
      case ButtonType.text:
        return _buildTextButton(context);
    }
  }
  
  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[  
                    Icon(icon, size: 18),
                    const SizedBox(width: AppConstants.paddingS),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[  
                    Icon(icon, size: 18),
                    const SizedBox(width: AppConstants.paddingS),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.paddingS,
          horizontal: AppConstants.paddingM,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[  
                  Icon(icon, size: 18),
                  const SizedBox(width: AppConstants.paddingS),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}