import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textOnPrimary,
                      size: AppConstants.iconM,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Show balance options
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.textOnPrimary,
                      size: AppConstants.iconM,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          
          // Balance Amount
          AnimatedSwitcher(
            duration: AppConstants.shortAnimation,
            child: Text(
              isVisible 
                  ? '${AppConstants.currencySymbol}${_formatBalance(balance)}'
                  : '••••••',
              key: ValueKey(isVisible),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          
          // Balance Change
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingS,
                  vertical: AppConstants.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                      size: AppConstants.iconS,
                    ),
                    const SizedBox(width: AppConstants.paddingXS),
                    Text(
                      '+2.5%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                'vs last month',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Account Types
          Row(
            children: [
              Expanded(
                child: _buildAccountType(
                  context,
                  'Current',
                  isVisible ? '\$8,234.56' : '••••••',
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildAccountType(
                  context,
                  'Savings',
                  isVisible ? '\$4,111.11' : '••••••',
                  Icons.savings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountType(
    BuildContext context,
    String type,
    String amount,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: AppConstants.iconS,
              ),
              const SizedBox(width: AppConstants.paddingXS),
              Text(
                type,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingXS),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBalance(double balance) {
    if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(1)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    } else {
      return balance.toStringAsFixed(2);
    }
  }
}
