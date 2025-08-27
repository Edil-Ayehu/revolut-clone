import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            children: [
              // General Settings
              _buildSettingsSection(
                context,
                'General',
                [
                  _buildSwitchTile(
                    context,
                    'Notifications',
                    'Receive push notifications',
                    Icons.notifications_outlined,
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _buildSwitchTile(
                    context,
                    'Dark Mode',
                    'Use dark theme',
                    Icons.dark_mode_outlined,
                    _darkModeEnabled,
                    (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                  _buildSelectionTile(
                    context,
                    'Currency',
                    _selectedCurrency,
                    Icons.attach_money,
                    () => _showCurrencySelector(context),
                  ),
                  _buildSelectionTile(
                    context,
                    'Language',
                    _selectedLanguage,
                    Icons.language,
                    () => _showLanguageSelector(context),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingL),
              
              // Security Settings
              _buildSettingsSection(
                context,
                'Security',
                [
                  _buildSwitchTile(
                    context,
                    'Biometric Authentication',
                    'Use fingerprint or face ID',
                    Icons.fingerprint,
                    _biometricsEnabled,
                    (value) {
                      setState(() {
                        _biometricsEnabled = value;
                      });
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Change PIN',
                    'Update your security PIN',
                    Icons.lock_outline,
                    () {
                      // TODO: Navigate to change PIN
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Two-Factor Authentication',
                    'Add extra security to your account',
                    Icons.security,
                    () {
                      // TODO: Navigate to 2FA setup
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingL),
              
              // Privacy Settings
              _buildSettingsSection(
                context,
                'Privacy',
                [
                  _buildActionTile(
                    context,
                    'Data & Privacy',
                    'Manage your data and privacy settings',
                    Icons.privacy_tip_outlined,
                    () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Download My Data',
                    'Get a copy of your data',
                    Icons.download_outlined,
                    () {
                      // TODO: Implement data download
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Delete Account',
                    'Permanently delete your account',
                    Icons.delete_outline,
                    () => _showDeleteAccountDialog(context),
                    isDestructive: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
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
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: AppConstants.iconM,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSelectionTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: AppConstants.iconM,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: AppConstants.iconM,
      ),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
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
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : null,
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

  void _showCurrencySelector(BuildContext context) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Currency',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            ...currencies.map((currency) => ListTile(
              title: Text(currency),
              trailing: _selectedCurrency == currency
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedCurrency = currency;
                });
                Navigator.of(context).pop();
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            ...languages.map((language) => ListTile(
              title: Text(language),
              trailing: _selectedLanguage == language
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = language;
                });
                Navigator.of(context).pop();
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement account deletion
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
