import 'package:flutter/material.dart';
import 'package:moveo/appwrite/auth_api.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late String? email;
  late String? username;
  TextEditingController bioTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    email = appwrite.email;
    username = appwrite.username;
    appwrite.getUserPreferences().then((value) {
      if (value.data.isNotEmpty) {
        setState(() {
          bioTextController.text = value.data['bio'];
        });
      }
    });
  }

  savePreferences() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.updatePereferences(bio: bioTextController.text);
    const snackbar = SnackBar(content: Text('Preferences updated!'));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'New post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
