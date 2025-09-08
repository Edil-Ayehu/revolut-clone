class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final double exchangeRate; // Rate relative to base currency (USD)

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.exchangeRate,
  });

  // Convert amount from this currency to target currency
  double convert(double amount, Currency targetCurrency) {
    // First convert to USD (base currency), then to target currency
    final amountInUSD = amount / exchangeRate;
    return amountInUSD * targetCurrency.exchangeRate;
  }

  // Format amount with currency symbol
  String formatAmount(double amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Create a copy of this currency with updated properties
  Currency copyWith({
    String? code,
    String? name,
    String? symbol,
    String? flag,
    double? exchangeRate,
  }) {
    return Currency(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      flag: flag ?? this.flag,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  // List of common currencies with their details
  static List<Currency> getCommonCurrencies() {
    return [
      Currency(
        code: 'USD',
        name: 'US Dollar',
        symbol: '\$',
        flag: '🇺🇸',
        exchangeRate: 1.0, // Base currency
      ),
      Currency(
        code: 'EUR',
        name: 'Euro',
        symbol: '€',
        flag: '🇪🇺',
        exchangeRate: 0.92, // Example rate: 1 USD = 0.92 EUR
      ),
      Currency(
        code: 'GBP',
        name: 'British Pound',
        symbol: '£',
        flag: '🇬🇧',
        exchangeRate: 0.79, // Example rate: 1 USD = 0.79 GBP
      ),
      Currency(
        code: 'JPY',
        name: 'Japanese Yen',
        symbol: '¥',
        flag: '🇯🇵',
        exchangeRate: 150.59, // Example rate: 1 USD = 150.59 JPY
      ),
      Currency(
        code: 'CAD',
        name: 'Canadian Dollar',
        symbol: 'C\$',
        flag: '🇨🇦',
        exchangeRate: 1.36, // Example rate: 1 USD = 1.36 CAD
      ),
      Currency(
        code: 'AUD',
        name: 'Australian Dollar',
        symbol: 'A\$',
        flag: '🇦🇺',
        exchangeRate: 1.52, // Example rate: 1 USD = 1.52 AUD
      ),
      Currency(
        code: 'CHF',
        name: 'Swiss Franc',
        symbol: 'Fr',
        flag: '🇨🇭',
        exchangeRate: 0.90, // Example rate: 1 USD = 0.90 CHF
      ),
      Currency(
        code: 'CNY',
        name: 'Chinese Yuan',
        symbol: '¥',
        flag: '🇨🇳',
        exchangeRate: 7.24, // Example rate: 1 USD = 7.24 CNY
      ),
      Currency(
        code: 'INR',
        name: 'Indian Rupee',
        symbol: '₹',
        flag: '🇮🇳',
        exchangeRate: 83.10, // Example rate: 1 USD = 83.10 INR
      ),
      Currency(
        code: 'BRL',
        name: 'Brazilian Real',
        symbol: 'R\$',
        flag: '🇧🇷',
        exchangeRate: 5.05, // Example rate: 1 USD = 5.05 BRL
      ),
    ];
  }
}