import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }
    ):
    Container();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// create chatroom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String userName}) {
    print("${Constants.myName}");
    if(userName != Constants.myName) {
      String chatRoomId = getChatRoom(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId": chatRoomId
      };

      // Below we are creating a chat Room
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder:(context) => ConversationScreen()
      ));
    } else {
      print("You cannot send message to yourself");
    }


  }

  Widget SearchTile({String userName, final String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: simpleTextStyle(),),
                Text(userEmail, style: simpleTextStyle(),)
              ]
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Text("Message", style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }

  @override

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "search username...",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFF),
                            ]
                          ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/search.png")),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoom(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

