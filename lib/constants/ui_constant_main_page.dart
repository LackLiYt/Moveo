import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/features/friends/view/friend_list_view.dart';


class UiConstants {
  static AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
    icon: Icon(Icons.people_alt_outlined),
    onPressed: () {
      Navigator.push(context, FriendListView.route());
    },
  ),
      centerTitle: true, // Align title to the left
      title: SvgPicture.asset(
        // Dynamically choose the title asset based on the theme
        Theme.of(context).brightness == Brightness.light
            ? AssetsConstants.MoveoTitleBlue
            : AssetsConstants.MoveoTitleBlack,
        height: 24, // Make the title smaller
      ),
      actions: [
        // IconButton(\
        //   icon: Icon(\
        //     Icons.chat_bubble_outline,\
        //     color: Theme.of(context).brightness == Brightness.light\
        //         ? Colors.black\
        //         : Colors.white,\
        //   ),\
        //   onPressed: () {\
        //     Navigator.push(context, MaterialPageRoute(\
        //       builder: (context) => const ChatPageView(),\
        //     ));\
        //   },\
        // ),\
        const SizedBox(width: 8), // Add some padding
      ],
    );
  }

}
