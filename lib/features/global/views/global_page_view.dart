import 'package:flutter/material.dart';
import 'package:moveo/constants/ui_constants.dart';
import 'package:moveo/features/global/global_images_buttons/events.dart';
import 'package:moveo/features/global/global_images_buttons/hero.dart';


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
  }) {
      return Container(
  width: 60,
  height: 60,
  decoration: BoxDecoration(
    border: Border.all(
      color: const Color.fromARGB(255, 79, 79, 79), // Border color
      width: 1.0,         // Border width
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child:ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child:InkWell(
      onTap: onPressed,
      splashColor: const Color.fromARGB(255, 236, 238, 240).withAlpha(100),
      borderRadius: BorderRadius.circular(12),
      child: Stack( // <--- Додаємо Stack
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset( // <--- Ваше зображення залишається тут, як перший шар
        imagePath,
        fit: BoxFit.cover,
        ),
        Positioned( // <--- Додаємо текст як другий шар, позиціонований
        bottom: 8.0,
        left: 8.0,
        child: Container(
          child:Text(
            text,
            style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0, // Розмір шрифту
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Максимум два рядки для тексту
                    overflow: TextOverflow.ellipsis,),),
        ),
      ],
    )
  )
  )
   );
  }

  Widget _buildGuildMemberItem({
  required String avatarPath,
  required String username,
  required String role,
  bool isLeader = false,
}) {
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
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (isLeader) ...[
                const SizedBox(width: 6),
                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
              ]
            ],
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}





  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // 🔍 Рядок пошуку
        SizedBox(
        height: 40,
        child:TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...',
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: const Color.fromARGB(255, 235, 232, 232)),
            ),
          ),
        ),
        ),
        const SizedBox(height: 16),

        // 🧩 GridView
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
                onPressed: () => {print('Clicked Events'),
                Navigator.push(context, Events_Page.route())
                },
                text: 'Events',
              ),
              _buildImageButton(
                imagePath: 'assets/global_photos/armory.jpg',
                onPressed: () => {print('Clicked Armory'),},
                text: 'Armory',
              ),
              _buildImageButton(
                imagePath: 'assets/global_photos/hero.jpg',
                onPressed: () => {print('Clicked Hero'),
                Navigator.push(context, Hero_Page.route())},
                text: 'Hero',
              ),
              _buildImageButton(
                imagePath: 'assets/global_photos/storage.jpg',
                onPressed: () => print('Clicked button 4'),
                text: 'Storage',
              ),
            ],
          ),
        ),


        const Text(
              'GUILD',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 300,
              child:Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/olena.jpg',
                    username: 'balamutka',
                    role: 'leader',
                    isLeader: true,
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/bod.jpg',
                    username: 'bodya_lesko',
                    role: 'DD',
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/ars.jpg',
                    username: 'arsenantoshko',
                    role: 'support',
                  ),
                  _buildGuildMemberItem(
                    avatarPath: 'assets/global_avatars/rost.jpg',
                    username: 'rostyslave',
                    role: 'tank',
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