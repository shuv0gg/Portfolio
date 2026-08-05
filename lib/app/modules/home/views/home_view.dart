// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      
      // Premium Dark theme color palette matching the screenshot
      final bgColor = isDark ? const Color(0xFF111317) : const Color(0xFFF8FAFC);
      final cardBg = isDark ? const Color(0xFF1A1D24) : Colors.white;
      final textPrimary = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
      final textSecondary = isDark ? const Color(0xFF8E95A5) : const Color(0xFF475569);
      final orangeAccent = const Color(0xFFFF5722); // Vibrant Orange from screenshot
      final borderColor = isDark ? const Color(0xFF252932) : const Color(0xFFE2E8F0);

      final ScrollController scrollController = ScrollController();

      return Scaffold(
        backgroundColor: bgColor,
        endDrawer: _buildMobileDrawer(context, textPrimary, bgColor, orangeAccent),
        body: SafeArea(
          child: Stack(
            children: [
              // Background Glow
              Positioned(
                top: -150,
                right: -150,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: orangeAccent.withOpacity(isDark ? 0.05 : 0.03),
                    boxShadow: [
                      BoxShadow(
                        color: orangeAccent.withOpacity(isDark ? 0.1 : 0.05),
                        blurRadius: 150,
                        spreadRadius: 150,
                      )
                    ],
                  ),
                ),
              ),

              // Scrollable Layout
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  // Nav Header
                  SliverToBoxAdapter(
                    child: _buildHeader(context, textPrimary, textSecondary, orangeAccent),
                  ),

                  // Split Hero Section
                  SliverToBoxAdapter(
                    child: _buildHeroSection(context, textPrimary, textSecondary, orangeAccent, cardBg, borderColor),
                  ),

                  // Skills Section
                  SliverToBoxAdapter(
                    child: _buildSkillsSection(context, textPrimary, textSecondary, cardBg, borderColor, orangeAccent),
                  ),

                  // Projects Section
                  SliverToBoxAdapter(
                    child: _buildProjectsSection(context, textPrimary, textSecondary, cardBg, borderColor),
                  ),

                  // Contact Section
                  SliverToBoxAdapter(
                    child: _buildContactSection(context, textPrimary, textSecondary, cardBg, borderColor, orangeAccent),
                  ),

                  // Footer
                  SliverToBoxAdapter(
                    child: _buildFooter(textSecondary, borderColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: const _ThemeSwitcherFAB(),
      );
    });
  }

  // Header / Navigation Bar Widget (Styled like screenshot)
  Widget _buildHeader(BuildContext context, Color textPrimary, Color textSecondary, Color orangeAccent) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Text "Persona"
          Text(
            'My Portfolio',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          
          // Centered Nav Links on Desktop
          if (!isMobile)
            Row(
              children: List.generate(
                controller.sections.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _AnimatedNavLink(
                    index: index,
                    title: controller.sections[index],
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    accentColor: orangeAccent,
                  ),
                ),
              ),
            ),

          // Actions Right (Search icon + "LET'S TALK" button)
          Row(
            children: [
              if (!isMobile) ...[
                IconButton(
                  icon: Icon(Icons.search, color: textPrimary.withOpacity(0.8), size: 22),
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.scrollToSection(3), // Scroll to Contact
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "LET'S TALK",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ] else
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: textPrimary),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Mobile Drawer Navigation
  Widget _buildMobileDrawer(BuildContext context, Color textPrimary, Color bgColor, Color accentColor) {
    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: controller.sections.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isActive = controller.activeSectionIndex.value == index;
                    return ListTile(
                      title: Text(
                        controller.sections[index],
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          color: isActive ? accentColor : textPrimary,
                        ),
                      ),
                      leading: Icon(
                        index == 0
                            ? Icons.home_outlined
                            : index == 1
                                ? Icons.psychology_outlined
                                : index == 2
                                    ? Icons.code_outlined
                                    : Icons.mail_outline,
                        color: isActive ? accentColor : textPrimary.withOpacity(0.6),
                      ),
                      selected: isActive,
                      selectedTileColor: accentColor.withOpacity(0.08),
                      onTap: () {
                        controller.scrollToSection(index);
                        Navigator.of(context).pop();
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Split-Screen Hero Section matching screenshot layout
  Widget _buildHeroSection(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color orangeAccent,
    Color cardBg,
    Color borderColor,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    if (isMobile) {
      return Padding(
        key: controller.sectionKeys[0],
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeroImage(context, cardBg, orangeAccent),
            const SizedBox(height: 36),
            _buildHeroText(isMobile, textPrimary, textSecondary, orangeAccent),
          ],
        ),
      );
    } else {
      return Padding(
        key: controller.sectionKeys[0],
        padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 60.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Text Content
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroText(isMobile, textPrimary, textSecondary, orangeAccent),
                ],
              ),
            ),
            const SizedBox(width: 48),
            // Right Column: Large Styled Avatar Image
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildHeroImage(context, cardBg, orangeAccent),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Hero section image block (sized larger)
  Widget _buildHeroImage(BuildContext context, Color cardBg, Color orangeAccent) {
    return Obx(() {
      final imgUrl = controller.profileImageUrl.value;
      final double screenWidth = MediaQuery.of(context).size.width;
      final bool isMobile = screenWidth < 900;

      return Container(
        width: isMobile ? 260 : 380,
        height: isMobile ? 260 : 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: orangeAccent.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: orangeAccent.withOpacity(0.08),
              blurRadius: 30,
              spreadRadius: 10,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            color: cardBg,
            child: imgUrl.isNotEmpty
                ? (imgUrl.startsWith('http')
                    ? Image.network(imgUrl, fit: BoxFit.cover)
                    : Image.asset(imgUrl, fit: BoxFit.cover))
                : Icon(
                    Icons.person,
                    size: isMobile ? 120 : 180,
                    color: orangeAccent.withOpacity(0.7),
                  ),
          ),
        ),
      );
    });
  }

  // Hero section text block
  Widget _buildHeroText(bool isMobile, Color textPrimary, Color textSecondary, Color orangeAccent) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Subtitle "HELLO, MY NAME IS"
        Text(
          'HELLO, MY NAME IS',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: orangeAccent,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 16),
        
        // Full Name
        Text(
          controller.profileName.value,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.outfit(
            fontSize: isMobile ? 40 : 64,
            fontWeight: FontWeight.w900,
            color: textPrimary,
            height: 1.1,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 16),

        // Profession/Title
        Text(
          controller.profileTitle.value.toUpperCase(),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.outfit(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w800,
            color: textSecondary.withOpacity(0.85),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Short Bio
        SizedBox(
          width: 500,
          child: Text(
            controller.profileBio.value,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: textSecondary,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Social links
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _SocialButton(
              icon: Icons.code_rounded,
              label: 'GitHub',
              url: controller.githubUrl.value,
              brandColor: const Color(0xFF24292F),
              textPrimary: textPrimary,
              borderColor: textSecondary.withOpacity(0.3),
            ),
            const SizedBox(width: 16),
            _SocialButton(
              icon: Icons.connect_without_contact_rounded,
              label: 'LinkedIn',
              url: controller.linkedinUrl.value,
              brandColor: const Color(0xFF0A66C2),
              textPrimary: textPrimary,
              borderColor: textSecondary.withOpacity(0.3),
            ),
          ],
        ),
      ],
    );
  }

  // Skills Section
  Widget _buildSkillsSection(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color borderColor,
    Color accentColor,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Padding(
      key: controller.sectionKeys[1],
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('SKILLS & EXPERTISE', 'Technologies I Master', textPrimary, textSecondary, accentColor),
          const SizedBox(height: 24),
          
          Text(
            'Select any skill card below to view detailed breakdown, expertise level, and core methodologies.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Responsive grid layout for skills (Concise height)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (screenWidth < 900 ? 2 : 3),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 80, // Concise height!
            ),
            itemBuilder: (context, index) {
              final skill = controller.skills[index];
              return _SkillChip(
                index: index,
                skillName: skill['name'] as String,
                skillColor: skill['color'] as Color,
                skillLevel: skill['level'] as double,
                skillIcon: skill['icon'] as IconData,
                cardBg: cardBg,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Skill Details Card (Animated details panel of the selected skill)
          Obx(() {
            final selectedIndex = controller.selectedSkillIndex.value;
            if (selectedIndex < 0 || selectedIndex >= controller.skills.length) {
              return const SizedBox();
            }
            final skill = controller.skills[selectedIndex];
            final skillName = skill['name'] as String;
            final skillColor = skill['color'] as Color;
            final skillLevel = skill['level'] as double;
            final skillDesc = skill['description'] as String;
            final skillIcon = skill['icon'] as IconData;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: skillColor.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: skillColor.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: skillColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(skillIcon, color: skillColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skillName,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            'Expertise level: ${(skillLevel * 100).toInt()}%',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    skillDesc,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress Bar inside Details Box
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenWidth * skillLevel * 0.5 > 350.0 ? 350.0 : screenWidth * skillLevel * 0.5,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [skillColor, skillColor.withOpacity(0.6)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Projects Section
  Widget _buildProjectsSection(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color borderColor,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Padding(
      key: controller.sectionKeys[2],
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('PORTFOLIO SHOWCASE', 'Recent Project Demos', textPrimary, textSecondary, const Color(0xFFFF5722)),
          const SizedBox(height: 24),

          Text(
            'Hover over or tap projects to experience the hover lift and neon gradient highlights. Select a card to expand in-depth details.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Responsive grid layout for projects
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.projects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (screenWidth < 1000 ? 2 : 3),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final project = controller.projects[index];
              return _ProjectCard(
                index: index,
                title: project['title'] as String,
                category: project['category'] as String,
                description: project['description'] as String,
                details: project['details'] as String,
                techStack: project['techStack'] as List<String>,
                accentColor: project['accentColor'] as Color,
                icon: project['icon'] as IconData,
                cardBg: cardBg,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              );
            },
          ),
        ],
      ),
    );
  }

  // Contact Section
  Widget _buildContactSection(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color borderColor,
    Color accentColor,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    return Padding(
      key: controller.sectionKeys[3],
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        children: [
          _buildSectionHeader('GET IN TOUCH', 'Let\'s Create Something Amazing Together', textPrimary, textSecondary, accentColor),
          const SizedBox(height: 40),

          Container(
            width: 800,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info block
                Expanded(
                  flex: isMobile ? 0 : 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Have an idea for a project or looking to build a new app? Drop me a line, and let\'s explore how I can add value.',
                        style: GoogleFonts.outfit(
                          color: textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildContactInfoRow(Icons.email_outlined, 'Email', controller.profileEmail.value, accentColor, textPrimary, textSecondary),
                      const SizedBox(height: 20),
                      _buildContactInfoRow(Icons.phone_outlined, 'Phone', controller.profilePhone.value, accentColor, textPrimary, textSecondary),
                      const SizedBox(height: 20),
                      _buildContactInfoRow(Icons.location_on_outlined, 'Location', controller.profileLocation.value, accentColor, textPrimary, textSecondary),
                    ],
                  ),
                ),
                
                if (isMobile) const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Divider(),
                ) else const SizedBox(width: 48),

                // Form block
                Expanded(
                  flex: isMobile ? 0 : 5,
                  child: Column(
                    children: [
                      _buildTextField('Your Name', Icons.person_outline, textPrimary, textSecondary, borderColor, accentColor),
                      const SizedBox(height: 16),
                      _buildTextField('Email Address', Icons.mail_outline, textPrimary, textSecondary, borderColor, accentColor),
                      const SizedBox(height: 16),
                      _buildTextField('Your Message', Icons.chat_bubble_outline, textPrimary, textSecondary, borderColor, accentColor, maxLines: 4),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Send Message',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Helper
  Widget _buildSectionHeader(
    String badge,
    String title,
    Color textPrimary,
    Color textSecondary,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          badge,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: accentColor,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  // Contact Info Row
  Widget _buildContactInfoRow(
    IconData icon,
    String label,
    String val,
    Color accentColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(fontSize: 12, color: textSecondary),
            ),
            Text(
              val,
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
            ),
          ],
        ),
      ],
    );
  }

  // Contact Input Helper
  Widget _buildTextField(
    String hint,
    IconData icon,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color accentColor, {
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      style: GoogleFonts.outfit(color: textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: textSecondary.withOpacity(0.7), fontSize: 14),
        prefixIcon: Icon(icon, color: textSecondary.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }

  // Footer
  Widget _buildFooter(Color textSecondary, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      margin: const EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Center(
        child: Text(
          '© 2026 Mohammad Emranul Kader Shuvo. Built with Flutter & GetX architecture.',
          style: GoogleFonts.outfit(
            color: textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1) ANIMATED NAVIGATION LINK (Component 1)
// ==========================================
class _AnimatedNavLink extends StatelessWidget {
  final int index;
  final String title;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentColor;

  const _AnimatedNavLink({
    required this.index,
    required this.title,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isHovered = controller.hoveredNavIndex.value == index;
      final isActive = controller.activeSectionIndex.value == index;

      // Color Transition: Text changes to accent, bottom border fades in
      // Size Transition: Bottom border thickness transition on selection
      return MouseRegion(
        onEnter: (_) => controller.hoveredNavIndex.value = index,
        onExit: (_) => controller.hoveredNavIndex.value = -1,
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.scrollToSection(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive
                      ? accentColor
                      : (isHovered ? accentColor.withOpacity(0.4) : Colors.transparent),
                  width: 3.0,
                ),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive
                    ? textPrimary
                    : (isHovered ? textPrimary.withOpacity(0.85) : textSecondary),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ==========================================
// 2) INTERACTIVE SKILL CHIP (Component 3)
// ==========================================
class _SkillChip extends StatelessWidget {
  final int index;
  final String skillName;
  final Color skillColor;
  final double skillLevel;
  final IconData skillIcon;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _SkillChip({
    required this.index,
    required this.skillName,
    required this.skillColor,
    required this.skillLevel,
    required this.skillIcon,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isSelected = controller.selectedSkillIndex.value == index;

      // Color Transition: Neutral card to tech brand gradient on selection
      // Size Transition: Hover/selection changes border width and subtle scale
      return GestureDetector(
        onTap: () => controller.selectSkill(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? skillColor : cardBg,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? skillColor : borderColor,
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: skillColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                skillIcon,
                color: isSelected ? Colors.white : skillColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  skillName,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : borderColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(skillLevel * 100).toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ==========================================
// _SocialButton
// ==========================================
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final Color brandColor;
  final Color textPrimary;
  final Color borderColor;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.brandColor,
    required this.textPrimary,
    required this.borderColor,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: _isHovered ? 24.0 : 16.0,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? widget.brandColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? widget.brandColor : widget.borderColor,
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.brandColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? Colors.white : widget.textPrimary.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _isHovered ? Colors.white : widget.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3) INTERACTIVE PROJECT CARD (Component 2)
// ==========================================
class _ProjectCard extends StatefulWidget {
  final int index;
  final String title;
  final String category;
  final String description;
  final String details;
  final List<String> techStack;
  final Color accentColor;
  final IconData icon;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _ProjectCard({
    required this.index,
    required this.title,
    required this.category,
    required this.description,
    required this.details,
    required this.techStack,
    required this.accentColor,
    required this.icon,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isSelected = controller.selectedProjectIndex.value == widget.index;
      
      // Color Transitions: Background gradients & shadow glowing color transitions.
      // Size Transitions: The card shifts upwards using dynamic padding margins, and expands bottom details when clicked.
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.selectProject(widget.index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(
              bottom: _isHovered ? 12.0 : 4.0,
              top: _isHovered ? 0.0 : 8.0,
            ),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: widget.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? widget.accentColor
                    : (_isHovered ? widget.accentColor.withOpacity(0.5) : widget.borderColor),
                width: isSelected || _isHovered ? 2.0 : 1.5,
              ),
              boxShadow: _isHovered || isSelected
                  ? [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Icon & Category Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 24,
                      ),
                    ),
                    Text(
                      widget.category,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Project Title
                Text(
                  widget.title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Short Description
                Text(
                  widget.description,
                  maxLines: isSelected ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: widget.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Tech stack tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.techStack.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.borderColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Expanded Section: Details block (Animated Container Size Transition)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isSelected ? double.infinity : 0,
                    alignment: Alignment.topLeft,
                    child: isSelected
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Architecture & Details:',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: widget.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.details,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: widget.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// ==========================================
// 4) ANIMATED THEME SWITCHER FAB (Component 4)
// ==========================================
class _ThemeSwitcherFAB extends StatefulWidget {
  const _ThemeSwitcherFAB();

  @override
  State<_ThemeSwitcherFAB> createState() => _ThemeSwitcherFABState();
}

class _ThemeSwitcherFABState extends State<_ThemeSwitcherFAB> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      // Color Transition: Bright golden yellow on light mode -> deep night indigo on dark mode.
      // Size Transition: Hover expands the widget horizontally from 56.0 width (circle) to 150.0 width (rounded pill).
      final Color fabColor = isDark ? const Color(0xFF6366F1) : const Color(0xFFF59E0B);
      final double width = _isHovered ? 150.0 : 56.0;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: width,
          height: 56.0,
          decoration: BoxDecoration(
            color: fabColor,
            borderRadius: BorderRadius.circular(28.0),
            boxShadow: [
              BoxShadow(
                color: fabColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28.0),
              onTap: () => controller.toggleTheme(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isDark ? 0.0 : 0.5,
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.white,
                      ),
                    ),
                    if (_isHovered) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isDark ? 'Dark Mode' : 'Light Mode',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
