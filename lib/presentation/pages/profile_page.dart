import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_profile.dart' as models;
import '../providers/image_provider.dart';
import '../widgets/main_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCategory = ApiConstants.categories.first;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppConstants.profileRoute,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        ResponsiveHelper.responsive<double>(
          context: context,
          mobile: AppConstants.spacingM,
          tablet: AppConstants.spacingXL,
          desktop: AppConstants.spacingXXL,
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.responsive<double>(
              context: context,
              mobile: double.infinity,
              tablet: 700,
              desktop: 800,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.responsive<double>(
                    context: context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                'Complete your profile information',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXXL),

              // Profile form will be implemented in next steps
              _buildProfileForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile avatar
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      child: provider.formState.profile.fullName.isNotEmpty
                          ? Text(
                              provider.formState.profile.initials,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXL),

                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.fullName,
                    onChanged: (value) => _updateProfile(),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.email,
                    onChanged: (value) => _updateProfile(),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Favorite Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Favorite Category',
                      prefixIcon: Icon(Icons.category_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: ApiConstants.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category == 'all'
                              ? 'All Categories'
                              : _capitalizeFirst(category),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        _updateProfile();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a favorite category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter a secure password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: Validators.password,
                    onChanged: (value) => _updateProfile(),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    onChanged: (value) => _updateProfile(),
                  ),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Submit Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: provider.isLoading ? null : _submitForm,
                      icon: provider.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        provider.isLoading ? 'Submitting...' : 'Save Profile',
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.buttonBorderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Success/Error Messages
                  if (provider.hasError) ...[
                    const SizedBox(height: AppConstants.spacingL),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingM),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.buttonBorderRadius,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Expanded(
                            child: Text(
                              provider.formState.errorMessage ??
                                  'An error occurred',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => provider.clearError(),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (provider.isSuccess) ...[
                    const SizedBox(height: AppConstants.spacingL),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingM),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(
                          AppConstants.buttonBorderRadius,
                        ),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppConstants.profileSavedMessage,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (provider.formState.response != null) ...[
                                  const SizedBox(
                                    height: AppConstants.spacingXS,
                                  ),
                                  Text(
                                    'Response ID: ${provider.formState.response!.id}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.green.shade600,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateProfile() {
    final profile = models.UserProfile(
      fullName: _fullNameController.text,
      email: _emailController.text,
      favoriteCategory: _selectedCategory,
      password: _passwordController.text,
    );

    context.read<ProfileProvider>().updateProfile(profile);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = models.UserProfile(
        fullName: _fullNameController.text,
        email: _emailController.text,
        favoriteCategory: _selectedCategory,
        password: _passwordController.text,
      );

      context.read<ProfileProvider>().submitProfile(profile);
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
