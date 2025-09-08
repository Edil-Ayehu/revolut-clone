import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/models/currency_model.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({super.key});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  
  // Selected funding method
  String _selectedMethod = 'bank';
  
  // Mock user's currency
  final Currency _userCurrency = Currency.getCommonCurrencies()
      .firstWhere((c) => c.code == 'USD');
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  void _handleAddMoney() {
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
          _showAddMoneySuccessDialog();
        }
      });
    }
  }
  
  void _showAddMoneySuccessDialog() {
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
              'Money Added Successfully',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              'You have added ${_userCurrency.formatAmount(amount)} to your account',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money'),
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
                    // Amount Input Card
                    _buildAmountInputCard(context),
                    const SizedBox(height: AppConstants.paddingL),
                    
                    // Funding Methods
                    Text(
                      'Select Funding Method',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    
                    // Bank Transfer Method
                    _buildFundingMethodCard(
                      context,
                      'Bank Transfer',
                      'Free • Instant to 3 business days',
                      Icons.account_balance,
                      'bank',
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    
                    // Card Method
                    _buildFundingMethodCard(
                      context,
                      'Debit or Credit Card',
                      'Fee: 2.5% • Instant',
                      Icons.credit_card,
                      'card',
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    
                    // Apple Pay Method (for iOS)
                    _buildFundingMethodCard(
                      context,
                      'Apple Pay',
                      'Fee: 1.5% • Instant',
                      Icons.apple,
                      'apple_pay',
                    ),
                    
                    // Information Note
                    const SizedBox(height: AppConstants.paddingXL),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.cryptoColor,
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
                                  'Funds Availability',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Bank transfers may take up to 3 business days to process. Card and Apple Pay deposits are typically available immediately.',
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
                text: 'Add Money',
                onPressed: _isLoading ? null : _handleAddMoney,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAmountInputCard(BuildContext context) {
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
            'Amount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Currency Symbol
              Text(
                _userCurrency.symbol,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppConstants.paddingS),
              
              // Amount Input
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          
          // Quick Amount Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAmountButton('50'),
              _buildQuickAmountButton('100'),
              _buildQuickAmountButton('200'),
              _buildQuickAmountButton('500'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAmountButton(String amount) {
    return InkWell(
      onTap: () {
        setState(() {
          _amountController.text = amount;
        });
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.cryptoColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Text(
          '${_userCurrency.symbol}$amount',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildFundingMethodCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String methodId,
  ) {
    final isSelected = _selectedMethod == methodId;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = methodId;
        });
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cryptoColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: AppConstants.iconM,
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}