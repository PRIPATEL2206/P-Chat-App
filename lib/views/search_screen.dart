// import 'package:flutter/material.dart';
// import 'package:pchat/helper/route_helper.dart';
// import 'package:pchat/models/group_model.dart';
// import 'package:pchat/views/profile_screen.dart';
// import 'package:pchat/widgets/app_input_field.dart';
// import 'package:pchat/widgets/floting_action_button.dart';
// import 'package:pchat/widgets/user_tile.dart';

// class SearchScreen extends StatelessWidget {
//   final List<ChatAppGroup> groups;
//   const SearchScreen({super.key, required this.groups});

//   @override
//   Widget build(BuildContext context) {
//     String searchQuery = "";
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: AppTextField(
//                       onChange: (value) => searchQuery = value,
//                     ),
//                   ),
//                   IconButton(
//                       onPressed: () {
                       
//                       },
//                       icon: const Icon(Icons.group))
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 10,
//                 itemBuilder: (context, index) {
//                   return GroupUserTile(
//                     onTap: () => gotoScreen(
//                         context: context, screen: const ProfileScreen()),
//                     index: index.toString(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       // floatingActionButton: ,
//     );
//   }
// }
