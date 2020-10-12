import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatRoomsScreen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp() {
    if(formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'name': userNameTextEditingController.text,
        'email': emailTextEditingController.text
      };

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text.trim(), passwordTextEditingController.text.trim()).then((val){

        // print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));
        // Here we use pushReplacement since we don't want the user to go back to the sign in screen after completing the sign in
        // On the other hand push only will allow the user to backtrack to the earlier screen

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height-50,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return (val.isEmpty || val.length < 2) ? "Please provide a valid username" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("username"),
                      ),
                      TextFormField(

                        validator: (val) {
                          return RegExp(r"^[a-zA-Z0-9,a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter a valid email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.length < 6 ? "Please enter password greater then 6" : null;
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?", style: simpleTextStyle(),),
                  ),
                ),
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: () {
                    // function to be executed when Sign Up button is clicked
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign Up", style: mediumTextStyle(),),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign Up with Google", style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                  ),
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account?", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register now", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
