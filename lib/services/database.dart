import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance.collection("users").where("name", isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance.collection("ChatRoom").document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, Map messageMap) {
    Firestore.instance.collection("ChatRoom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async {
    print(chatRoomId);
    return Firestore.instance.collection("ChatRoom").document(chatRoomId).collection("chats").orderBy("time").snapshots();
  }

  getChatRooms(String userName) async {
    return Firestore.instance.collection("ChatRoom").where("users", arrayContains: userName).snapshots();
  }
}