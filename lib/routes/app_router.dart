import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import all pages (will be created in subsequent tasks)
import '../features/auth/pages/splash_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/pages/phone_verification_page.dart';
import '../features/auth/pages/pin_setup_page.dart';
import '../features/home/pages/main_navigation_page.dart';
import '../features/home/pages/dashboard_page.dart';
import '../features/cards/pages/cards_page.dart';
import '../features/cards/pages/card_details_page.dart';
import '../features/payments/pages/payments_page.dart';
import '../features/payments/pages/send_money_page.dart';
import '../features/payments/pages/exchange_currency_page.dart';
import '../features/payments/pages/add_money_page.dart';
import '../features/payments/pages/transaction_details_page.dart';
import '../features/wealth/pages/wealth_page.dart';
import '../features/wealth/pages/stocks_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/settings_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.phoneVerification,
        name: 'phone-verification',
        builder: (context, state) => PhoneVerificationPage(
          phoneNumber: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.pinSetup,
        name: 'pin-setup',
        builder: (context, state) => const PinSetupPage(),
      ),
      
      // Main App Routes with Shell Route for Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.cards,
            name: 'cards',
            builder: (context, state) => const CardsPage(),
            routes: [
              GoRoute(
                path: '/details/:cardId',
                name: 'card-details',
                builder: (context, state) => CardDetailsPage(
                  cardId: state.pathParameters['cardId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.payments,
            name: 'payments',
            builder: (context, state) => const PaymentsPage(),
            routes: [
              GoRoute(
                path: '/send',
                name: 'send-money',
                builder: (context, state) => const SendMoneyPage(),
              ),
              GoRoute(
                path: '/exchange',
                name: 'exchange-currency',
                builder: (context, state) => const ExchangeCurrencyPage(),
              ),
              GoRoute(
                path: 'add-money',
                name: 'add-money',
                builder: (context, state) => const AddMoneyPage(),
              ),
              GoRoute(
                path: 'transaction/:id',
                name: 'transaction-details',
                builder: (context, state) => TransactionDetailsPage(
                  transactionId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.wealth,
            name: 'wealth',
            builder: (context, state) => const WealthPage(),
            routes: [
              GoRoute(
                path: '/stocks',
                name: 'stocks',
                builder: (context, state) => const StocksPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
