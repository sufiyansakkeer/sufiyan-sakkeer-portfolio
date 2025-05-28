class Skill {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final String iconPath;
  final SkillCategory category;
  final bool isNetworkImage;

  Skill({
    required this.name,
    required this.proficiency,
    required this.iconPath,
    required this.category,
    this.isNetworkImage = false,
  });
}

enum SkillCategory { language, framework, database, tool, other }

// Sample skills data
List<Skill> sampleSkills = [
  // Programming Languages
  Skill(
    name: 'Dart',
    proficiency: 0.9,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg',
    category: SkillCategory.language,
    isNetworkImage: true,
  ),
  Skill(
    name: 'JavaScript',
    proficiency: 0.75,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg',
    category: SkillCategory.language,
    isNetworkImage: true,
  ),
  Skill(
    name: 'HTML',
    proficiency: 0.8,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg',
    category: SkillCategory.language,
    isNetworkImage: true,
  ),
  Skill(
    name: 'CSS',
    proficiency: 0.75,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg',
    category: SkillCategory.language,
    isNetworkImage: true,
  ),

  // Frameworks & Libraries
  Skill(
    name: 'Flutter',
    proficiency: 0.95,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg',
    category: SkillCategory.framework,
    isNetworkImage: true,
  ),
  Skill(
    name: 'BLoC',
    proficiency: 0.9,
    iconPath:
        'https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/bloc_logo_full.png',
    category: SkillCategory.framework,
    isNetworkImage: true,
  ),
  Skill(
    name: 'Provider',
    proficiency: 0.85,
    iconPath:
        'https://pub.dev/packages/provider/versions/6.1.2/gen-res/gen/190x190/logo.webp',
    category: SkillCategory.framework,
    isNetworkImage: true,
  ),
  Skill(
    name: 'GetX',
    proficiency: 0.8,
    iconPath:
        'https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png',
    category: SkillCategory.framework,
    isNetworkImage: true,
  ),

  // Databases & Cloud
  Skill(
    name: 'Firebase',
    proficiency: 0.85,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg',
    category: SkillCategory.database,
    isNetworkImage: true,
  ),
  Skill(
    name: 'Hive',
    proficiency: 0.8,
    iconPath:
        'https://raw.githubusercontent.com/hivedb/hive/master/.github/logo_transparent.svg',
    category: SkillCategory.database,
    isNetworkImage: true,
  ),
  Skill(
    name: 'Sqflite',
    proficiency: 0.75,
    iconPath:
        'https://raw.githubusercontent.com/tekartik/sqflite/master/sqflite/doc/logo.png',
    category: SkillCategory.database,
    isNetworkImage: true,
  ),

  // Tools & Technologies
  Skill(
    name: 'Git & GitHub',
    proficiency: 0.9,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg',
    category: SkillCategory.tool,
    isNetworkImage: true,
  ),
  Skill(
    name: 'REST API',
    proficiency: 0.85,
    iconPath: 'https://cdn-icons-png.flaticon.com/512/2721/2721620.png',
    category: SkillCategory.tool,
    isNetworkImage: true,
  ),
  Skill(
    name: 'WebSocket',
    proficiency: 0.8,
    iconPath: 'https://cdn-icons-png.flaticon.com/512/5768/5768210.png',
    category: SkillCategory.tool,
    isNetworkImage: true,
  ),
  Skill(
    name: 'Jira',
    proficiency: 0.75,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jira/jira-original.svg',
    category: SkillCategory.tool,
    isNetworkImage: true,
  ),
  Skill(
    name: 'Figma',
    proficiency: 0.7,
    iconPath:
        'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg',
    category: SkillCategory.tool,
    isNetworkImage: true,
  ),

  // Other Skills
  Skill(
    name: 'Data Structures',
    proficiency: 0.8,
    iconPath: 'https://cdn-icons-png.flaticon.com/512/2103/2103658.png',
    category: SkillCategory.other,
    isNetworkImage: true,
  ),
  Skill(
    name: 'OOP',
    proficiency: 0.85,
    iconPath: 'https://cdn-icons-png.flaticon.com/512/2166/2166823.png',
    category: SkillCategory.other,
    isNetworkImage: true,
  ),
];
