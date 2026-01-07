class Experience {
  final String title;
  final String organization;
  final String period;
  final String description;
  final String? logoUrl;
  final ExperienceType type;
  final bool isNetworkImage;

  Experience({
    required this.title,
    required this.organization,
    required this.period,
    required this.description,
    this.logoUrl,
    required this.type,
    this.isNetworkImage = false,
  });
}

enum ExperienceType { work, education, volunteer, publication }

// Sample experiences data
List<Experience> sampleExperiences = [
  // Work Experience
  Experience(
    title: 'Flutter Developer',
    organization: 'Middle East College',
    period: 'June 2025 - Present',
    description:
        '• Developing scalable Flutter applications tailored to educational and institutional requirements.\n'
        '• Designing and consuming RESTful APIs using ASP.NET Core (.NET) for mobile applications.\n'
        '• Implemented authentication and authorization using JWT in .NET backend services.\n'
        '• Worked with Entity Framework Core for data access, migrations, and database optimization.\n'
        '• Collaborated on backend architecture following Clean Architecture and MVC principles.\n'
        '• Maintaining clean code architecture and applying modern Flutter and .NET best practices.',
    logoUrl:
        'https://media.licdn.com/dms/image/C4D0BAQGfBCXZ_Kw_Ug/company-logo_200_200/0/1677566365962?e=1720051200&v=beta&t=Yd-Ij-Oe-Yd-Ij-Oe-Yd-Ij-Oe',
    type: ExperienceType.work,
    isNetworkImage: true,
  ),
  Experience(
    title: 'Flutter Developer',
    organization: 'avua International Pvt. Ltd.',
    period: 'July 2023 - May 2025',
    description:
        'avua is an AI-based recruitment platform with 100k+ active users.\n'
        '• Led the design and development of two cross-platform applications using Flutter.\n'
        '• Collaborated with backend engineers for seamless integration of REST APIs.\n'
        '• Spearheaded architecture improvements, achieving a 35% boost in performance.\n'
        '• Reduced time-to-market by 30% through optimized development practices.\n'
        '• Delivered features such as real-time chat, push notifications, and deep linking.',
    logoUrl:
        'https://media.licdn.com/dms/image/C4D0BAQGfBCXZ_Kw_Ug/company-logo_200_200/0/1677566365962?e=1720051200&v=beta&t=Yd-Ij-Oe-Yd-Ij-Oe-Yd-Ij-Oe',
    type: ExperienceType.work,
    isNetworkImage: true,
  ),

  // Education
  Experience(
    title: 'Flutter Developer Internship',
    organization: 'Brototype',
    period: 'October 2022 - July 2023',
    description:
        'Intensive training program focused on Flutter development. Worked on real-world projects and gained hands-on experience with Flutter framework, state management solutions, and backend integration.',
    logoUrl:
        'https://media.licdn.com/dms/image/C560BAQFAVLoL6j71Kg/company-logo_200_200/0/1657630844148?e=1720051200&v=beta&t=KSh-LGxaFTyZVJF8Z7KZ8YZJJgH8Z7KZ8YZJJgH8',
    type: ExperienceType.education,
    isNetworkImage: true,
  ),
  Experience(
    title: 'Bachelor of Computer Application',
    organization: 'BGS & SJB Group of Institution',
    period: '2019 - 2022',
    description:
        'Completed Bachelor\'s degree in Computer Application with focus on programming fundamentals, data structures, and software development.',
    logoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKUJjQlhHhUXR-v7QlLv_RuO9MeVEGRn74Uw&usqp=CAU',
    type: ExperienceType.education,
    isNetworkImage: true,
  ),

  // Publications
  Experience(
    title:
        'Architecting Brilliance: Unveiling the Power of SOLID Principles in Software Development',
    organization: 'LinkedIn Article',
    period: '2024',
    description:
        'Published an article discussing the importance and implementation of SOLID principles in software development, with a focus on Flutter applications.',
    logoUrl: 'https://cdn-icons-png.flaticon.com/512/174/174857.png',
    type: ExperienceType.publication,
    isNetworkImage: true,
  ),
];
