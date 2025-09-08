import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class PaymentActions extends StatelessWidget {
  const PaymentActions({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Quick Payments',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Primary Actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Send Money',
                  'Transfer to friends',
                  Icons.send,
                  AppColors.primary,
                  () => context.push(AppRoutes.sendMoney),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Request Money',
                  'Ask for payment',
                  Icons.request_page,
                  AppColors.secondary,
                  () => context.push(AppRoutes.requestMoney),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Secondary Actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Exchange',
                  'Convert currencies',
                  Icons.currency_exchange,
                  AppColors.info,
                  () => context.push('${AppRoutes.payments}/exchange'),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Scan QR',
                  'Pay with QR code',
                  Icons.qr_code_scanner,
                  AppColors.success,
                  () {
                    // TODO: Implement QR scanner
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Tertiary Actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Pay Nearby',
                  'Contactless payment',
                  Icons.nfc,
                  AppColors.warning,
                  () {
                    // TODO: Implement NFC payment
                  },
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Add Money',
                  'Deposit funds',
                  Icons.add_circle_outline,
                  AppColors.success,
                  () => context.push(AppRoutes.addMoney),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: AppConstants.iconM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
