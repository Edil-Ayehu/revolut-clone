import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/custom_button.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  bool _isLoading = false;
  bool _isConfirmStep = false;
  String _firstPin = '';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onPinChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _handlePinComplete();
      }
    }
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _currentPin {
    return _controllers.map((controller) => controller.text).join();
  }

  void _handlePinComplete() {
    if (_currentPin.length == 4) {
      if (!_isConfirmStep) {
        // First PIN entry
        setState(() {
          _firstPin = _currentPin;
          _isConfirmStep = true;
        });
        _clearPin();
        _focusNodes[0].requestFocus();
      } else {
        // Confirm PIN
        if (_currentPin == _firstPin) {
          _setupPin();
        } else {
          _showError('PINs do not match. Please try again.');
          _resetToFirstStep();
        }
      }
    }
  }

  void _clearPin() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  void _resetToFirstStep() {
    setState(() {
      _isConfirmStep = false;
      _firstPin = '';
    });
    _clearPin();
    _focusNodes[0].requestFocus();
  }

  void _setupPin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home
      context.go(AppRoutes.home);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isConfirmStep) {
              _resetToFirstStep();
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingXL),
              
              // Header
              Text(
                _isConfirmStep ? 'Confirm your PIN' : 'Create a PIN',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingS),
              Text(
                _isConfirmStep 
                    ? 'Please enter your PIN again to confirm'
                    : 'Create a 4-digit PIN to secure your account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingXL * 2),
              
              // PIN Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 70,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      obscureText: true,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          borderSide: const BorderSide(color: AppColors.neutral200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onPinChanged(value, index),
                      onTap: () {
                        _controllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppConstants.paddingXL),
              
              // Progress Indicator
              if (_isConfirmStep)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Container(
                          width: 20,
                          height: 2,
                          color: AppColors.neutral200,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPin.length == 4 ? AppColors.success : AppColors.neutral200,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    Text(
                      'Step 2 of 2',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              
              const Spacer(),
              
              // Continue Button (only show when PIN is complete)
              if (_currentPin.length == 4 && !_isLoading)
                CustomButton(
                  text: _isConfirmStep ? 'Complete Setup' : 'Continue',
                  onPressed: _handlePinComplete,
                ),
              
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              
              const SizedBox(height: AppConstants.paddingL),
              
              // Security Info
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppColors.primary,
                      size: AppConstants.iconM,
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: Text(
                        'Your PIN is encrypted and stored securely',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}
