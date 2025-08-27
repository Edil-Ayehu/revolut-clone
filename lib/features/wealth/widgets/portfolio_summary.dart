import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class PortfolioSummary extends StatelessWidget {
  const PortfolioSummary({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio Value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Toggle portfolio visibility
                },
                icon: const Icon(
                  Icons.visibility,
                  color: AppColors.textOnPrimary,
                  size: AppConstants.iconM,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          
          // Total Value
          Text(
            '${AppConstants.currencySymbol}25,847.63',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          
          // Change Indicator
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
                      '+\$1,247.85 (+5.1%)',
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
                'Today',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Portfolio Breakdown
          Row(
            children: [
              Expanded(
                child: _buildPortfolioItem(
                  context,
                  'Stocks',
                  '\$18,234.56',
                  '70.5%',
                  AppColors.stocksColor,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildPortfolioItem(
                  context,
                  'Crypto',
                  '\$5,123.45',
                  '19.8%',
                  AppColors.cryptoColor,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildPortfolioItem(
                  context,
                  'Commodities',
                  '\$2,489.62',
                  '9.7%',
                  AppColors.commoditiesColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(
    BuildContext context,
    String category,
    String value,
    String percentage,
    Color color,
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
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                category,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            percentage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
