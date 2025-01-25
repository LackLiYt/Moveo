import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/features/auth/widgets/moveo_title.dart';
class UiConstants {

  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(AssetsConstants.MoveoTitleBlue,
      ),
    );
  }

  


      title: Text('moveo', style: GoogleFonts.montserrat(color: const Color(0xFF0437F2), fontWeight: FontWeight.bold, fontSize: 35 )),
      leading: const Icon(Icons.people, size: 35, weight: 2,),
      actions: [
        //comments
        Icon(Icons.comment),
        //notifications
        Icon(Icons.notifications),
      ],



      
      centerTitle: true,
      

      
      
      
      );
    
  }
}