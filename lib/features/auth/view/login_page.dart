import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/common/loading_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/view/sign_up_page.dart';
import 'package:moveo/features/auth/widgets/auth_field.dart';
import 'package:moveo/features/auth/widgets/forgot_password.dart';
import 'package:moveo/features/auth/widgets/loginsignup_button.dart';
import 'package:moveo/features/auth/widgets/moveo_title.dart';



class LoginPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});


  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController= TextEditingController();
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
      email: emailController.text,
       password: passwordController.text,
        context: context,
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading ? const Loader() : Center(
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 45),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            //moveo title
            
            MoveoTitle(),
            const SizedBox(height:75),
          
            
            //login
            AuthField(controller: emailController, hintText: 'Email',),
            const SizedBox(height:20),


            //password

            AuthField(controller: passwordController, hintText:'Password',),
            const SizedBox(height:10),

            //forgot password
            Align(child: ForgotPassword(),
            alignment: Alignment.topRight,),
            
            
            

            //login button
            const SizedBox(height: 45,),

            LoginButton(label: 'Log in', onTap: onLogin, backgroundColor: Color(0xFF0437F2), textColor: Colors.white,),

            //don't have an account? Sign up
            SizedBox(height: 75,),
            RichText(text: TextSpan(
      text: "Don't have an account?",
      style: GoogleFonts.montserrat(color:Color(0xFF0437F2), fontWeight: FontWeight.w600,),
      
      children: [
        TextSpan(text: " Sign up", style: GoogleFonts.montserrat(color: Color(0xFF0437F2),fontWeight: FontWeight.w600,), recognizer: TapGestureRecognizer()..onTap=(){
          Navigator.push(context, SignUpPage.route(),);
        })
      ]
    )),




          ]
        ))
       
      )
      
    );
  }
}