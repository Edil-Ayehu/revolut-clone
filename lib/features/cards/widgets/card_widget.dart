import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onTap;
  final bool showBalance;
  final bool isCompact;

  const CardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.showBalance = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: isCompact ? 160 : 200,
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          gradient: card.gradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: card.gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Type and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXS),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingS,
                            vertical: AppConstants.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          ),
                          child: Text(
                            card.type == CardType.virtual ? 'Virtual' : 'Physical',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (card.isFrozen) ...[
                          const SizedBox(width: AppConstants.paddingS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingS,
                              vertical: AppConstants.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusS),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.ac_unit,
                                  size: AppConstants.iconS,
                                  color: AppColors.textOnPrimary,
                                ),
                                const SizedBox(width: AppConstants.paddingXS),
                                Text(
                                  'Frozen',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                
                // Card Brand Logo
                Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: const Center(
                    child: Text(
                      'VISA',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Card Number
            Text(
              card.maskedNumber,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            
            if (!isCompact) ...[
              const SizedBox(height: AppConstants.paddingM),
              
              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Balance (if shown)
                  if (showBalance)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textOnPrimary.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          '${AppConstants.currencySymbol}${card.balance.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  else
                    // Cardholder Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardholder',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textOnPrimary.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          card.holderName ?? 'John Doe',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  
                  // Expiry Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Expires',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        card.expiryString,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CardWidgetCompact extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onTap;

  const CardWidgetCompact({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Card Preview
            Container(
              width: 60,
              height: 38,
              decoration: BoxDecoration(
                gradient: card.gradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Center(
                child: Text(
                  '••••',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            
            // Card Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXS),
                  Text(
                    '•••• ${card.lastFourDigits}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status Indicator
            if (card.isFrozen)
              const Icon(
                Icons.ac_unit,
                color: AppColors.warning,
                size: AppConstants.iconS,
              )
            else if (!card.isActive)
              const Icon(
                Icons.block,
                color: AppColors.error,
                size: AppConstants.iconS,
              )
            else
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: AppConstants.iconS,
              ),
          ],
        ),
      ),
    );
  }
}
