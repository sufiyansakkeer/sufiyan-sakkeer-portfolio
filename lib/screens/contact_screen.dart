import 'dart:developer' show log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/utils/helpers.dart';
import 'package:portfolio/widgets/social_bar.dart';
import 'package:portfolio/widgets/hover_effect.dart';
import 'package:portfolio/config/design_system.dart';
import 'package:portfolio/utils/animation_utilities.dart';
import 'package:portfolio/widgets/section_header.dart';
import 'package:portfolio/widgets/styled_card.dart';

// Import the global Firebase initialization status
import 'package:portfolio/main.dart' show isFirebaseInitialized;

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
    return SectionContainer(
      animationKey: 'contact-section',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with consistent styling
            SectionHeader(
              title: 'Contact Me',
              subtitle: 'Get in touch',
              animationKey: 'contact',
            ),

            const SizedBox(height: DesignSystem.spacingXl),

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
    return AnimationUtilities.createVisibilityTriggeredAnimation(
      animationKey: 'contact-item-$title',
      duration: DesignSystem.durationMedium,
      slideOffset: const Offset(0.1, 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: DesignSystem.spacingMd),
        child: StyledCard(
          padding: const EdgeInsets.all(DesignSystem.spacingMd),
          enableHover: true,
          onTap: onTap,
          useGlassEffect: true,
          glassOpacity: 0.5,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(51),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 28,
                ),
              ),

              const SizedBox(width: DesignSystem.spacingMd),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: DesignSystem.spacingXs),

                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16),
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

    return AnimationUtilities.createVisibilityTriggeredAnimation(
      animationKey: 'contact-form',
      duration: DesignSystem.durationMedium,
      delay: DesignSystem.delayMedium,
      slideOffset: const Offset(0, 0.1),
      child: StyledCard(
        padding: const EdgeInsets.all(DesignSystem.spacingLg),
        useGlassEffect: true,
        glassOpacity: 0.6,
        enableHover: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send me a message',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(
                height: DesignSystem.spacingLg,
              ), // Increased spacing
              // Name field - Modernized
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  // prefixIcon: Icon(Icons.person), // Optional: Keep or remove prefix icons
                  // border: UnderlineInputBorder(), // Use Underline border
                  filled: true, // Add a subtle fill color
                  fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(
                    13,
                  ), // 0.05 opacity (13/255)
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingMd,
                  ),
                  floatingLabelBehavior:
                      FloatingLabelBehavior.auto, // Or .never
                  border: OutlineInputBorder(
                    // Keep outline but customize
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide:
                        BorderSide.none, // Remove the default border line
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: DesignSystem.spacingMd,
              ), // Adjusted spacing
              // Email field - Modernized
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  // prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(
                    13,
                  ), // 0.05 opacity (13/255)
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingMd,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
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

              const SizedBox(
                height: DesignSystem.spacingMd,
              ), // Adjusted spacing
              // Subject field - Modernized
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  // prefixIcon: Icon(Icons.subject),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(
                    13,
                  ), // 0.05 opacity (13/255)
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingMd,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: DesignSystem.spacingMd,
              ), // Adjusted spacing
              // Message field - Modernized
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  // prefixIcon: Icon(Icons.message), // Aligning prefix icon can be tricky with multiline
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(
                    13,
                  ), // 0.05 opacity (13/255)
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: DesignSystem.spacingSm,
                    horizontal: DesignSystem.spacingMd,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  alignLabelWithHint: true, // Good for multiline
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMd),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
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
                  padding: const EdgeInsets.only(
                    top: DesignSystem.spacingMd,
                  ), // Adjusted padding
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.fontSize, // Smaller error text
                    ),
                  ),
                ),

              const SizedBox(
                height: DesignSystem.spacingLg,
              ), // Increased spacing before button
              // Submit button - Enhanced
              SizedBox(
                width: double.infinity,
                child: HoverButton(
                  // Assuming HoverButton handles hover effects well
                  onPressed: _isSubmitting ? () {} : () => _submitForm(),
                  padding: const EdgeInsets.symmetric(
                    // Slightly larger padding
                    vertical:
                        DesignSystem.spacingMd, // Increased vertical padding
                    horizontal: DesignSystem.spacingLg,
                  ),
                  elevation: DesignSystem.elevationXs, // Subtle base elevation
                  hoverElevation:
                      DesignSystem.elevationSm, // Clearer hover elevation
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusMd,
                  ), // Consistent border radius
                  // Optional: Add gradient or specific background color
                  // backgroundColor: Theme.of(context).colorScheme.primary,
                  // hoverBackgroundColor: Theme.of(context).colorScheme.primaryVariant,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isSubmitting)
                        Container(
                          width: 20, // Slightly smaller indicator
                          height: 20,
                          margin: const EdgeInsets.only(
                            right: DesignSystem.spacingSm,
                          ), // Adjusted margin
                          child: CircularProgressIndicator(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimary, // Use theme color
                            strokeWidth: 2.5,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(
                            right: DesignSystem.spacingSm,
                          ), // Adjusted padding
                          child: Icon(
                            Icons.send,
                            size: 20, // Consistent icon size
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimary, // Use theme color
                          ),
                        ),
                      Text(
                        _isSubmitting ? 'Sending...' : 'Send Message',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          // Use labelLarge style
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onPrimary, // Use theme color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    return AnimationUtilities.createVisibilityTriggeredAnimation(
      animationKey: 'contact-success',
      duration: DesignSystem.durationMedium,
      child: StyledCard(
        padding: const EdgeInsets.all(DesignSystem.spacingLg),
        useGlassEffect: true,
        glassOpacity: 0.7,
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
        // Check if Firebase is initialized before using Firestore
        if (!isFirebaseInitialized) {
          // Try to initialize Firebase if it's not already initialized
          try {
            await Firebase.initializeApp();
            if (kDebugMode) {
              log('Firebase initialized in contact form submission');
            }
          } catch (firebaseError) {
            if (kDebugMode) {
              log('Failed to initialize Firebase: $firebaseError');
            }
            throw Exception('Firebase is not initialized');
          }
        }

        // Get a reference to the Firestore collection
        CollectionReference contacts = FirebaseFirestore.instance.collection(
          'contacts',
        );

        // Add a new document to the collection
        var result = await contacts.add({
          'name': _nameController.text,
          'email': _emailController.text,
          'subject': _subjectController.text,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (kDebugMode) {
          log('Message sent successfully: ${result.id}');
        }

        setState(() {
          _isSubmitting = false;
          _formSubmitted = true;
        });

        // Show success snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent successfully!')),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          log('Error sending message: $e');
        }
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'Failed to send message. Please try again later.';
        });
      }
    }
  }
}
