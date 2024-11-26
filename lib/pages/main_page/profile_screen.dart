import 'package:flutter/material.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_content.dart';
import '../../widgets/profile_footer.dart';
import '../../widgets/stats_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(55),
            ),
            child: Column(
              children: <Widget>[ProfileHeader(),
                    Expanded(
                      child:ProfileContent(),
                    ),
                    ProfileFooter(ishome: true,isboard: false,ispost: false,isprofile: false,),
              ]
              ),
            ),
          ),
        ),
      );
  }
}