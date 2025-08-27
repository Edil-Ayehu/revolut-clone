import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('${AppRoutes.profile}/settings');
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(context),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Account Section
              _buildAccountSection(context),
              const SizedBox(height: AppConstants.paddingL),
              
              // Security Section
              _buildSecuritySection(context),
              const SizedBox(height: AppConstants.paddingL),
              
              // Support Section
              _buildSupportSection(context),
              const SizedBox(height: AppConstants.paddingL),
              
              // About Section
              _buildAboutSection(context),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Sign Out Button
              _buildSignOutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
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
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Text(
                  'JD',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.surface,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.textOnPrimary,
                    size: AppConstants.iconS,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          // User Info
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM,
              vertical: AppConstants.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified,
                  color: AppColors.success,
                  size: AppConstants.iconS,
                ),
                const SizedBox(width: AppConstants.paddingS),
                Text(
                  'Verified Account',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      context,
      'Account',
      [
        _buildMenuItem(
          context,
          'Personal Information',
          'Update your personal details',
          Icons.person_outline,
          () {
            // TODO: Navigate to personal info
          },
        ),
        _buildMenuItem(
          context,
          'Payment Methods',
          'Manage cards and bank accounts',
          Icons.payment,
          () {
            // TODO: Navigate to payment methods
          },
        ),
        _buildMenuItem(
          context,
          'Transaction History',
          'View all your transactions',
          Icons.history,
          () {
            context.push(AppRoutes.transactions);
          },
        ),
        _buildMenuItem(
          context,
          'Limits & Verification',
          'Account limits and verification status',
          Icons.verified_user_outlined,
          () {
            // TODO: Navigate to limits
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSection(
      context,
      'Security',
      [
        _buildMenuItem(
          context,
          'Security Settings',
          'PIN, biometrics, and 2FA',
          Icons.security,
          () {
            context.push(AppRoutes.securitySettings);
          },
        ),
        _buildMenuItem(
          context,
          'Privacy Settings',
          'Control your privacy preferences',
          Icons.privacy_tip_outlined,
          () {
            context.push(AppRoutes.privacySettings);
          },
        ),
        _buildMenuItem(
          context,
          'Notification Settings',
          'Manage your notifications',
          Icons.notifications_outlined,
          () {
            context.push(AppRoutes.notificationSettings);
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      context,
      'Support',
      [
        _buildMenuItem(
          context,
          'Help Center',
          'Get help and support',
          Icons.help_outline,
          () {
            context.push(AppRoutes.help);
          },
        ),
        _buildMenuItem(
          context,
          'Contact Support',
          'Chat with our support team',
          Icons.support_agent,
          () {
            context.push(AppRoutes.support);
          },
        ),
        _buildMenuItem(
          context,
          'Feedback',
          'Share your feedback with us',
          Icons.feedback_outlined,
          () {
            // TODO: Navigate to feedback
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      'About',
      [
        _buildMenuItem(
          context,
          'Terms of Service',
          'Read our terms and conditions',
          Icons.description_outlined,
          () {
            // TODO: Navigate to terms
          },
        ),
        _buildMenuItem(
          context,
          'Privacy Policy',
          'Read our privacy policy',
          Icons.policy_outlined,
          () {
            // TODO: Navigate to privacy policy
          },
        ),
        _buildMenuItem(
          context,
          'About Revolut Clone',
          'App version and information',
          Icons.info_outline,
          () {
            context.push(AppRoutes.about);
          },
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
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

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
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
        subtitle,
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

  Widget _buildSignOutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: () {
          _showSignOutDialog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: AppColors.error,
              size: AppConstants.iconM,
            ),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              'Sign Out',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out logic
              context.go(AppRoutes.login);
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
