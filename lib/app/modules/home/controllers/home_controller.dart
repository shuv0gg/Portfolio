import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Theme state
  final isDarkMode = true.obs;

  // User profile information
  final profileName = 'Mohammad Emranul Kader Shuvo'.obs;
  final profileTitle = 'Flutter Developer & UI Designer'.obs;
  final profileBio = 'Crafting visually gorgeous, buttery-smooth mobile and web experiences. Specialist in clean software architecture, advanced state management, and creative animations.'.obs;
  final profileEmail = 'mek234778@gmail.com'.obs;
  final profilePhone = '+8801754751117'.obs;
  final profileLocation = 'Chittagong, Bangladesh'.obs;
  final profileImageUrl = 'assets/profile_dp.png'.obs; // Provide an HTTP link or asset path here
  final githubUrl = 'https://github.com/shuv0gg'.obs;
  final linkedinUrl = 'https://linkedin.com/in/shuv0gg'.obs;

  // Global Keys for layout sections (used for scrolling)
  final List<GlobalKey> sectionKeys = List.generate(4, (index) => GlobalKey());

  // Navigation statea
  final activeSectionIndex = 0.obs;
  final hoveredNavIndex = (-1).obs;

  // Selected project state (for details expansion animation)
  final selectedProjectIndex = 0.obs;

  // Selected skill state (for chip expansion animation)
  final selectedSkillIndex = 0.obs;

  // Nav menu open state for mobile
  final isMobileMenuOpen = false.obs;

  // Portfolio Section Headers
  final sections = ['Home', 'Skills', 'Projects', 'Contact'];

  // Portfolio mock data
  final projects = <Map<String, dynamic>>[
    {
      'title': 'Zenith Task Manager',
      'category': 'Productivity App',
      'description': 'A beautiful task planner with local notifications, statistical insights, drag-and-drop boards, and full offline functionality.',
      'details': 'Zenith uses Clean Architecture to separate UI, Domain, and Data layers. It integrates Hive for lightweight local database caching, Flutter Local Notifications for time-sensitive task reminders, and custom canvas-based drawing for productivity graphs. Features include custom tagging, priority levels, and Pomodoro timer integration.',
      'techStack': ['Flutter', 'Hive DB', 'BLoC', 'Canvas API'],
      'accentColor': const Color(0xFF0D6EFD), // Royal Blue
      'icon': Icons.task_alt,
    },
    {
      'title': 'Nova eCommerce Platform',
      'category': 'Responsive E-Commerce',
      'description': 'A fully-featured responsive online storefront with real-time stock sync, Stripe payment gateway, and admin panel dashboard.',
      'details': 'Nova eCommerce provides a seamless shopping experience across web, mobile, and desktop. Leveraging Firebase Firestore for real-time catalog syncing and authentication, it integrates Stripe SDK for secure payments. The admin panel lets sellers track orders, upload new products with cloud storage, and view basic sales metrics.',
      'techStack': ['Flutter Web', 'Firebase', 'Stripe SDK', 'GetX'],
      'accentColor': const Color(0xFFE91E63), // Vibrant Magenta
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'title': 'Aether Crypto Dashboard',
      'category': 'Finance / Web3',
      'description': 'A real-time cryptocurrency price tracker and portfolio manager utilizing WebSockets and interactive charts.',
      'details': 'Aether tracks live market changes for over 100+ cryptocurrencies. By implementing WebSocket channels with Binance APIs, prices update sub-second. Features interactive candle charts using Fl-Charts, custom portfolio value calculations, and instant alerts. Built using custom cached repository patterns to optimize network calls.',
      'techStack': ['Flutter', 'REST & WebSockets', 'Fl-Charts', 'RxDart'],
      'accentColor': const Color(0xFF00B4AB), // Teal
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  final skills = <Map<String, dynamic>>[
    {
      'name': 'Flutter',
      'color': const Color(0xFF02569B),
      'level': 0.95,
      'icon': Icons.flutter_dash,
      'description': 'Expert in building cross-platform apps for Android, iOS, Web, and Desktop from a single codebase. Advanced custom painter, slivers, and layout rendering expert.',
    },
    {
      'name': 'Dart',
      'color': const Color(0xFF00B4AB),
      'level': 0.90,
      'icon': Icons.code_rounded,
      'description': 'Proficient in Dart programming language. Strong knowledge of async programming (Futures, Streams), extension methods, null-safety, and generator functions.',
    },
    {
      'name': 'GetX',
      'color': const Color(0xFF5F00F7),
      'level': 0.88,
      'icon': Icons.bolt_outlined,
      'description': 'Extensive experience using GetX for lightweight, high-performance state management, reactive programming, navigation (routing without context), and dependency injection.',
    },
    {
      'name': 'Firebase',
      'color': const Color(0xFFFFCA28),
      'level': 0.85,
      'icon': Icons.local_fire_department_outlined,
      'description': 'Experienced in integrating Firestore, Firebase Authentication, Cloud Storage, Cloud Functions, and Analytics for full serverless apps.',
    },
    {
      'name': 'Git & CI/CD',
      'color': const Color(0xFFF05032),
      'level': 0.82,
      'icon': Icons.merge_type_rounded,
      'description': 'Skilled in version control with Git and setting up GitHub Actions or Codemagic pipelines for automated linting, unit testing, and releases.',
    },
    {
      'name': 'UI/UX Design',
      'color': const Color(0xFF9C27B0),
      'level': 0.80,
      'icon': Icons.palette_outlined,
      'description': 'Focus on crafting polished, developer-friendly, human-centric design tokens, custom micro-interactions, responsive sizing, and fluid transitions.',
    },
  ];

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void changeSection(int index) {
    activeSectionIndex.value = index;
    isMobileMenuOpen.value = false;
  }

  void scrollToSection(int index) {
    changeSection(index);
    final context = sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectProject(int index) {
    selectedProjectIndex.value = index;
  }

  void selectSkill(int index) {
    selectedSkillIndex.value = index;
  }

  void toggleMobileMenu() {
    isMobileMenuOpen.value = !isMobileMenuOpen.value;
  }
}
