import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh logic
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'JD',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to settings
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Balance Card
                    BalanceCard(
                      balance: 12345.67,
                      isVisible: _isBalanceVisible,
                      onToggleVisibility: _toggleBalanceVisibility,
                    ),
                    const SizedBox(height: AppConstants.paddingL),
                    
                    // Quick Actions
                    const QuickActions(),
                    const SizedBox(height: AppConstants.paddingL),
                    
                    // Spending Insights
                    _buildSpendingInsights(),
                    const SizedBox(height: AppConstants.paddingL),
                    
                    // Recent Transactions
                    const RecentTransactions(),
                    const SizedBox(height: AppConstants.paddingL),
                    
                    // Promotional Banner
                    _buildPromotionalBanner(),
                    const SizedBox(height: AppConstants.paddingXL),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingInsights() {
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
                'This month',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to analytics
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Spending Categories
          Row(
            children: [
              Expanded(
                child: _buildSpendingCategory(
                  'Food & Dining',
                  '\$456.78',
                  AppColors.error,
                  0.6,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildSpendingCategory(
                  'Shopping',
                  '\$234.56',
                  AppColors.warning,
                  0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildSpendingCategory(
                  'Transport',
                  '\$123.45',
                  AppColors.info,
                  0.3,
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _buildSpendingCategory(
                  'Entertainment',
                  '\$89.12',
                  AppColors.success,
                  0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingCategory(String category, String amount, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingXS),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.neutral200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite friends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  'Get \$10 for each friend who joins',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),
                CustomButton(
                  text: 'Invite now',
                  onPressed: () {
                    // TODO: Implement invite functionality
                  },
                  backgroundColor: AppColors.surface,
                  textColor: AppColors.secondary,
                  height: 40,
                  width: 120,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.card_giftcard,
            size: AppConstants.iconXL,
            color: AppColors.textOnPrimary,
          ),
        ],
      ),
    );
  }
}
