import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupchatfirebase/models/message.dart';

class ChatService {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get user stream
  /*
  List<Map<String,dynamic> =

[
  {
    'email': nam123@gmail.com,
    'id': nam123
  },
  {
    'email': hai123@gmail.com,
    'id': hai123
  },
  ]

  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send messege
  Future<void> sendMessage(String receiverID, message) async {
    // get current user
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );
    //chat room ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    // add new message
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messege
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // chat 2 user
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
