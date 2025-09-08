import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class InvestmentCategories extends StatelessWidget {
  const InvestmentCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investment Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppConstants.paddingM,
          crossAxisSpacing: AppConstants.paddingM,
          childAspectRatio: 1.2,
          children: [
            _buildCategoryCard(
              context,
              'Stocks',
              'Individual stocks & ETFs',
              Icons.trending_up,
              AppColors.stocksColor,
              () => context.push(AppRoutes.stocks),
            ),
            _buildCategoryCard(
              context,
              'Crypto',
              'Digital currencies',
              Icons.currency_bitcoin,
              AppColors.cryptoColor,
              () => context.push(AppRoutes.crypto),
            ),
            _buildCategoryCard(
              context,
              'Commodities',
              'Gold, silver & more',
              Icons.diamond,
              AppColors.commoditiesColor,
              () => context.push(AppRoutes.commodities),
            ),
            _buildCategoryCard(
              context,
              'Savings',
              'High-yield accounts',
              Icons.savings,
              AppColors.savingsColor,
              () {
                // TODO: Navigate to savings
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
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
        padding: const EdgeInsets.symmetric(horizontal:AppConstants.paddingL, vertical: 12),
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
            const SizedBox(height: AppConstants.paddingM - 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingXS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: color,
                  size: AppConstants.iconS,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
