import 'package:flutter/material.dart';
import './stats_section.dart';
import './tap_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/main_pages/messages_page.dart';

// StatefulWidget to manage the like button's state

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildUserInfo(),
          _buildContentCard(),
          const SizedBox(height: 17),
          //_mainbuildUserInfo('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', 'Vitalyia')
          _mainbuildUserInfo(
              'https://st2.depositphotos.com/2069237/5489/i/450/depositphotos_54892607-stock-photo-male-runner-in-san-francisco.jpg',
              'Ihor'),
          _mainbuildContentCard(
              'https://st.depositphotos.com/2069237/2227/i/450/depositphotos_22277851-stock-photo-running-male-runner.jpg'),
        ],
      ),
    )));
  }

  Widget _buildUserInfo() {
    return Container(
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    CircularProgressIndicator(), // Loading indicator
                errorWidget: (context, url, error) =>
                    Icon(Icons.error), // Error icon if image fails
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Mark',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(200, 196, 222, 244), // Top border color
              width: 3, // Top border width
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), // Rounded top-left corner
            topRight: Radius.circular(16), // Rounded top-right corner
          ),
        ));
  }

  Widget _buildPatronInfo() {
    return Container(
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    'https://img.tsn.ua/cached/787/tsn-671b840e81dae5015bc4c6345e63d1d0/thumbs/608xX/e2/ce/c755bd501c42746fbd07f058d4edcee2.jpeg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    CircularProgressIndicator(), // Loading indicator
                errorWidget: (context, url, error) =>
                    Icon(Icons.error), // Error icon if image fails
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Пес Патрон',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(200, 196, 222, 244), // Top border color
              width: 3, // Top border width
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), // Rounded top-left corner
            topRight: Radius.circular(16), // Rounded top-right corner
          ),
        ));
  }

  Widget _buildContentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(200, 196, 222, 244), // Top border color
            width: 3, // Top border width
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16), // Rounded top-left corner
          bottomRight: Radius.circular(16), // Rounded top-right corner
        ),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.23,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                    width: 400,
                    height: 500,
                    color: Colors.grey[200],
                    child: ImageTap(
                        url:
                            'https://t3.ftcdn.net/jpg/07/18/67/92/360_F_718679203_1mFavXgopwxYctQHrX9V6GgcX0oZ6OqM.jpg',
                        text: 'Hello')),
                Positioned(
                  bottom: 14,
                  left: 13,
                  right: 27,
                  child: StatsSection(stats: []),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 83,
                height: 30,
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                  // Колір контейнера
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LikeButtonPage(),
              ),
              Container(
                width: 80,
                height: 30,
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(
                  // Колір контейнера
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Comments(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildPatronCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Color.fromARGB(200, 196, 222, 244), // Top border color
          width: 3, // Top border width
        ),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16), // Rounded top-left corner
        bottomRight: Radius.circular(16), // Rounded top-right corner
      ),
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.23,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  width: 400,
                  height: 500,
                  color: Colors.grey[200],
                  child: Image.asset(
                    'patron.jpg',
                    width: 400,
                    height: 500,
                    fit: BoxFit.cover,
                  )),
              const Positioned(
                bottom: 14,
                left: 13,
                right: 27,
                child: StatsSection_parton(),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 90,
              height: 30,
              margin: EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                // Колір контейнера
                borderRadius: BorderRadius.circular(20),
              ),
              child: LikeButtonPage_patron(),
            ),
            Container(
              width: 90,
              height: 30,
              margin: EdgeInsets.only(right: 20, bottom: 10),
              decoration: BoxDecoration(
                // Колір контейнера
                borderRadius: BorderRadius.circular(20),
              ),
              child: Comments_patron(),
            ),
          ],
        ),
      ],
    ),
  );
}

class LikeButtonPage extends StatefulWidget {
  @override
  _LikeButtonPageState createState() => _LikeButtonPageState();
}

// State class where the UI is built and managed
class _LikeButtonPageState extends State<LikeButtonPage> {
  static bool _isLiked = false; // Track the like status

