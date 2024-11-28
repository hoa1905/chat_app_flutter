import 'package:chat_app_flutter/providers/authentication_provider.dart';
import 'package:chat_app_flutter/utilities/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class GroupChatAppBar extends StatefulWidget {
//   const GroupChatAppBar({super.key, required this.groupID});

//   final String groupID;

//   @override
//   State<GroupChatAppBar> createState() => _GroupChatAppBarState();
// }

// class _GroupChatAppBarState extends State<GroupChatAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: context
//           .read<AuthenticationProvider>()
//           .getUserStream(userID: widget.groupID),
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Đã có lỗi xảy ra'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final groupModel =
//             GroupModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

//         return Row(
//           children: [
//             userImageWidget(
//               imageUrl: groupModel.groupName,
//               radius: 20,
//               onTap: () {
//                 // navigate to group settings screen
//               },
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(groupModel.groupName),
//                 const Text(
//                   'Mô tả nhóm hoặc thành viên nhóm',
//                   // userModel.isOnline
//                   //     ? 'Đang hoạt động'
//                   //     : 'Đã rời ${GlobalMethods.formatTimestamp(userModel.lastSeen)}',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
