import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // Focus nodes for better UX
  final _nameFocusNode = FocusNode();
  final _cardNumberFocusNode = FocusNode();
  final _expiryFocusNode = FocusNode();
  final _cvvFocusNode = FocusNode();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _cardAnimationController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;

  // State variables
  bool isLoading = false;
  bool isCardValid = false;
  String detectedCardType = '';
  bool isCardNumberFocused = false;
  bool isExpiryFocused = false;
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListeners();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _cardScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  void _setupFocusListeners() {
    _cardNumberFocusNode.addListener(() {
      setState(() {
        isCardNumberFocused = _cardNumberFocusNode.hasFocus;
      });
      if (_cardNumberFocusNode.hasFocus) {
        _cardAnimationController.forward();
      }
    });

    _expiryFocusNode.addListener(() {
      setState(() {
        isExpiryFocused = _expiryFocusNode.hasFocus;
      });
    });

    _cvvFocusNode.addListener(() {
      setState(() {
        isCvvFocused = _cvvFocusNode.hasFocus;
      });
    });
  }

  String _detectCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.startsWith('4')) return 'visa';
    if (cleanNumber.startsWith('5')) return 'mastercard';
    if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37'))
      return 'amex';
    if (cleanNumber.startsWith('6')) return 'discover';

    return '';
  }

  String _formatCardNumber(String text) {
    final cleanText = text.replaceAll(RegExp(r'\D'), '');
    final chunks = <String>[];

    for (int i = 0; i < cleanText.length; i += 4) {
      final end = (i + 4 < cleanText.length) ? i + 4 : cleanText.length;
      chunks.add(cleanText.substring(i, end));
    }

    return chunks.join(' ');
  }

  String _formatExpiry(String text) {
    final cleanText = text.replaceAll(RegExp(r'\D'), '');
    if (cleanText.length >= 2) {
      return '${cleanText.substring(0, 2)}/${cleanText.substring(2)}';
    }
    return cleanText;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => isLoading = false);
        Navigator.pushNamed(context, '/step11');
      }
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _cardAnimationController.dispose();
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameFocusNode.dispose();
    _cardNumberFocusNode.dispose();
    _expiryFocusNode.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 32),
                    _buildCardPreview(theme, isDark),
                    const SizedBox(height: 32),
                    _buildFormFields(theme),
                    const SizedBox(height: 40),
                    _buildActionButtons(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.payment, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Step 3 of 4',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Secure Payment',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your card details to complete the payment',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCardPreview(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _cardScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardScaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.background.withOpacity(0.9),
                      ]
                    : [AppColors.primary, AppColors.background],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 32,
                      ),
                      if (detectedCardType.isNotEmpty)
                        _buildCardTypeIcon(detectedCardType),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _cardNumberController.text.isEmpty
                        ? '•••• •••• •••• ••••'
                        : _cardNumberController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CARD HOLDER',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nameController.text.isEmpty
                                ? 'YOUR NAME'
                                : _nameController.text.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _expiryController.text.isEmpty
                                ? 'MM/YY'
                                : _expiryController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardTypeIcon(String cardType) {
    IconData iconData;
    Color iconColor = Colors.white;

    switch (cardType) {
      case 'visa':
        iconData = Icons.credit_card;
        iconColor = const Color(0xFF1A1F71); // Visa blue
        break;
      case 'mastercard':
        iconData = Icons.credit_card;
        iconColor = const Color(0xFFEB001B); // Mastercard red
        break;
      case 'amex':
        iconData = Icons.credit_card;
        iconColor = const Color(0xFF006FCF); // Amex blue
        break;
      case 'discover':
        iconData = Icons.credit_card;
        iconColor = const Color(0xFFFF6000); // Discover orange
        break;
      default:
        iconData = Icons.credit_card;
        iconColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      children: [
        // Card Holder Name
        CustomInputField(
          label: 'Card Holder Name',
          hintText: 'Enter full name as on card',
          controller: _nameController,
          focusNode: _nameFocusNode,
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter card holder name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),

        const SizedBox(height: 20),

        // Card Number
        CustomInputField(
          label: 'Card Number',
          hintText: '1234 5678 9012 3456',
          controller: _cardNumberController,
          focusNode: _cardNumberFocusNode,
          prefixIcon: Icons.credit_card_outlined,
          inputType: TextInputType.number,
          maxLength: 19,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter card number';
            }
            final cleanNumber = value.replaceAll(RegExp(r'\D'), '');
            if (cleanNumber.length < 13 || cleanNumber.length > 19) {
              return 'Please enter a valid card number';
            }
            return null;
          },
          onChanged: (value) {
            final formatted = _formatCardNumber(value);
            if (formatted != value) {
              _cardNumberController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
            setState(() {
              detectedCardType = _detectCardType(value);
            });
          },
        ),

        const SizedBox(height: 20),

        // Expiry and CVV Row
        Row(
          children: [
            Expanded(
              child: CustomInputField(
                label: 'Expiry Date',
                hintText: 'MM/YY',
                controller: _expiryController,
                focusNode: _expiryFocusNode,
                prefixIcon: Icons.calendar_today_outlined,
                inputType: TextInputType.number,
                maxLength: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter expiry date';
                  }
                  final cleanValue = value.replaceAll(RegExp(r'\D'), '');
                  if (cleanValue.length != 4) {
                    return 'Please enter MM/YY';
                  }
                  final month = int.tryParse(cleanValue.substring(0, 2));
                  final year = int.tryParse(cleanValue.substring(2));
                  if (month == null || month < 1 || month > 12) {
                    return 'Invalid month';
                  }
                  if (year == null || year < 23) {
                    return 'Card expired';
                  }
                  return null;
                },
                onChanged: (value) {
                  final formatted = _formatExpiry(value);
                  if (formatted != value) {
                    _expiryController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CustomInputField(
                label: 'CVV',
                hintText: '123',
                controller: _cvvController,
                focusNode: _cvvFocusNode,
                prefixIcon: Icons.security_outlined,
                inputType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter CVV';
                  }
                  final cleanValue = value.replaceAll(RegExp(r'\D'), '');
                  if (cleanValue.length < 3 || cleanValue.length > 4) {
                    return 'Invalid CVV';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Security notice
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.1),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.security,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secure Payment',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your payment information is encrypted and secure',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        // Pay Now Button
        CustomButton(
          text: isLoading ? 'Processing...' : 'Pay Now',
          isLoading: isLoading,
          isFullWidth: true,
          onPressed: _submitForm,
        ),

        const SizedBox(height: 24),

        // Payment amount info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$99.99',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Navigation Buttons
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Back',
                type: CustomButtonType.outline,
                onPressed: _goBack,
                icon: Icons.arrow_back_ios,
                iconPosition: CustomButtonIconPosition.leading,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Continue',
                onPressed: _submitForm,
                icon: Icons.arrow_forward_ios,
                iconPosition: CustomButtonIconPosition.trailing,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
