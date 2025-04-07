import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:counter_x/models/NotesModel/nm.dart';
import 'package:counter_x/presentation/ui/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // User profile details
  String userName = "Loading...";
  String userEmail = "loading...";
  int totalNotes =  0;
  int categorizedNotes = 0;
  // String profilePic = "https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}"; // Random user image
  String profilePic = ""; // Placeholder image

  @override
  void initState() {
    super.initState();
    _fetchUserProfileDetails();
  }
  Future<void> _fetchUserProfileDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
          if(docSnapshot.exists){
            final userData = docSnapshot.data() as Map<String, dynamic>;
            setState(() {
              userName = userData['name'] ?? "Loading...";
              userEmail = userData['email'] ?? "Loading...";
              profilePic = userData['profilePic'] ?? "https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}"; // Random user image
              totalNotes = userData['notes']?.length ?? 0;
            });
          }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 232, 230, 244),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 10.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "Profile",
                          style: GoogleFonts.lexend(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white54,
                            backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 70}" // Random user image
                                ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            userName,
                            style: GoogleFonts.lexend(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Profile Statistics
                    Card(
                      color: Colors.white54,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('Total Notes', totalNotes),
                            _buildStatColumn('Categorized', categorizedNotes),
                            _buildStatColumn('Summaries', 5),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Profile Settings
                    _buildSettingsSection(),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  // Helper method to build statistics column
  Widget _buildStatColumn(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.lexend(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Helper method to build settings section
  Widget _buildSettingsSection() {
    return Card(
      color: Colors.white54,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Implement edit profile functionality
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.category,
            title: 'Manage Categories',
            onTap: () {
              // TODO: Implement category management
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.settings,
            title: 'App Settings',
            onTap: () {
              // TODO: Implement app settings
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              



                  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You have been successfully logged out",
            style: GoogleFonts.poppins(),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // ✅ Navigate to Login Page (Update the route accordingly)
      context.read<AuthBloc>().add(LogoutRequested());
      Navigator.pushReplacement(
        context,  MaterialPageRoute( builder: (context) => const Login()));












            },
          ),
        ],
      ),
    );
  }

  // Helper method to build individual setting item
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
    );
  }

  // Helper method to build divider
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Colors.black12,
      indent: 16,
      endIndent: 16,
    );
  }
}
