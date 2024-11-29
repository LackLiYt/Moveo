import 'package:flutter/material.dart';
import '../pages/main_pages/post_page.dart';
import './leaderboard.dart';
import '../pages/main_page/profile_screen.dart';

class ProfileFooter extends StatelessWidget {
  bool ishome;
  bool isboard;
  bool ispost;
  bool isprofile;

  ProfileFooter({required this.ishome, required this.isboard, required this.ispost, required this.isprofile});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(55),
              bottomRight: Radius.circular(55),
            ),
            border: Border(
              top: BorderSide(color: Colors.grey),
            ),
          ),
          child: Container(
            width: 480,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(55),
                bottomRight: Radius.circular(55),
              ),
            ),
            child:Foot_icons(ishome, isboard, ispost, isprofile)
          ),
        ),
    );
  }
}

class Foot_icons extends StatelessWidget{
  bool ishome;
  bool isboard;
  bool ispost;
  bool isprofile;

  Foot_icons(this.ishome, this.isboard, this.ispost, this.isprofile);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[IconButton(
          icon: Icon(
            Icons.home,  // Change icon based on like status
            color: ishome? Color.fromARGB(255, 0, 17, 255): Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed: ishome? () => {} :() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },  // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.language,  // Change icon based on like status
            color: isboard? Color.fromARGB(255, 0, 17, 255): Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed:() => {}
           //isboard?   //:() {
            //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => LeaderboardScreen()),
            //);
          //},  // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.add_box,  // Change icon based on like status
            color: ispost? Color.fromARGB(255, 0, 17, 255): Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed: !ispost? () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          } : () => {},  // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.person,  // Change icon based on like status
            color: Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed: () => {},  // Call _toggleLike method when button is pressed
        )]);
  }
}
