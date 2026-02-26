import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Lets the MainScreen navy show through
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. The Profile Image with White Border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ), // That white ring
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 70, // Nice and big
                  backgroundImage: AssetImage('lib/assets/images/avatar.jpg'),
                  backgroundColor: Color(0xFF1E293B), // Fallback color
                ),
              ),

              const SizedBox(height: 24),

              // 2. The "I am Demir." Heading
              Text(
                "I am Demir.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold, // Extra bold
                ),
              ),

              const SizedBox(height: 32),

              // 3. The Body Text
              // We use RichText or just standard Text.
              // Since your text has simple formatting, a standard Text widget is cleaner.
              Text(
                "I’m a 19-year-old software enthusiast with over three years of experience in software engineering. My primary focus is mobile app development, a passion that started when I was first introduced to informatics in school. That early curiosity led me to participate in programming olympiads — I proudly won 1st place twice for my school and later secured 1st place in the prestigious \"Al-Khwarizmi\" Olympiad.\n\nA key moment in my journey was when my teacher, Husniddin, lent me his own laptop so I could practice programming at home. That act of support introduced me to the world of code — long before I had a device of my own. Today, I’m pursuing a Bachelor's degree under the Millat Umidi foundation and continue to explore the world of software development with the same curiosity I started with.\n\nOutside of tech, I have a deep interest in films — from storytelling and cinematography to the creative decisions of directors. It fascinates me how ideas turn into powerful visual experiences.\n\nSo far, I’ve built several projects, including a Weather App, Rock-Paper-Scissors game, and a Fast-Food Delivery App for a local restaurant, among others. If you'd like to read more about my thoughts, reflections, experiences, and what I've learned along the way, check out the articles I post on the Reeds page. See you there!",
                textAlign:
                    TextAlign.center, // Centered just like the screenshot
                style: GoogleFonts.inter(
                  color: const Color(
                    0xFFCBD5E1,
                  ), // Slightly soft white (Slate-300) for readability
                  fontSize: 16,
                  height: 1.6, // Good line height makes long text easy to read
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
