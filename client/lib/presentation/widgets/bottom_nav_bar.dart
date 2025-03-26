
import 'package:counter_x/presentation/ui/home.dart';
import 'package:counter_x/presentation/ui/practice.dart';
import 'package:counter_x/presentation/ui/profile.dart';
import 'package:counter_x/presentation/ui/summarizer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    Summarizer(),
    Practice(),
    Profile()
  ];

  void _onItemTapped(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 118, 118, 118),
            currentIndex: _selectedIndex, 
            onTap: _onItemTapped, 
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.note), label: 'All notes'),
              BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'Summarizer'),
              BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Practice'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}



















// import 'package:counter_x/models/note_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   // Sample data for notes
//   List<Note> filteredNotes = [];

//   @override
//   void initState(){
//     super.initState();
//     filteredNotes = notes;
//   }
  
//   void searchNotes(String searchText){
//     setState(() {
//       filteredNotes = notes.where((Note) => Note.content.toLowerCase().contains(searchText.toLowerCase()) ||
//     Note.title.toLowerCase().contains(searchText.toLowerCase())
//     ).toList();
//     });
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Scaffold(
//           backgroundColor: const Color.fromARGB(255, 232, 230, 244),
//           body:  Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Peanote AI 🥜",
//                         style: GoogleFonts.lexend(
//                           fontSize: 27,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                         ),
//                         IconButton(onPressed: (){}, 
//                         padding: EdgeInsets.all(0),
//                         icon: Container(
//                           width: 10.w,
//                           height: 5.h,
//                           decoration: BoxDecoration(
//                             color: Colors.white38,
//                             borderRadius: BorderRadius.circular(10),
                            
//                           ),
//                           child: Icon(Icons.sort,
//                           color: Colors.black87,
//                           ),
                
//                         ))
//                       ],
//                     ),
//                     SizedBox(height: 2.h,),
//                     TextField(
//                       onChanged: searchNotes,
//                       style : GoogleFonts.lexend(
//                           fontSize: 16.sp,
                          
//                           color: Colors.black,
//                         ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 12),
//                 hintText: "Search your notes...",
//                 hintStyle: GoogleFonts.lexend(
//                   fontSize: 20,
//                   color: Colors.black38,
//                 ),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 fillColor: Colors.white60,
//                 filled: true,
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
//                   borderSide: BorderSide(color: Colors.white60), // White border
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide(color: Colors.white60), // White border when focused
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide(color: Colors.white60), // Default border
//                 ),
//               ),
//             ), // Reduce or remove this
//             SizedBox(height: 3.h,),
            

//               Expanded(
//   child: ListView.builder(
    
//     itemCount: filteredNotes.length,
//     itemBuilder: (context, index) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 10.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10) 
//           ),
//           child: ListTile(
            
//             title: RichText(
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//               text: TextSpan(
//                 text: "${filteredNotes[index].title} \n",
//                 style: GoogleFonts.lexend(
//                   fontSize: 19.sp,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold
//                 ),
//                 children: [
//                   TextSpan(
//                     text: "${filteredNotes[index].content}",
//                     style: GoogleFonts.lexend(
//                       fontSize: 15.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             subtitle: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                     "Edited ${DateFormat('dd MMM yyyy, hh:mm a').format(filteredNotes[index].modifiedTime)}",
//               style:  GoogleFonts.lexend(
//                         fontSize: 10,
//                         color: Colors.black87,
//                       ),
//               ),
//             ),trailing: PopupMenuButton<int>(
//   onSelected: (value) {
//     if (value == 0) {
//       // Perform delete action
//     } else if (value == 1) {
//       // Perform edit action
//     }
//   },
//   itemBuilder: (context) => [
//     PopupMenuItem(
//       value: 0,
//       child: Row(
//         children: [
//           Icon(Icons.delete, color: Colors.red),
//           SizedBox(width: 10),
//           Text("Delete", style: GoogleFonts.lexend(fontSize: 14)),
//         ],
//       ),
//     ),
//     PopupMenuItem(
//       value: 1,
//       child: Row(
//         children: [
//           Icon(Icons.edit, color: Colors.blue),
//           SizedBox(width: 10),
//           Text("Edit", style: GoogleFonts.lexend(fontSize: 14)),
//         ],
//       ),
//     ),
//   ],
//   icon: Icon(Icons.menu), // Keeps the menu button
// ),

//           ),
//         ),
//       );
//     },
   
//   ),
// )



//                   ],
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 elevation: 10,
//                 backgroundColor: Colors.white38,
//                 shape: CircleBorder(),
//                 onPressed: (){

//               },
//               child: Icon(Icons.add,
//               color: Colors.black87,
//               size: 30,
//               ),
              
//               ),
              
//           );
          
//       },
//     );
//   }
// }