// import 'package:dating_app/services/MessageService.dart';
// import 'package:flutter/material.dart';
// import 'package:dating_app/models/message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageScreen extends StatefulWidget {
//   final String userId;
//   final String contactId;
//   final String contactName;

//   const MessageScreen({
//     super.key,
//     required this.userId,
//     required this.contactId,
//     required this.contactName,
//   });

//   @override
//   _MessageScreenState createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   void _sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       final message = Message(
//         senderId: widget.userId,
//         receiverId: widget.contactId,
//         content: _messageController.text,
//         timestamp: Timestamp.now(),
//       );
//       MessageService.sendMessage(message);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.contactName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: MessageService.getMessages(widget.userId, widget.contactId),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final messages = snapshot.data ?? [];
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isMe = message.senderId == widget.userId;
//                     return ListTile(
//                       title: Align(
//                         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: isMe ? Colors.blue : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(message.content),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
