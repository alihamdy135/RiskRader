import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF); // Light Pink
  static const Color color2 = Color(0xFFE4B1F0); // Lavender
  static const Color color3 = Color(0xFF7E60BF); // Purple
  
  // Additional colors for consistency
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Colors.white;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1, // Light pink background
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: AppColors.color3, // Purple app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.jpg'),
          fit: BoxFit.cover, // Ensures full coverage
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              context,
              icon: Icons.analytics,
              title: 'Data Charts',
              subtitle: 'View sensor trends',
              route: '/chart',
              color: AppColors.color2, // Lavender
            ),
            _buildFeatureCard(
              context,
              icon: Icons.security,
              title: 'Safety Monitor',
              subtitle: 'Real-time values',
              route: '/safety',
              color: AppColors.color3, // Purple
            ),
            _buildFeatureCard(
              context,
              icon: Icons.chat_bubble,
              title: 'Chat Bot',
              subtitle: 'Saftey Advisor',
              route: '/chatbot',
              color: AppColors.color2, // Lavender
            ),
            _buildFeatureCard(
              context,
              icon: Icons.info,
              title: 'About App',
              subtitle: 'How it works',
              route: '/about',
              color: AppColors.color3, // Purple
            ),
            _buildFeatureCard(
              context,
              icon: Icons.people,
              title: 'Supporters',
              subtitle: 'Our partners',
              route: '/supporter',
              color: AppColors.color2, // Lavender
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(100), // Circular shape
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make container circular
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.7), color],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}