class Experience {
  final String title;
  final String organization;
  final String period;
  final String description;
  final String? logoUrl;
  final ExperienceType type;

  Experience({
    required this.title,
    required this.organization,
    required this.period,
    required this.description,
    this.logoUrl,
    required this.type,
  });
}

enum ExperienceType { work, education, volunteer, publication }

// Sample experiences data
List<Experience> sampleExperiences = [
  // Work Experience
  Experience(
    title: 'Flutter Developer',
    organization: 'avua International Pvt. Ltd.',
    period: 'July 2023 - Present',
    description:
        'Led the design and development of scalable and reliable cross-platform mobile applications using Flutter. Effectively collaborated with the back-end team to streamline integration, ensuring the successful delivery of two top-notch applications. Spearheaded the creation of a robust architecture, resulting in a 35% improvement in application performance. Reduced time-to-market by 30% through efficient development practices and streamlined processes.',
    logoUrl: 'assets/images/avua.png',
    type: ExperienceType.work,
  ),

  // Education
  Experience(
    title: 'Flutter Developer Internship',
    organization: 'Brototype',
    period: 'October 2022 - July 2023',
    description:
        'Intensive training program focused on Flutter development. Worked on real-world projects and gained hands-on experience with Flutter framework, state management solutions, and backend integration.',
    logoUrl: 'assets/images/brototype.png',
    type: ExperienceType.education,
  ),
  Experience(
    title: 'Bachelor of Computer Application',
    organization: 'BGS & SJB Group of Institution',
    period: '2019 - 2022',
    description:
        'Completed Bachelor\'s degree in Computer Application with focus on programming fundamentals, data structures, and software development.',
    logoUrl: 'assets/images/bgs.png',
    type: ExperienceType.education,
  ),

  // Publications
  Experience(
    title:
        'Architecting Brilliance: Unveiling the Power of SOLID Principles in Software Development',
    organization: 'LinkedIn Article',
    period: '2024',
    description:
        'Published an article discussing the importance and implementation of SOLID principles in software development, with a focus on Flutter applications.',
    logoUrl: 'assets/images/linkedin.png',
    type: ExperienceType.publication,
  ),
];
