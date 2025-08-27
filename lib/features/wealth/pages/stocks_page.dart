import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_text_field.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({super.key});

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
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
            Tab(text: 'Popular'),
            Tab(text: 'Gainers'),
            Tab(text: 'Losers'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: SearchTextField(
                controller: _searchController,
                hint: 'Search stocks...',
                onChanged: (value) {
                  // TODO: Implement search
                },
                onClear: () {
                  _searchController.clear();
                },
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStocksList(_getPopularStocks()),
                  _buildStocksList(_getGainerStocks()),
                  _buildStocksList(_getLoserStocks()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStocksList(List<StockItem> stocks) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      itemCount: stocks.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return _buildStockListItem(stock);
      },
    );
  }

  Widget _buildStockListItem(StockItem stock) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          stock.symbol.substring(0, 2),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        stock.symbol,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stock.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXS),
          Row(
            children: [
              Text(
                'Vol: ${stock.volume}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Text(
                'Mkt Cap: ${stock.marketCap}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            stock.price,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingS,
              vertical: AppConstants.paddingXS,
            ),
            decoration: BoxDecoration(
              color: stock.isPositive 
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stock.isPositive ? Icons.trending_up : Icons.trending_down,
                  color: stock.isPositive ? AppColors.success : AppColors.error,
                  size: AppConstants.iconS,
                ),
                const SizedBox(width: AppConstants.paddingXS),
                Text(
                  stock.change,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: stock.isPositive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        context.push('${context.namedLocation('stocks')}/details/${stock.symbol}');
      },
    );
  }

  List<StockItem> _getPopularStocks() {
    return [
      StockItem(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        price: '\$175.43',
        change: '+2.1%',
        isPositive: true,
        volume: '45.2M',
        marketCap: '\$2.8T',
      ),
      StockItem(
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        price: '\$2,847.63',
        change: '+1.8%',
        isPositive: true,
        volume: '1.2M',
        marketCap: '\$1.8T',
      ),
      StockItem(
        symbol: 'MSFT',
        name: 'Microsoft Corp.',
        price: '\$378.85',
        change: '-0.5%',
        isPositive: false,
        volume: '23.1M',
        marketCap: '\$2.8T',
      ),
      StockItem(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        price: '\$248.50',
        change: '-1.8%',
        isPositive: false,
        volume: '89.5M',
        marketCap: '\$789B',
      ),
      StockItem(
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        price: '\$3,467.42',
        change: '+0.9%',
        isPositive: true,
        volume: '2.8M',
        marketCap: '\$1.7T',
      ),
    ];
  }

  List<StockItem> _getGainerStocks() {
    return [
      StockItem(
        symbol: 'NVDA',
        name: 'NVIDIA Corp.',
        price: '\$875.28',
        change: '+8.5%',
        isPositive: true,
        volume: '67.3M',
        marketCap: '\$2.2T',
      ),
      StockItem(
        symbol: 'AMD',
        name: 'Advanced Micro Devices',
        price: '\$142.67',
        change: '+6.2%',
        isPositive: true,
        volume: '45.1M',
        marketCap: '\$230B',
      ),
      StockItem(
        symbol: 'NFLX',
        name: 'Netflix Inc.',
        price: '\$487.83',
        change: '+4.7%',
        isPositive: true,
        volume: '8.9M',
        marketCap: '\$217B',
      ),
    ];
  }

  List<StockItem> _getLoserStocks() {
    return [
      StockItem(
        symbol: 'META',
        name: 'Meta Platforms Inc.',
        price: '\$487.11',
        change: '-3.2%',
        isPositive: false,
        volume: '15.7M',
        marketCap: '\$1.2T',
      ),
      StockItem(
        symbol: 'UBER',
        name: 'Uber Technologies',
        price: '\$62.45',
        change: '-2.8%',
        isPositive: false,
        volume: '22.4M',
        marketCap: '\$128B',
      ),
      StockItem(
        symbol: 'SNAP',
        name: 'Snap Inc.',
        price: '\$11.23',
        change: '-4.1%',
        isPositive: false,
        volume: '34.6M',
        marketCap: '\$18.2B',
      ),
    ];
  }
}

class StockItem {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final bool isPositive;
  final String volume;
  final String marketCap;

  StockItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.volume,
    required this.marketCap,
  });
}
