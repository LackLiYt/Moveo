import 'package:flutter/material.dart';
import '../pages/main_pages/post_page.dart';


class ProfileFooter extends StatelessWidget {
  const ProfileFooter({Key? key}) : super(key: key);

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
            child:Foot_icons()
          ),
        ),
    );
  }
}

class Foot_icons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[IconButton(
          icon: Icon(
            Icons.home,  // Change icon based on like status
            color: const Color.fromARGB(255, 0, 17, 255),  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed: () => {},  // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.language,  // Change icon based on like status
            color: Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed: () => {},  // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.add_box,  // Change icon based on like status
            color: Colors.grey,  // Change color based on like status
            size: 30.0,  // Icon size
          ),
          onPressed:  () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          },  // Call _toggleLike method when button is pressed
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
