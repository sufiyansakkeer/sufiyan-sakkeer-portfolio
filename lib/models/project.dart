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
    imageUrl: 'assets/images/avua_applicant.jpg',
    liveUrl: 'https://apps.apple.com/in/app/avua/id6469672021',
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
    imageUrl: 'assets/images/avua_recruiter.jpg',
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
    imageUrl: 'assets/images/money_track.jpg',
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
        'BSocial is a cutting-edge social media app built with Flutter and Provider state management. Its sleek design ensures a seamless user experience. Features include news feeds, messaging, and profile customization.',
    imageUrl: 'assets/images/bsocial.jpg',
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
