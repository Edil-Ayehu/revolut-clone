import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/payment_actions.dart';
import '../widgets/recent_contacts.dart';
import '../widgets/payment_history.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.paymentHistory);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh logic
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Balance Display
                _buildQuickBalance(context),
                const SizedBox(height: AppConstants.paddingL),
                
                // Payment Actions
                const PaymentActions(),
                const SizedBox(height: AppConstants.paddingL),
                
                // Recent Contacts
                const RecentContacts(),
                const SizedBox(height: AppConstants.paddingL),
                
                // Payment History Preview
                const PaymentHistory(),
                const SizedBox(height: AppConstants.paddingL),
                
                // Quick Actions
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBalance(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  '${AppConstants.currencySymbol}12,345.67',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.textOnPrimary,
              size: AppConstants.iconL,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
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
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Pay Bills',
                  icon: Icons.receipt_long,
                  onPressed: () {
                    // TODO: Navigate to pay bills
                  },
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: CustomButton(
                  text: 'Top Up',
                  icon: Icons.add_circle,
                  onPressed: () {
                    // TODO: Navigate to top up
                  },
                  isOutlined: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Split Bill',
                  icon: Icons.call_split,
                  onPressed: () {
                    // TODO: Navigate to split bill
                  },
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: CustomButton(
                  text: 'Recurring',
                  icon: Icons.repeat,
                  onPressed: () {
                    context.push(AppRoutes.recurringPayments);
                  },
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
