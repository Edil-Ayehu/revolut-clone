class AppConstants {
  // App Info
  static const String appName = 'Revolut Clone';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.revolut-clone.com';
  static const String authEndpoint = '/auth';
  static const String userEndpoint = '/user';
  static const String transactionsEndpoint = '/transactions';
  static const String cardsEndpoint = '/cards';
  static const String wealthEndpoint = '/wealth';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String pinSetKey = 'pin_set';
  static const String themeKey = 'theme_mode';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  
  // Validation
  static const int minPinLength = 4;
  static const int maxPinLength = 6;
  static const int phoneNumberLength = 10;
  
  // Transaction Types
  static const String transactionTypeTransfer = 'transfer';
  static const String transactionTypePayment = 'payment';
  static const String transactionTypeTopUp = 'top_up';
  static const String transactionTypeWithdrawal = 'withdrawal';
  static const String transactionTypeExchange = 'exchange';
  
  // Card Types
  static const String cardTypeVirtual = 'virtual';
  static const String cardTypePhysical = 'physical';
  
  // Wealth Categories
  static const String wealthStocks = 'stocks';
  static const String wealthCrypto = 'crypto';
  static const String wealthCommodities = 'commodities';
  static const String wealthSavings = 'savings';
}
