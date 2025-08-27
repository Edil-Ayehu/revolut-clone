import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/models/contact.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _recipientController = TextEditingController();
  
  Contact? _selectedContact;
  bool _isLoading = false;
  String _selectedMethod = 'instant';

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _handleSendMoney() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedContact == null && _recipientController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a recipient'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to confirmation
        context.push(AppRoutes.paymentConfirmation, extra: {
          'amount': double.parse(_amountController.text),
          'recipient': _selectedContact?.name ?? _recipientController.text,
          'note': _noteController.text,
          'method': _selectedMethod,
        });
      }
    }
  }

  void _selectContact() async {
    final contact = await showModalBottomSheet<Contact>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildContactSelector(),
    );
    
    if (contact != null) {
      setState(() {
        _selectedContact = contact;
        _recipientController.text = contact.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Input
                      Text(
                        'Amount',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      
                      Container(
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
                            Row(
                              children: [
                                Text(
                                  AppConstants.currencySymbol,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _amountController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                                      if (amount > 10000) {
                                        return 'Amount cannot exceed \$10,000';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingS),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available: \$12,345.67',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _amountController.text = '12345.67';
                                  },
                                  child: const Text('Use Max'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingXL),
                      
                      // Recipient
                      Text(
                        'Send to',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      
                      CustomTextField(
                        controller: _recipientController,
                        hint: 'Enter name, email, or phone number',
                        prefixIcon: Icons.person,
                        suffixIcon: Icons.contacts,
                        onSuffixIconPressed: _selectContact,
                        validator: (value) {
                          if (_selectedContact == null && (value == null || value.isEmpty)) {
                            return 'Please select a recipient';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      
                      // Transfer Method
                      Text(
                        'Transfer Method',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingM),
                      
                      _buildTransferMethodSelector(),
                      const SizedBox(height: AppConstants.paddingL),
                      
                      // Note
                      CustomTextField(
                        controller: _noteController,
                        label: 'Note (Optional)',
                        hint: 'What\'s this for?',
                        maxLines: 3,
                        prefixIcon: Icons.note,
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      
                      // Fee Information
                      Container(
                        padding: const EdgeInsets.all(AppConstants.paddingM),
                        decoration: BoxDecoration(
                          color: AppColors.neutral50,
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: AppConstants.iconM,
                            ),
                            const SizedBox(width: AppConstants.paddingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transfer Fee',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _selectedMethod == 'instant' ? 'Free' : 'Free',
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
              
              // Send Button
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                child: CustomButton(
                  text: 'Send Money',
                  onPressed: _isLoading ? null : _handleSendMoney,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferMethodSelector() {
    return Column(
      children: [
        _buildMethodOption(
          'instant',
          'Instant Transfer',
          'Arrives in seconds',
          Icons.flash_on,
          AppColors.primary,
        ),
        const SizedBox(height: AppConstants.paddingS),
        _buildMethodOption(
          'standard',
          'Standard Transfer',
          'Arrives in 1-2 business days',
          Icons.schedule,
          AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildMethodOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected ? color : AppColors.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
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
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.textPrimary,
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
              Icon(
                Icons.check_circle,
                color: color,
                size: AppConstants.iconM,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSelector() {
    final contacts = _getMockContacts();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Contact',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      contact.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.email ?? contact.phone ?? ''),
                  onTap: () => Navigator.of(context).pop(contact),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Contact> _getMockContacts() {
    return [
      Contact(id: '1', name: 'Alice Johnson', email: 'alice@example.com'),
      Contact(id: '2', name: 'Bob Smith', phone: '+1234567890'),
      Contact(id: '3', name: 'Charlie Brown', email: 'charlie@example.com'),
      Contact(id: '4', name: 'Diana Prince', phone: '+0987654321'),
    ];
  }
}
