import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  Widget ChatMessageList() {
    // Stream is used for real-time message transmission
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return ListView.builder(
            itemCount: snapshot.data.documents.lenth,
          itemBuilder: (context, index){
          return MessageTile(snapshot.data.documents[index].data["message"]);
          });
      },
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName

      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }

  }
  
  @override
  void initState() {
    print(widget.chatRoomId);
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
//              height: 200,
              alignment: Alignment.bottomCenter,
//              height: 100,
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                decoration: BoxDecoration(
                  color: Color(0x54FFFFFF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Message",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFF),
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}


