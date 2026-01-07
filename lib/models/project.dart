class Project {
  final String title;
  final String description;
  final String imageUrl;
  final String? liveUrl;
  final String? githubUrl;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.liveUrl,
    this.githubUrl,
    required this.technologies,
  });
}

// Sample projects data
List<Project> sampleProjects = [
  Project(
    title: 'avua - Applicant App',
    description:
        'Enables direct connection between applicants and recruiters, allowing the creation of AI-friendly profiles. Features include customizable resume templates, video resumes, and AI-generated scoring for an enhanced job application experience.',
    imageUrl:
        'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=1974&auto=format&fit=crop',
    liveUrl: 'https://play.google.com/store/apps/details?id=com.app.avua',
    githubUrl: null,
    technologies: [
      'Flutter',
      'BLoC',
      'REST API',
      'FCM',
      'OAuth',
      'Deep Linking',
      'WebSocket',
    ],
  ),
  Project(
    title: 'avua Recruiter',
    description:
        'Connects recruiters with applicants, enabling job postings and providing AI-based results. Key features include job management in the job space and \'avua Pool\' for finding applicants by name, keywords, skills and job titles.',
    imageUrl:
        'https://images.unsplash.com/photo-1573164713988-8665fc963095?q=80&w=2069&auto=format&fit=crop',
    liveUrl: 'https://apps.apple.com/in/app/avua-recruiter/id6474672130',
    githubUrl: null,
    technologies: [
      'Flutter',
      'BLoC',
      'REST API',
      'OAuth',
      'Deep-Linking',
      'WebSocket',
      'Flavors',
    ],
  ),
  Project(
    title: 'Money Track',
    description:
        'A feature-rich personal finance management application developed using Flutter, designed to help users efficiently track their income and expenses, manage budgets, and visualize financial data.',
    imageUrl:
        'https://images.unsplash.com/photo-1579621970588-a35d0e7ab9b6?q=80&w=2070&auto=format&fit=crop',
    liveUrl: null,
    githubUrl: 'https://github.com/sufiyansakkeer/Money-Tracker/',
    technologies: [
      'Flutter',
      'BLoC/Cubit',
      'Hive',
      'Syncfusion Charts',
      'Rive',
      'Lottie',
    ],
  ),
  Project(
    title: 'BSocial',
    description:
        'Feature-rich app with feeds, chat, profile customization, and follow system. Integrated Firebase Authentication, Crashlytics, and push notifications.',
    imageUrl:
        'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?q=80&w=1974&auto=format&fit=crop',
    liveUrl: null,
    githubUrl: 'https://github.com/sufiyansakkeer/BSocial',
    technologies: [
      'Flutter',
      'Provider',
      'Firebase Auth',
      'Crashlytics',
      'Push Notifications',
    ],
  ),
];
