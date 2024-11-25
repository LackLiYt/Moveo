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
      child:SingleChildScrollView(
    child: Padding(
    padding: EdgeInsets.all(16),
      child:Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildUserInfo(),
          _buildContentCard(),
          const SizedBox(height: 17),
          _buildPatronInfo(),
          _buildPatronCard(),
        ],
      ),
      )
      )
    );
  }

  Widget _buildUserInfo() {
    return Container(
      child: Row(
        children: [ ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(), // Loading indicator
              errorWidget: (context, url, error) => Icon(Icons.error), // Error icon if image fails
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
              color: Colors.white,  // Background color of the container
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(200, 196, 222, 244),  // Top border color
                  width: 3,  // Top border width
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),  // Rounded top-left corner
                topRight: Radius.circular(16), // Rounded top-right corner
              ),
      )
    );
  }

  Widget _buildPatronInfo() {
    return  Container(
      child: Row(
        children: [ ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://img.tsn.ua/cached/787/tsn-671b840e81dae5015bc4c6345e63d1d0/thumbs/608xX/e2/ce/c755bd501c42746fbd07f058d4edcee2.jpeg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(), // Loading indicator
              errorWidget: (context, url, error) => Icon(Icons.error), // Error icon if image fails
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
              color: Colors.white,  // Background color of the container
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(200, 196, 222, 244),  // Top border color
                  width: 3,  // Top border width
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),  // Rounded top-left corner
                topRight: Radius.circular(16), // Rounded top-right corner
              ),
      )
    );
  }


  Widget _buildContentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(200, 196, 222, 244),  // Top border color
                  width: 3,  // Top border width
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),  // Rounded top-left corner
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
                  child: ImageTap(url:'https://t3.ftcdn.net/jpg/07/18/67/92/360_F_718679203_1mFavXgopwxYctQHrX9V6GgcX0oZ6OqM.jpg', text:'Hello')
                ),
                const Positioned(
                  bottom: 14,
                  left: 13,
                  right: 27,
                  child: StatsSection(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 80,
                height: 30,
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(// Колір контейнера
                borderRadius: BorderRadius.circular(20),),
                child: LikeButtonPage(),
              ),
              Container(
                width: 80,
                height: 30,
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(// Колір контейнера
                borderRadius: BorderRadius.circular(20),),
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
                  color: Color.fromARGB(200, 196, 222, 244),  // Top border color
                  width: 3,  // Top border width
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),  // Rounded top-left corner
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
                  child: Image.asset('patron.jpg',
                  width: 400,
                  height: 500,
                  fit: BoxFit.cover,)
                ),
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
                decoration: BoxDecoration(// Колір контейнера
                borderRadius: BorderRadius.circular(20),),
                child: LikeButtonPage_patron(),
              ),
              Container(
                width: 90,
                height: 30,
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(// Колір контейнера
                borderRadius: BorderRadius.circular(20),),
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
  static bool _isLiked = false;  // Track the like status

  // Toggle the like status on button press
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;  // Toggle the like status
    });
  }

  // The 'build' method is required for rendering the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,  // Change icon based on like status
            color: _isLiked ? Colors.red : Colors.grey,  // Change color based on like status
            size: 20.0,  // Icon size
          ),
          onPressed: _toggleLike,  // Call _toggleLike method when button is pressed
        ),
        Container(
        margin: EdgeInsets.only(top: 5),
        child:Text((2000+(_isLiked ? 1 : 0)).toString()),
        )]);
  }
}

class Comments extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[IconButton(
          icon: Icon(
            Icons.comment,  // Change icon based on like status
            color: Colors.grey,  // Change color based on like status
            size: 20.0,  // Icon size
          ),
          onPressed:  () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagesPage()),
            );
          },  // Call _toggleLike method when button is pressed
        ),
        Container(
        margin: EdgeInsets.only(top: 5),
        child:Text('250'),
        )]);
  }
}

class LikeButtonPage_patron extends StatefulWidget {
  @override
  _LikeButtonPageState_patron createState() => _LikeButtonPageState_patron();
}

// State class where the UI is built and managed
class _LikeButtonPageState_patron extends State<LikeButtonPage_patron> {
  static bool _isLiked = false;  // Track the like status

  // Toggle the like status on button press
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;  // Toggle the like status
    });
  }

  // The 'build' method is required for rendering the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,  // Change icon based on like status
            color: _isLiked ? Colors.red : Colors.grey,  // Change color based on like status
            size: 20.0,  // Icon size
          ),
          onPressed: _toggleLike,  // Call _toggleLike method when button is pressed
        ),
        Container(
        margin: EdgeInsets.only(top: 5),
        child:Text((199999+(_isLiked ? 1 : 0)).toString()),
        )]);
  }
}

class Comments_patron extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[IconButton(
          icon: Icon(
            Icons.comment,  // Change icon based on like status
            color: Colors.grey,  // Change color based on like status
            size: 20.0,  // Icon size
          ),
          onPressed:  () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagesPage()),
            );
          },  // Call _toggleLike method when button is pressed
        ),
        Container(
        margin: EdgeInsets.only(top: 5),
        child:Text('10000'),
        )]);
  }
}

