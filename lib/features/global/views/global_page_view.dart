import 'package:flutter/material.dart';
import 'package:moveo/constants/ui_constants.dart';
import 'package:moveo/features/global/global_images_buttons/events.dart';
import 'package:moveo/features/global/global_images_buttons/hero.dart';
import 'package:moveo/theme/theme.dart';

class GlobalPageView extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const GlobalPageView(),
      );

  const GlobalPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = UiConstants.appBar(context);
    return Scaffold(
      appBar: appBar,
      body: const Page_Items(),
    );
  }
}

class Page_Items extends StatelessWidget {
  const Page_Items({super.key});

  Widget _buildImageButton({
    required String imagePath,
    required VoidCallback onPressed,
    required String text,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildGuildMemberItem({
    required String avatarPath,
    required String username,
    required String role,
    bool isLeader = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(avatarPath),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Text(
                  username,
                  style: theme.textTheme.bodyLarge,
                ),
                if (isLeader) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.emoji_events, color: theme.colorScheme.secondary, size: 18),
                ]
              ],
            ),
          ),
          Text(
            role,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                hintText: 'Search...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // GridView
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildImageButton(
                  imagePath: 'assets/global_photos/events.jpg',
                  onPressed: () {
                    print('Clicked Events');
                    Navigator.push(context, Events_Page.route());
                  },
                  text: 'Events',
                  context: context,
                ),
                _buildImageButton(
                  imagePath: 'assets/global_photos/armory.jpg',
                  onPressed: () => print('Clicked Armory'),
                  text: 'Armory',
                  context: context,
                ),
                _buildImageButton(
                  imagePath: 'assets/global_photos/hero.jpg',
                  onPressed: () {
                    print('Clicked Hero');
                    Navigator.push(context, Hero_Page.route());
                  },
                  text: 'Hero',
                  context: context,
                ),
                _buildImageButton(
                  imagePath: 'assets/global_photos/storage.jpg',
                  onPressed: () => print('Clicked button 4'),
                  text: 'Storage',
                  context: context,
                ),
              ],
            ),
          ),

          Text(
            'GUILD',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 300,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/olena.jpg',
                    username: 'balamutka',
                    role: 'leader',
                    isLeader: true,
                    context: context,
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/bod.jpg',
                    username: 'bodya_lesko',
                    role: 'DD',
                    context: context,
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/ars.jpg',
                    username: 'arsenantoshko',
                    role: 'support',
                    context: context,
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/rost.jpg',
                    username: 'rostyslave',
                    role: 'tank',
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}