  // Toggle the like status on button press
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // Toggle the like status
    });
  }

  // The 'build' method is required for rendering the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(
          _isLiked
              ? Icons.favorite
              : Icons.favorite_border, // Change icon based on like status
          color: _isLiked
              ? Colors.red
              : Colors.grey, // Change color based on like status
          size: 20.0, // Icon size
        ),
        onPressed:
            _toggleLike, // Call _toggleLike method when button is pressed
      ),
      Container(
        margin: EdgeInsets.only(top: 5),
        child: Text((2000 + (_isLiked ? 1 : 0)).toString()),
      )
    ]);
  }
}

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(
          Icons.comment, // Change icon based on like status
          color: Colors.grey, // Change color based on like status
          size: 20.0, // Icon size
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagesPage()),
          );
        }, // Call _toggleLike method when button is pressed
      ),
      Container(
        margin: EdgeInsets.only(top: 5),
        child: Text('250'),
      )
    ]);
  }
}

class LikeButtonPage_patron extends StatefulWidget {
  @override
  _LikeButtonPageState_patron createState() => _LikeButtonPageState_patron();
}

// State class where the UI is built and managed
class _LikeButtonPageState_patron extends State<LikeButtonPage_patron> {
  static bool _isLiked = false; // Track the like status

  // Toggle the like status on button press
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // Toggle the like status
    });
  }

  // The 'build' method is required for rendering the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(
          _isLiked
              ? Icons.favorite
              : Icons.favorite_border, // Change icon based on like status
          color: _isLiked
              ? Colors.red
              : Colors.grey, // Change color based on like status
          size: 20.0, // Icon size
        ),
        onPressed:
            _toggleLike, // Call _toggleLike method when button is pressed
      ),
      Container(
        margin: EdgeInsets.only(top: 5),
        child: Text((199999 + (_isLiked ? 1 : 0)).toString()),
      )
    ]);
  }
}

class Comments_patron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(
          Icons.comment, // Change icon based on like status
          color: Colors.grey, // Change color based on like status
          size: 20.0, // Icon size
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagesPage()),
          );
        }, // Call _toggleLike method when button is pressed
      ),
      Container(
        margin: EdgeInsets.only(top: 5),
        child: Text('10000'),
      )
    ]);
  }
}

Widget _mainbuildUserInfo(String url, String name) {
  return Container(
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl:
                  url, //'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  CircularProgressIndicator(), // Loading indicator
              errorWidget: (context, url, error) =>
                  Icon(Icons.error), // Error icon if image fails
            ),
          ),
          SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the container
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(200, 196, 222, 244), // Top border color
            width: 3, // Top border width
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), // Rounded top-left corner
          topRight: Radius.circular(16), // Rounded top-right corner
        ),
      ));
}

Widget _mainbuildContentCard(String url) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Color.fromARGB(200, 196, 222, 244), // Top border color
          width: 3, // Top border width
        ),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16), // Rounded top-left corner
        bottomRight: Radius.circular(16), // Rounded top-right corner
      ),
    ),
    child: Column(
      children: [
        AspectRatio(
          aspectRatio: 1.23,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  width: 400,
                  height: 500,
                  color: Colors.grey[200],
                  child: ImageTap(
                      url: url,
                      text:
                          'Your profile') //'https://t3.ftcdn.net/jpg/07/18/67/92/360_F_718679203_1mFavXgopwxYctQHrX9V6GgcX0oZ6OqM.jpg', text:'Hello')
                  ),
              Positioned(
                bottom: 14,
                left: 13,
                right: 27,
                child: StatsSection(stats: []),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 83,
              height: 30,
              margin: EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(
                // Колір контейнера
                borderRadius: BorderRadius.circular(20),
              ),
              child: LikeButtonPage(),
            ),
            Container(
              width: 80,
              height: 30,
              margin: EdgeInsets.only(right: 20, bottom: 10),
              decoration: BoxDecoration(
                // Колір контейнера
                borderRadius: BorderRadius.circular(20),
              ),
              child: Comments(),
            ),
          ],
        ),
      ],
    ),
  );
}
