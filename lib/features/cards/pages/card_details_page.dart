import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/card_model.dart';
import '../widgets/card_widget.dart';

class CardDetailsPage extends StatefulWidget {
  final String cardId;

  const CardDetailsPage({
    super.key,
    required this.cardId,
  });

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  bool _showFullNumber = false;
  bool _showCvv = false;

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from provider
    final card = _getMockCard();

    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to card settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Display
              CardWidget(
                card: card,
                showBalance: false,
              ),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Card Information
              _buildInfoSection(context, card),
              const SizedBox(height: AppConstants.paddingL),
              
              // Security Information
              _buildSecuritySection(context, card),
              const SizedBox(height: AppConstants.paddingL),
              
              // Spending Limits
              _buildSpendingLimitsSection(context, card),
              const SizedBox(height: AppConstants.paddingL),
              
              // Recent Transactions
              _buildRecentTransactionsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, CardModel card) {
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
          Text(
            'Card Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Card Number
          _buildInfoRow(
            context,
            'Card Number',
            _showFullNumber ? (card.fullNumber ?? '**** **** **** ${card.lastFourDigits}') : card.maskedNumber,
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _showFullNumber = !_showFullNumber;
                });
              },
              icon: Icon(
                _showFullNumber ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(),
          
          // Expiry Date
          _buildInfoRow(context, 'Expiry Date', card.expiryString),
          const Divider(),
          
          // CVV
          _buildInfoRow(
            context,
            'CVV',
            _showCvv ? (card.cvv ?? '123') : '•••',
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _showCvv = !_showCvv;
                });
              },
              icon: Icon(
                _showCvv ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(),
          
          // Cardholder Name
          _buildInfoRow(context, 'Cardholder', card.holderName ?? 'John Doe'),
          const Divider(),
          
          // Card Type
          _buildInfoRow(
            context,
            'Type',
            card.type == CardType.virtual ? 'Virtual Card' : 'Physical Card',
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, CardModel card) {
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
          Text(
            'Security & Controls',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Card Status
          _buildSecurityRow(
            context,
            'Card Status',
            _getStatusText(card.status),
            _getStatusColor(card.status),
            _getStatusIcon(card.status),
          ),
          const Divider(),
          
          // Contactless Payments
          _buildSecurityRow(
            context,
            'Contactless Payments',
            'Enabled',
            AppColors.success,
            Icons.contactless,
          ),
          const Divider(),
          
          // Online Payments
          _buildSecurityRow(
            context,
            'Online Payments',
            'Enabled',
            AppColors.success,
            Icons.shopping_cart,
          ),
          const Divider(),
          
          // ATM Withdrawals
          _buildSecurityRow(
            context,
            'ATM Withdrawals',
            'Enabled',
            AppColors.success,
            Icons.atm,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingLimitsSection(BuildContext context, CardModel card) {
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
          Text(
            'Spending Limits',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Daily Limit
          _buildLimitRow(context, 'Daily Limit', '\$1,000', '\$250', 0.25),
          const SizedBox(height: AppConstants.paddingM),
          
          // Monthly Limit
          _buildLimitRow(context, 'Monthly Limit', '\$5,000', '\$1,250', 0.25),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context) {
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
          
          // Mock transactions
          _buildTransactionItem(context, 'Coffee Shop', '-\$4.50', 'Today'),
          const Divider(),
          _buildTransactionItem(context, 'Online Shopping', '-\$89.99', 'Yesterday'),
          const Divider(),
          _buildTransactionItem(context, 'Gas Station', '-\$45.00', '2 days ago'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSecurityRow(
    BuildContext context,
    String label,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        children: [
          Icon(icon, color: statusColor, size: AppConstants.iconM),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            status,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitRow(BuildContext context, String label, String limit, String used, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$used of $limit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingS),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.neutral200,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.payment,
              color: AppColors.textSecondary,
              size: AppConstants.iconM,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: amount.startsWith('-') ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  CardModel _getMockCard() {
    return CardModel(
      id: widget.cardId,
      name: 'Virtual Card',
      type: CardType.virtual,
      lastFourDigits: '1234',
      expiryDate: DateTime(2027, 12, 31),
      isActive: true,
      isFrozen: false,
      balance: 1500.00,
      currency: 'USD',
      gradient: AppColors.primaryGradient,
      holderName: 'John Doe',
      fullNumber: '4532 1234 5678 1234',
      cvv: '123',
    );
  }

  Color _getStatusColor(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return AppColors.success;
      case CardStatus.inactive:
        return AppColors.textSecondary;
      case CardStatus.blocked:
        return AppColors.warning;
      case CardStatus.expired:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return Icons.check_circle;
      case CardStatus.inactive:
        return Icons.pause_circle;
      case CardStatus.blocked:
        return Icons.block;
      case CardStatus.expired:
        return Icons.error;
    }
  }

  String _getStatusText(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return 'Active';
      case CardStatus.inactive:
        return 'Inactive';
      case CardStatus.blocked:
        return 'Blocked';
      case CardStatus.expired:
        return 'Expired';
    }
  }
}
