import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/common/loading_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/view/login_page.dart';
import 'package:moveo/features/auth/widgets/auth_field.dart';
import 'package:moveo/features/auth/widgets/loginsignup_button.dart';
import 'package:moveo/features/auth/widgets/moveo_title.dart';
import 'package:health/health.dart';
import 'dart:async';
import 'package:moveo/features/health/health_data.dart';


class SignUpPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> with  WidgetsBindingObserver{
  @override
  initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialStepData();
    _startPeriodicStepUpdates();
  }


  Timer? _stepUpdateTimer;
  final health = Health();

  int _counter = 0;
  int _getSteps = 0;

  void _startPeriodicStepUpdates() {
    _stopPeriodicStepUpdates();
    print("Запускаємо таймер для оновлення кроків кожні 30 секунд");
    _stepUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      print("Дані про кроки оновлено");

      _loadInitialStepData();
    });
  }

  void _stopPeriodicStepUpdates() {
    if (_stepUpdateTimer != null && _stepUpdateTimer!.isActive) {
      print("Зупиняємо таймер оновлення кроків");
      _stepUpdateTimer!.cancel();
      _stepUpdateTimer = null;
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("Додаток активовано (resumed)");
      _loadInitialStepData();
      _startPeriodicStepUpdates();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      print("Додаток згорнуто (paused)");
      _stopPeriodicStepUpdates();
    }
  }

  final int _page = 0;


  Future<void> _loadInitialStepData() async {
    // Викликаємо функцію з іншого файлу, передаючи наш екземпляр health
    int? steps = await fetchStepData(health);

    // Перевіряємо, чи віджет ще існує перед викликом setState
    if (mounted) {
      setState(() {
        _getSteps = steps ?? 0; // Оновлюємо стан. Якщо steps = null, ставимо 0.
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  final emailController = TextEditingController();
  final passwordController= TextEditingController();
  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
      email: emailController.text,
       password: passwordController.text,
        context: context,
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(body: isLoading ? const Loader() : Center(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            //moveo title
            

            
            const MoveoTitle(),
            const SizedBox(height:75),
          

            
            //login
            AuthField(controller: emailController, hintText: 'Email',),
            const SizedBox(height:20),



            //password
            AuthField(controller: passwordController, hintText:'Password', isPassword: true),
            const SizedBox(height:10),
            


            //sign up button
            const SizedBox(height: 45,),

            LoginButton(label: 'Sign up', onTap:  onSignUp, backgroundColor: const Color(0xFF0437F2), textColor: Colors.white,),

            //don't have an account? Sign up
            const SizedBox(height: 75,),
            RichText(text: TextSpan(
      text: "Already have an account?",
      style: GoogleFonts.montserrat(color:const Color(0xFF0437F2), fontWeight: FontWeight.w600,),
      
      children: [
        TextSpan(text: " Log in", style: GoogleFonts.montserrat(color: const Color(0xFF0437F2),fontWeight: FontWeight.w600,), recognizer: TapGestureRecognizer()..onTap=(){
          Navigator.push(context, LoginPage.route(),);
        })
      ]
    )),




          ]
        ))
       
      )
      
    );
    
  }


}
