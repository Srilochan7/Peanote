import 'package:counter_x/blocs/AuthBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class UserDetails extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserDetails({super.key, required this.userData});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late String uid;
  late String email;
  late String name;
  late String profilePic;
  late DateTime createdAt;
  late String subscriptionStatus;
  late Map<String, dynamic> preferences;

  @override
  void initState() {
    super.initState();
    
    // Extract user data
    uid = widget.userData['uid'] ?? 'N/A';
    email = widget.userData['email'] ?? 'N/A';
    name = widget.userData['name'] ?? 'N/A';
    profilePic = widget.userData['profilePic'] ?? '';
    
    // Parse createdAt date
    try {
      createdAt = DateTime.parse(widget.userData['createdAt'] ?? DateTime.now().toIso8601String());
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    subscriptionStatus = widget.userData['subscriptionStatus'] ?? 'free';
    preferences = widget.userData['preferences'] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5FA),
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            elevation: 0,
            title: Text(
              "User Details",
              style: GoogleFonts.lexend(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        
                        // Profile Picture
                        CircleAvatar(
                          radius: 12.w,
                          backgroundColor: Colors.white,
                          backgroundImage: profilePic.isNotEmpty
                              ? NetworkImage(profilePic)
                              : null,
                          child: profilePic.isEmpty
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: GoogleFonts.lexend(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                )
                              : null,
                        ),
                        
                        SizedBox(height: 1.h),
                        
                        // User Name
                        Text(
                          name,
                          style: GoogleFonts.lexend(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        // Subscription Badge
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: subscriptionStatus.toLowerCase() == 'premium'
                                ? Colors.amber
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subscriptionStatus.toUpperCase(),
                            style: GoogleFonts.lexend(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: subscriptionStatus.toLowerCase() == 'premium'
                                  ? Colors.black
                                  : Colors.deepPurple,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 3.h),
                  
                  // Details Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Information",
                          style: GoogleFonts.lexend(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        SizedBox(height: 2.h),
                        
                        // Information Cards
                        _buildInfoCard("Email", email, Icons.email_outlined),
                        _buildInfoCard("User ID", uid, Icons.fingerprint),
                        _buildInfoCard(
                          "Joined On", 
                          DateFormat('MMMM dd, yyyy').format(createdAt),
                          Icons.calendar_today_outlined
                        ),
                        
                        SizedBox(height: 3.h),
                        
                        Text(
                          "Preferences",
                          style: GoogleFonts.lexend(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        SizedBox(height: 2.h),
                        
                        // Preferences Cards
                        _buildPreferenceCard(
                          "Language",
                          preferences['language'] ?? 'English',
                          Icons.language_outlined,
                        ),
                        
                        _buildSwitchCard(
                          "Dark Mode",
                          preferences['darkMode'] ?? false,
                          Icons.dark_mode_outlined,
                          (value) {
                            setState(() {
                              preferences['darkMode'] = value;
                            });
                            // Here you would update this preference in your backend
                          },
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // Upgrade Button (if not premium)
                        if (subscriptionStatus.toLowerCase() != 'premium')
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement upgrade logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Upgrade feature not implemented yet")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              minimumSize: Size(90.w, 6.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Upgrade to Premium",
                              style: GoogleFonts.lexend(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                        SizedBox(height: 2.h),
                        
                        // Logout Button
                        ElevatedButton(
                          onPressed: () {
                            // Trigger logout event
                            BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(90.w, 6.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          child: Text(
                            "Logout",
                            style: GoogleFonts.lexend(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.deepPurple,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreferenceCard(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.deepPurple,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.deepPurple),
            onPressed: () {
              // TODO: Implement edit functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Edit feature not implemented yet")),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwitchCard(String title, bool value, IconData icon, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.deepPurple,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.lexend(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}