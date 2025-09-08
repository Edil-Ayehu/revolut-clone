import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/card_model.dart';

class CardActions extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onFreeze;
  final VoidCallback? onUnfreeze;
  final VoidCallback? onViewPin;
  final VoidCallback? onChangePin;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReplace;
  final VoidCallback? onCancel;

  const CardActions({
    super.key,
    required this.card,
    this.onFreeze,
    this.onUnfreeze,
    this.onViewPin,
    this.onChangePin,
    this.onViewDetails,
    this.onReplace,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
            'Card Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // Primary Actions Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppConstants.paddingM,
            crossAxisSpacing: AppConstants.paddingM,
            childAspectRatio: 2.5,
            children: [
              // Freeze/Unfreeze Card
              _buildActionButton(
                context,
                icon: card.isFrozen ? Icons.play_arrow : Icons.ac_unit,
                label: card.isFrozen ? 'Unfreeze' : 'Freeze',
                color: card.isFrozen ? AppColors.success : AppColors.warning,
                onTap: card.isFrozen ? onUnfreeze : onFreeze,
              ),
              
              // View PIN
              _buildActionButton(
                context,
                icon: Icons.visibility,
                label: 'View PIN',
                color: AppColors.info,
                onTap: onViewPin,
              ),
              
              // Change PIN
              _buildActionButton(
                context,
                icon: Icons.lock_reset,
                label: 'Change PIN',
                color: AppColors.secondary,
                onTap: onChangePin,
              ),
              
              // View Details
              _buildActionButton(
                context,
                icon: Icons.info_outline,
                label: 'Details',
                color: AppColors.primary,
                onTap: onViewDetails,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingL),
          
          // Secondary Actions
          Column(
            children: [
              _buildListAction(
                context,
                icon: Icons.refresh,
                title: 'Replace Card',
                subtitle: 'Order a replacement card',
                onTap: onReplace,
              ),
              Divider(color: Colors.grey.shade200),
              _buildListAction(
                context,
                icon: Icons.block,
                title: 'Cancel Card',
                subtitle: 'Permanently cancel this card',
                color: AppColors.error,
                onTap: onCancel,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingL),
          
          // Card Status Info
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: _getStatusColor(card.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(card.status),
                  color: _getStatusColor(card.status),
                  size: AppConstants.iconM,
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Status',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _getStatusText(card.status),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _getStatusColor(card.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: AppConstants.iconM,
            ),
            const SizedBox(width: AppConstants.paddingS),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    VoidCallback? onTap,
  }) {
    final actionColor = color ?? AppColors.textPrimary;
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: actionColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          icon,
          color: actionColor,
          size: AppConstants.iconM,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: actionColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: AppConstants.iconM,
      ),
      onTap: onTap,
    );
  }

  Color _getStatusColor(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return AppColors.success;
      case CardStatus.inactive:
        return AppColors.textSecondary;
      case CardStatus.blocked:
        return AppColors.warning;
      case CardStatus.expired:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return Icons.check_circle;
      case CardStatus.inactive:
        return Icons.pause_circle;
      case CardStatus.blocked:
        return Icons.block;
      case CardStatus.expired:
        return Icons.error;
    }
  }

  String _getStatusText(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return 'Active';
      case CardStatus.inactive:
        return 'Inactive';
      case CardStatus.blocked:
        return 'Blocked';
      case CardStatus.expired:
        return 'Expired';
    }
  }
}
