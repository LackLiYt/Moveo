import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveo/constants/ui_constants.dart';

class Events_Page extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Events_Page(),
      );

  const Events_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = UiConstants.appBar(context);
    return Scaffold(
      appBar: appBar,
      body: const EventsScreen(),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  Widget _buildEventButton({
    required String imagePath,
    required VoidCallback onPressed,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 79, 79, 79),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          splashColor: const Color.fromARGB(255, 236, 238, 240).withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Guild events:',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        _buildEventButton(
          imagePath: 'assets/global_events/duels.jpg',
          onPressed: () => print('Pressed'),
          text: 'Duel with guild member',
        ),
        const SizedBox(height: 18),
        const Text(
          'Single events:',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 18),
        _buildEventButton(
          imagePath: 'assets/global_events/dungeon.jpg',
          onPressed: () => print('Pressed'),
          text: 'Fight the dungeon in your area',
        ),
        const SizedBox(height: 18),
        _buildEventButton(
          imagePath: 'assets/global_events/race_time.jpg',
          onPressed: () => print('Pressed'),
          text: 'Race against time',
        ),
      ],
    );
  }
}
