import 'package:flutter/material.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/social_bar.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/config/design_system.dart';
// These imports are used in the commented-out code for the real API implementation
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;
  bool _formSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: DesignSystem.getSectionPadding(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Center(
              child: Text(
                'Contact Me',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            SizedBox(height: DesignSystem.spacingSm),

            // Section subtitle
            Center(
              child: Text(
                'Get in touch',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            SizedBox(height: DesignSystem.spacingXl),

            // Contact content
            Helpers.isMobile(context)
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact info
        Expanded(flex: 4, child: _buildContactInfo(context)),

        SizedBox(width: DesignSystem.spacingXl),

        // Contact form
        Expanded(flex: 6, child: _buildContactForm(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact info
        _buildContactInfo(context),

        SizedBox(height: DesignSystem.spacingXl),

        // Contact form
        _buildContactForm(context),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s discuss Flutter opportunities',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: DesignSystem.spacingSm),

        Text(
          'I\'m open to Flutter development opportunities where I can contribute, learn and grow. If you have a project that matches my skills and experience, feel free to contact me.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: DesignSystem.spacingMd),

        // Contact items
        _buildContactItem(
          context,
          Icons.email,
          'Email',
          AppConstants.email,
          () => Helpers.sendEmail(AppConstants.email),
        ),

        _buildContactItem(
          context,
          Icons.phone,
          'Phone',
          AppConstants.phone,
          () => Helpers.launchURL('tel:${AppConstants.phone}'),
        ),

        _buildContactItem(
          context,
          Icons.location_on,
          'Location',
          AppConstants.location,
          () {},
        ),

        const SizedBox(height: DesignSystem.spacingLg),

        // Social media
        Text(
          'Connect with me',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: DesignSystem.spacingSm),

        const SocialBar(),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String content,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        hoverColor: Theme.of(context).colorScheme.primary.withAlpha(10),
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingXs),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(10),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),

              const SizedBox(width: DesignSystem.spacingSm),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacingXxs),

                  Text(content, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    if (_formSubmitted) {
      return _buildSuccessMessage(context);
    }

    return Card(
      elevation: DesignSystem.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send me a message',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: DesignSystem.spacingMd),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: DesignSystem.spacingSm),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: DesignSystem.spacingSm),

              // Subject field
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),

              const SizedBox(height: DesignSystem.spacingSm),

              // Message field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              const SizedBox(height: DesignSystem.spacingMd),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: HoverButton(
                  onPressed: _isSubmitting ? () {} : () => _submitForm(),
                  padding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingMd,
                  ),
                  elevation: DesignSystem.elevationSm,
                  hoverElevation: DesignSystem.elevationMd,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isSubmitting)
                        Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          margin: const EdgeInsets.only(
                            right: DesignSystem.spacingXs,
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(
                            right: DesignSystem.spacingXs,
                          ),
                          child: Icon(Icons.send),
                        ),
                      Text(_isSubmitting ? 'Sending...' : 'Send Message'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Card(
      elevation: DesignSystem.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),

            const SizedBox(height: DesignSystem.spacingMd),

            Text(
              'Message Sent!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: DesignSystem.spacingSm),

            Text(
              'Thank you for reaching out. I\'ll get back to you as soon as possible.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: DesignSystem.spacingMd),

            HoverButton(
              onPressed: () {
                setState(() {
                  _formSubmitted = false;
                  _nameController.clear();
                  _emailController.clear();
                  _subjectController.clear();
                  _messageController.clear();
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: DesignSystem.spacingXs),
                  const Text('Send Another Message'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // For a real implementation, you would use something like:
        /*
        final response = await http.post(
          Uri.parse(AppConstants.contactFormEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _nameController.text,
            'email': _emailController.text,
            'subject': _subjectController.text,
            'message': _messageController.text,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to send message');
        }
        */

        setState(() {
          _isSubmitting = false;
          _formSubmitted = true;
        });
      } catch (e) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to send message. Please try again later.';
        });
      }
    }
  }
}
