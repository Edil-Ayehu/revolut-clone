import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/card_widget.dart';
import '../widgets/card_actions.dart';
import '../../../shared/models/card_model.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final PageController _pageController = PageController();
  int _currentCardIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from provider
    final cards = _getMockCards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to card settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Cards Carousel
              if (cards.isNotEmpty) ...[
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCardIndex = index;
                    });
                  },
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM,
                      ),
                      child: CardWidget(
                        card: cards[index],
                        onTap: () {
                          context.push(
                            '${AppRoutes.cards}/details/${cards[index].id}',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.paddingM),
              
              // Card Indicators
              if (cards.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    cards.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingXS,
                      ),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentCardIndex
                            ? AppColors.primary
                            : AppColors.neutral300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppConstants.paddingL),
              
              // Card Actions
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                ),
                child: CardActions(
                  card: cards[_currentCardIndex],
                  onFreeze: () => _freezeCard(cards[_currentCardIndex]),
                  onUnfreeze: () => _unfreezeCard(cards[_currentCardIndex]),
                  onViewPin: () => _viewPin(cards[_currentCardIndex]),
                  onChangePin: () => _changePin(cards[_currentCardIndex]),
                  onViewDetails: () => context.push(
                    '${AppRoutes.cards}/details/${cards[_currentCardIndex].id}',
                  ),
                ),
              ),
            ] else
              // Empty State
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_off,
                        size: AppConstants.iconXL * 2,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      Text(
                        'No cards yet',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Text(
                        'Add your first card to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: AppConstants.paddingL),
            
            // Add Card Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: CustomButton(
                text: 'Add New Card',
                icon: Icons.add,
                onPressed: () {
                  context.push(AppRoutes.addCard);
                },
              ),
            ),
            // Add bottom padding to prevent content from being cut off
            const SizedBox(height: kBottomNavigationBarHeight),
          ],
          ),
        ),
      ),
    );
  }

  void _freezeCard(CardModel card) {
    // TODO: Implement freeze card functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.name} has been frozen'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _unfreezeCard(CardModel card) {
    // TODO: Implement unfreeze card functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.name} has been unfrozen'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewPin(CardModel card) {
    // TODO: Implement view PIN functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card PIN'),
        content: const Text('PIN: ••••'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _changePin(CardModel card) {
    // TODO: Implement change PIN functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN change feature coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  List<CardModel> _getMockCards() {
    return [
      CardModel(
        id: '1',
        name: 'Virtual Card',
        type: CardType.virtual,
        lastFourDigits: '1234',
        expiryDate: DateTime(2027, 12, 31),
        isActive: true,
        isFrozen: false,
        balance: 1500.00,
        currency: 'USD',
        gradient: AppColors.primaryGradient,
      ),
      CardModel(
        id: '2',
        name: 'Physical Card',
        type: CardType.physical,
        lastFourDigits: '5678',
        expiryDate: DateTime(2026, 8, 31),
        isActive: true,
        isFrozen: false,
        balance: 2500.00,
        currency: 'USD',
        gradient: AppColors.cardGradient,
      ),
    ];
  }
}
