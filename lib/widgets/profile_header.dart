import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 49, 20, 19),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoSection(),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Positioned(
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            width: 340,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'moveo',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildMenuSection(),
                ]),
          ),
          _buildFriendsSection(),
        ],
      ),
    );
  }

  Widget _buildFriendsSection() {
    return Column(children: [
      const SizedBox(height: 45),
      Container(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  )),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              )
            ],
          )),
      const SizedBox(height: 17),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(55),
        ),
        child: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ]);
  }

  Widget _buildMenuSection() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications, // Change icon based on like status
            color: Colors.grey, // Change color based on like status
            size: 30.0, // Icon size
          ),
          onPressed: () => {}, // Call _toggleLike method when button is pressed
        ),
        IconButton(
          icon: Icon(
            Icons.chat_bubble_outline, // Change icon based on like status
            color: Colors.grey, // Change color based on like status
            size: 30.0, // Icon size
          ),
          onPressed: () => {}, // Call _toggleLike method when button is pressed
        )
      ],
    );
  }
}
