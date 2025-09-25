import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/core/utils/validators.dart';

void main() {
  group('Form Validation Widget Tests', () {
    // Helper to create testable widget
    Widget createTestWidget(Widget child) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('Profile Form Validation', () {
      testWidgets('should validate email field correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        final emailController = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('email_field'),
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                    ),
                    validator: Validators.email,
                  ),
                  ElevatedButton(
                    onPressed: () => formKey.currentState?.validate(),
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Test invalid email
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'invalid-email',
        );
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(find.text('Please enter a valid email address'), findsOneWidget);

        // Test valid email
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(find.text('Please enter a valid email address'), findsNothing);
      });

      testWidgets('should validate password field correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        final passwordController = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('password_field'),
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter password',
                    ),
                    validator: Validators.password,
                  ),
                  ElevatedButton(
                    onPressed: () => formKey.currentState?.validate(),
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Test short password
        await tester.enterText(find.byKey(const Key('password_field')), '123');
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(
          find.text('Password must be at least 8 characters long'),
          findsOneWidget,
        );

        // Test valid password
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'Password123!',
        );
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(
          find.text('Password must be at least 8 characters long'),
          findsNothing,
        );
      });

      testWidgets('should validate full name field correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('name_field'),
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    validator: Validators.fullName,
                  ),
                  ElevatedButton(
                    onPressed: () => formKey.currentState?.validate(),
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Test single name
        await tester.enterText(find.byKey(const Key('name_field')), 'John');
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(
          find.text('Please enter both first and last name'),
          findsOneWidget,
        );

        // Test valid full name
        await tester.enterText(find.byKey(const Key('name_field')), 'John Doe');
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(
          find.text('Please enter both first and last name'),
          findsNothing,
        );
      });

      testWidgets('should validate confirm password correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        final passwordController = TextEditingController();
        final confirmController = TextEditingController();

        await tester.pumpWidget(
          createTestWidget(
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('password_field'),
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: Validators.password,
                  ),
                  TextFormField(
                    key: const Key('confirm_field'),
                    controller: confirmController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      passwordController.text,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => formKey.currentState?.validate(),
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Set passwords
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.enterText(
          find.byKey(const Key('confirm_field')),
          'different123',
        );

        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);

        // Test matching passwords
        await tester.enterText(
          find.byKey(const Key('confirm_field')),
          'password123',
        );
        await tester.tap(find.text('Validate'));
        await tester.pump();

        expect(find.text('Passwords do not match'), findsNothing);
      });
    });

    group('Password Visibility Widget', () {
      testWidgets('should toggle password visibility', (
        WidgetTester tester,
      ) async {
        bool obscurePassword = true;

        await tester.pumpWidget(
          createTestWidget(
            StatefulBuilder(
              builder: (context, setState) {
                return TextFormField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // Initially should show visibility_off icon (password hidden)
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);

        // Tap the visibility toggle
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        // Should now show visibility icon (password visible)
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);

        // Tap again to hide
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        // Should be back to hidden state
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);
      });
    });

    group('Form Layout Widget', () {
      testWidgets('should show form structure correctly', (
        WidgetTester tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          createTestWidget(
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Should show all form elements
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Save Profile'), findsOneWidget);

        // Should show proper icons
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);

        // Should have proper form structure
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Responsive Form Layout', () {
      testWidgets('should adapt form layout to different screen sizes', (
        WidgetTester tester,
      ) async {
        // Test mobile layout
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: createTestWidget(
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);

        // Test desktop layout
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: createTestWidget(
              Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });
  });
}
