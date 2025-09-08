import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/currency_model.dart';
import '../../../shared/widgets/custom_button.dart';

class ExchangeCurrencyPage extends StatefulWidget {
  const ExchangeCurrencyPage({super.key});

  @override
  State<ExchangeCurrencyPage> createState() => _ExchangeCurrencyPageState();
}

class _ExchangeCurrencyPageState extends State<ExchangeCurrencyPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '100.00');
  
  late List<Currency> _currencies;
  late Currency _fromCurrency;
  late Currency _toCurrency;
  
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _currencies = Currency.getCommonCurrencies();
    _fromCurrency = _currencies.firstWhere((c) => c.code == 'USD');
    _toCurrency = _currencies.firstWhere((c) => c.code == 'EUR');
    _calculateConversion();
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  void _calculateConversion() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _convertedAmount = _fromCurrency.convert(amount, _toCurrency);
    });
  }
  
  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _calculateConversion();
    });
  }
  
  void _handleExchange() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // Show success dialog
          _showExchangeSuccessDialog();
        }
      });
    }
  }
  
  void _showCurrencySelector(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusL)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Currency',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search currencies',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _currencies.length,
                  itemBuilder: (context, index) {
                    final currency = _currencies[index];
                    final isSelected = isFromCurrency
                        ? currency.code == _fromCurrency.code
                        : currency.code == _toCurrency.code;
                    
                    return ListTile(
                      leading: Text(
                        currency.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(currency.code),
                      subtitle: Text(currency.name),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isFromCurrency) {
                            _fromCurrency = currency;
                          } else {
                            _toCurrency = currency;
                          }
                          _calculateConversion();
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showExchangeSuccessDialog() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              'Exchange Successful',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              'You have exchanged ${_fromCurrency.formatAmount(amount)} to ${_toCurrency.formatAmount(_convertedAmount)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXL),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Go back to previous screen
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rate = _fromCurrency.exchangeRate / _toCurrency.exchangeRate;
    final inverseRate = _toCurrency.exchangeRate / _fromCurrency.exchangeRate;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From Currency Card
                    _buildCurrencyCard(
                      title: 'From',
                      currency: _fromCurrency,
                      controller: _amountController,
                      isSource: true,
                      onCurrencyTap: () => _showCurrencySelector(true),
                    ),
                    
                    // Swap Button
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                          ),
                          onPressed: _swapCurrencies,
                        ),
                      ),
                    ),
                    
                    // To Currency Card
                    _buildCurrencyCard(
                      title: 'To',
                      currency: _toCurrency,
                      amount: _convertedAmount,
                      isSource: false,
                      onCurrencyTap: () => _showCurrencySelector(false),
                    ),
                    
                    // Exchange Rate Info
                    const SizedBox(height: AppConstants.paddingXL),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Exchange Rate',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Updated just now',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 ${_fromCurrency.code} = ${_toCurrency.formatAmount(rate)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '1 ${_toCurrency.code} = ${_fromCurrency.formatAmount(inverseRate)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Fee Info
                    const SizedBox(height: AppConstants.paddingL),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppConstants.paddingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No Fee',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'You\'re exchanging at the real exchange rate',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
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
              ),
            ),
            
            // Bottom Action Button
            Container(
              padding: EdgeInsets.only(
                left: AppConstants.paddingL,
                right: AppConstants.paddingL,
                bottom: AppConstants.paddingL,
                top: AppConstants.paddingM,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'Exchange Now',
                onPressed: _isLoading ? null : _handleExchange,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCurrencyCard({
    required String title,
    required Currency currency,
    TextEditingController? controller,
    double? amount,
    required bool isSource,
    required VoidCallback onCurrencyTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              // Currency Selector
              GestureDetector(
                onTap: onCurrencyTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM,
                    vertical: AppConstants.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currency.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        currency.code,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              
              // Amount Input or Display
              Expanded(
                child: isSource
                    ? TextFormField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _calculateConversion();
                        },
                      )
                    : Text(
                        amount != null
                            ? amount.toStringAsFixed(2)
                            : '0.00',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance: ${currency.formatAmount(5000.00)}', // Mock balance
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (isSource)
                TextButton(
                  onPressed: () {
                    controller?.text = '5000.00';
                    _calculateConversion();
                  },
                  child: const Text('Use Max'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}