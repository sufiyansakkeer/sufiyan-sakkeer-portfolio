class Skill {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final String iconPath;
  final SkillCategory category;

  Skill({
    required this.name,
    required this.proficiency,
    required this.iconPath,
    required this.category,
  });
}

enum SkillCategory { language, framework, database, tool, other }

// Sample skills data
List<Skill> sampleSkills = [
  // Programming Languages
  Skill(
    name: 'Dart',
    proficiency: 0.9,
    iconPath: 'assets/icons/dart.svg',
    category: SkillCategory.language,
  ),
  Skill(
    name: 'JavaScript',
    proficiency: 0.75,
    iconPath: 'assets/icons/javascript.svg',
    category: SkillCategory.language,
  ),
  Skill(
    name: 'HTML',
    proficiency: 0.8,
    iconPath: 'assets/icons/html.svg',
    category: SkillCategory.language,
  ),
  Skill(
    name: 'CSS',
    proficiency: 0.75,
    iconPath: 'assets/icons/css.svg',
    category: SkillCategory.language,
  ),

  // Frameworks & Libraries
  Skill(
    name: 'Flutter',
    proficiency: 0.95,
    iconPath: 'assets/icons/flutter.svg',
    category: SkillCategory.framework,
  ),
  Skill(
    name: 'BLoC',
    proficiency: 0.9,
    iconPath: 'assets/icons/bloc.svg',
    category: SkillCategory.framework,
  ),
  Skill(
    name: 'Provider',
    proficiency: 0.85,
    iconPath: 'assets/icons/provider.svg',
    category: SkillCategory.framework,
  ),
  Skill(
    name: 'GetX',
    proficiency: 0.8,
    iconPath: 'assets/icons/getx.svg',
    category: SkillCategory.framework,
  ),

  // Databases & Cloud
  Skill(
    name: 'Firebase',
    proficiency: 0.85,
    iconPath: 'assets/icons/firebase.svg',
    category: SkillCategory.database,
  ),
  Skill(
    name: 'Hive',
    proficiency: 0.8,
    iconPath: 'assets/icons/hive.svg',
    category: SkillCategory.database,
  ),

  // Tools & Technologies
  Skill(
    name: 'Git & GitHub',
    proficiency: 0.9,
    iconPath: 'assets/icons/git.svg',
    category: SkillCategory.tool,
  ),
  Skill(
    name: 'REST API',
    proficiency: 0.85,
    iconPath: 'assets/icons/api.svg',
    category: SkillCategory.tool,
  ),
  Skill(
    name: 'WebSocket',
    proficiency: 0.8,
    iconPath: 'assets/icons/websocket.svg',
    category: SkillCategory.tool,
  ),
  Skill(
    name: 'Jira',
    proficiency: 0.75,
    iconPath: 'assets/icons/jira.svg',
    category: SkillCategory.tool,
  ),
  Skill(
    name: 'Figma',
    proficiency: 0.7,
    iconPath: 'assets/icons/figma.svg',
    category: SkillCategory.tool,
  ),

  // Other Skills
  Skill(
    name: 'Data Structures',
    proficiency: 0.8,
    iconPath: 'assets/icons/dsa.svg',
    category: SkillCategory.other,
  ),
  Skill(
    name: 'OOP',
    proficiency: 0.85,
    iconPath: 'assets/icons/oop.svg',
    category: SkillCategory.other,
  ),
];
