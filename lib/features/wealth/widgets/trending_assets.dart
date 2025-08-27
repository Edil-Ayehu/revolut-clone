import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class TrendingAssets extends StatelessWidget {
  const TrendingAssets({super.key});

  @override
  Widget build(BuildContext context) {
    final trendingAssets = _getMockTrendingAssets();

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
                'Trending Assets',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to trending assets
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trendingAssets.length,
              itemBuilder: (context, index) {
                final asset = trendingAssets[index];
                return _buildTrendingAssetCard(context, asset);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingAssetCard(BuildContext context, TrendingAsset asset) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: asset.isPositive 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: asset.isPositive 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  asset.symbol.substring(0, 2),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                asset.isPositive ? Icons.trending_up : Icons.trending_down,
                color: asset.isPositive ? AppColors.success : AppColors.error,
                size: AppConstants.iconS,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            asset.symbol,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            asset.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                asset.price,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                asset.change,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: asset.isPositive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TrendingAsset> _getMockTrendingAssets() {
    return [
      TrendingAsset(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        price: '\$175.43',
        change: '+2.1%',
        isPositive: true,
      ),
      TrendingAsset(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: '\$43,567',
        change: '+4.2%',
        isPositive: true,
      ),
      TrendingAsset(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        price: '\$248.50',
        change: '-1.8%',
        isPositive: false,
      ),
      TrendingAsset(
        symbol: 'ETH',
        name: 'Ethereum',
        price: '\$2,634',
        change: '+3.8%',
        isPositive: true,
      ),
      TrendingAsset(
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        price: '\$2,847',
        change: '+1.8%',
        isPositive: true,
      ),
    ];
  }
}

class TrendingAsset {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final bool isPositive;

  TrendingAsset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.isPositive,
  });
}
