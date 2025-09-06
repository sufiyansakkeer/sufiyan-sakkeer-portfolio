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
        'Developing scalable Flutter applications tailored to educational and institutional requirements. Maintaining clean code architecture and applying modern Flutter best practices.',
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
        'Led the design and development of scalable and reliable cross-platform mobile applications using Flutter. Effectively collaborated with the back-end team to streamline integration, ensuring the successful delivery of two top-notch applications. Spearheaded the creation of a robust architecture, resulting in a 35% improvement in application performance. Reduced time-to-market by 30% through efficient development practices and streamlined processes.',
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
