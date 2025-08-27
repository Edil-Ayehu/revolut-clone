import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        // Primary Actions Row
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                context,
                'Send',
                Icons.send,
                AppColors.primary,
                () => context.push(AppRoutes.sendMoney),
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: _buildQuickAction(
                context,
                'Request',
                Icons.request_page,
                AppColors.secondary,
                () => context.push(AppRoutes.requestMoney),
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: _buildQuickAction(
                context,
                'Top Up',
                Icons.add_circle,
                AppColors.success,
                () {
                  // TODO: Implement top up
                },
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: _buildQuickAction(
                context,
                'Exchange',
                Icons.swap_horiz,
                AppColors.warning,
                () => context.push(AppRoutes.exchange),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        // Secondary Actions
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSecondaryAction(
                context,
                'Pay Bills',
                Icons.receipt_long,
                () {
                  // TODO: Implement pay bills
                },
              ),
              const SizedBox(width: AppConstants.paddingM),
              _buildSecondaryAction(
                context,
                'Mobile Top Up',
                Icons.phone_android,
                () {
                  // TODO: Implement mobile top up
                },
              ),
              const SizedBox(width: AppConstants.paddingM),
              _buildSecondaryAction(
                context,
                'Investments',
                Icons.trending_up,
                () => context.push(AppRoutes.wealth),
              ),
              const SizedBox(width: AppConstants.paddingM),
              _buildSecondaryAction(
                context,
                'Insurance',
                Icons.security,
                () {
                  // TODO: Implement insurance
                },
              ),
              const SizedBox(width: AppConstants.paddingM),
              _buildSecondaryAction(
                context,
                'Loans',
                Icons.account_balance,
                () {
                  // TODO: Implement loans
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.paddingL,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppConstants.iconM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingM,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          border: Border.all(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: AppConstants.iconS,
            ),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
