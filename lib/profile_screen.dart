import 'package:flutter/material.dart';
import 'package:news_app/services/auth_service.dart';

import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFBF8FE),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

       


      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// PROFILE HEADER
            Column(
              children: [

                Stack(
                  children: [

                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1502767089025-6572583495b0",
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  "Test User",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "testUser@gmail.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [

                  Expanded(
                    child: statCard(
                      Icons.menu_book,
                      "124",
                      "Articles Read",
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: statCard(
                      Icons.bookmark,
                      "42",
                      "Saved Stories",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ACCOUNT SETTINGS
            settingsTitle("Account Settings"),

            settingsTile(Icons.person, "Edit Profile"),
            settingsTile(Icons.notifications, "Notification Settings"),
            settingsTile(Icons.history, "Reading History"),

            const SizedBox(height: 20),

            /// PREFERENCES
            settingsTitle("Preferences"),

            Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text("Appearance"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 12),
                    ),

                    Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),

            settingsTile(Icons.translate, "Language"),
            settingsTile(Icons.help_outline, "Help & Support"),

            const SizedBox(height: 30),

            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {

                  await AuthService.logout();

                  if (!mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Version 1.0",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// STAT CARD
  Widget statCard(IconData icon, String value, String label) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(icon, size: 24),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// SETTINGS TITLE
  Widget settingsTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  /// SETTINGS TILE
  Widget settingsTile(IconData icon, String title) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}