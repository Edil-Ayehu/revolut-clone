import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../widgets/portfolio_summary.dart';
import '../widgets/investment_categories.dart';
import '../widgets/trending_assets.dart';
import '../widgets/market_news.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wealth'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.portfolio);
            },
            icon: const Icon(Icons.pie_chart_outline),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to watchlist
            },
            icon: const Icon(Icons.bookmark_outline),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Stocks'),
            Tab(text: 'Crypto'),
            Tab(text: 'News'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildStocksTab(),
            _buildCryptoTab(),
            _buildNewsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Summary
            const PortfolioSummary(),
            const SizedBox(height: AppConstants.paddingL),
            
            // Investment Categories
            const InvestmentCategories(),
            const SizedBox(height: AppConstants.paddingL),
            
            // Trending Assets
            const TrendingAssets(),
            const SizedBox(height: AppConstants.paddingL),
            
            // Quick Actions
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStocksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Market Summary
          _buildMarketSummary(),
          const SizedBox(height: AppConstants.paddingL),
          
          // Popular Stocks
          _buildPopularStocks(),
          const SizedBox(height: AppConstants.paddingL),
          
          // My Holdings
          _buildMyHoldings('Stocks'),
        ],
      ),
    );
  }

  Widget _buildCryptoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crypto Market Summary
          _buildCryptoMarketSummary(),
          const SizedBox(height: AppConstants.paddingL),
          
          // Popular Crypto
          _buildPopularCrypto(),
          const SizedBox(height: AppConstants.paddingL),
          
          // My Holdings
          _buildMyHoldings('Crypto'),
        ],
      ),
    );
  }

  Widget _buildNewsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingM),
      child: MarketNews(),
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
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Invest',
                  Icons.trending_up,
                  AppColors.success,
                  () {
                    // TODO: Navigate to invest
                  },
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Withdraw',
                  Icons.trending_down,
                  AppColors.error,
                  () {
                    // TODO: Navigate to withdraw
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: AppConstants.iconM,
            ),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketSummary() {
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
            'Market Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          Row(
            children: [
              Expanded(
                child: _buildMarketIndex('S&P 500', '4,567.89', '+1.2%', true),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildMarketIndex('NASDAQ', '14,123.45', '+0.8%', true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketIndex(String name, String value, String change, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          change,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isPositive ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularStocks() {
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
                'Popular Stocks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(AppRoutes.stocks);
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          _buildStockItem('AAPL', 'Apple Inc.', '\$175.43', '+2.1%', true),
          const Divider(),
          _buildStockItem('GOOGL', 'Alphabet Inc.', '\$2,847.63', '+1.8%', true),
          const Divider(),
          _buildStockItem('MSFT', 'Microsoft Corp.', '\$378.85', '-0.5%', false),
        ],
      ),
    );
  }

  Widget _buildCryptoMarketSummary() {
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
            'Crypto Market',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          Row(
            children: [
              Expanded(
                child: _buildMarketIndex('Market Cap', '\$2.1T', '+3.2%', true),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildMarketIndex('24h Volume', '\$89.5B', '+5.1%', true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCrypto() {
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
                'Popular Crypto',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(AppRoutes.crypto);
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          _buildStockItem('BTC', 'Bitcoin', '\$43,567.89', '+4.2%', true),
          const Divider(),
          _buildStockItem('ETH', 'Ethereum', '\$2,634.51', '+3.8%', true),
          const Divider(),
          _buildStockItem('ADA', 'Cardano', '\$0.52', '-1.2%', false),
        ],
      ),
    );
  }

  Widget _buildMyHoldings(String type) {
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
            'My $type Holdings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.trending_up,
                  size: AppConstants.iconXL,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  'No $type holdings yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  'Start investing to see your portfolio here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(String symbol, String name, String price, String change, bool isPositive) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          symbol.substring(0, 2),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        symbol,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            price,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            change,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to asset details
      },
    );
  }
}
