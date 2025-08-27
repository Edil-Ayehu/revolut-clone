import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class MarketNews extends StatelessWidget {
  const MarketNews({super.key});

  @override
  Widget build(BuildContext context) {
    final newsItems = _getMockNewsItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market News',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppConstants.paddingM),
          itemBuilder: (context, index) {
            final newsItem = newsItems[index];
            return _buildNewsCard(context, newsItem);
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsItem newsItem) {
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
          // News Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingS,
                  vertical: AppConstants.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(newsItem.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  newsItem.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _getCategoryColor(newsItem.category),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                newsItem.timeAgo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // News Title
          Text(
            newsItem.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.paddingS),
          
          // News Summary
          Text(
            newsItem.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // News Footer
          Row(
            children: [
              Text(
                newsItem.source,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (newsItem.impact != null) ...[
                Icon(
                  newsItem.impact == 'positive' 
                      ? Icons.trending_up 
                      : newsItem.impact == 'negative'
                          ? Icons.trending_down
                          : Icons.trending_flat,
                  color: newsItem.impact == 'positive' 
                      ? AppColors.success 
                      : newsItem.impact == 'negative'
                          ? AppColors.error
                          : AppColors.textSecondary,
                  size: AppConstants.iconS,
                ),
                const SizedBox(width: AppConstants.paddingXS),
                Text(
                  newsItem.impact == 'positive' 
                      ? 'Bullish' 
                      : newsItem.impact == 'negative'
                          ? 'Bearish'
                          : 'Neutral',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: newsItem.impact == 'positive' 
                        ? AppColors.success 
                        : newsItem.impact == 'negative'
                            ? AppColors.error
                            : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stocks':
        return AppColors.stocksColor;
      case 'crypto':
        return AppColors.cryptoColor;
      case 'commodities':
        return AppColors.commoditiesColor;
      case 'market':
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  List<NewsItem> _getMockNewsItems() {
    return [
      NewsItem(
        title: 'Apple Reports Strong Q4 Earnings, Beats Expectations',
        summary: 'Apple Inc. reported quarterly earnings that exceeded Wall Street expectations, driven by strong iPhone sales and services revenue growth.',
        category: 'Stocks',
        source: 'Financial Times',
        timeAgo: '2h ago',
        impact: 'positive',
      ),
      NewsItem(
        title: 'Bitcoin Surges Past \$45,000 on Institutional Adoption',
        summary: 'Bitcoin reached a new monthly high as major institutions continue to adopt cryptocurrency as a store of value, boosting market confidence.',
        category: 'Crypto',
        source: 'CoinDesk',
        timeAgo: '4h ago',
        impact: 'positive',
      ),
      NewsItem(
        title: 'Federal Reserve Hints at Interest Rate Changes',
        summary: 'The Federal Reserve indicated potential changes to interest rates in the coming months, citing inflation concerns and economic growth.',
        category: 'Market',
        source: 'Reuters',
        timeAgo: '6h ago',
        impact: 'neutral',
      ),
      NewsItem(
        title: 'Gold Prices Fall Amid Dollar Strength',
        summary: 'Gold futures declined as the US dollar strengthened against major currencies, reducing demand for the precious metal as a hedge.',
        category: 'Commodities',
        source: 'Bloomberg',
        timeAgo: '8h ago',
        impact: 'negative',
      ),
      NewsItem(
        title: 'Tech Stocks Rally on AI Innovation News',
        summary: 'Technology stocks surged following announcements of breakthrough AI innovations from major tech companies, boosting sector confidence.',
        category: 'Stocks',
        source: 'TechCrunch',
        timeAgo: '12h ago',
        impact: 'positive',
      ),
    ];
  }
}

class NewsItem {
  final String title;
  final String summary;
  final String category;
  final String source;
  final String timeAgo;
  final String? impact; // 'positive', 'negative', 'neutral'

  NewsItem({
    required this.title,
    required this.summary,
    required this.category,
    required this.source,
    required this.timeAgo,
    this.impact,
  });
}
