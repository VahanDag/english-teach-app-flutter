import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/firebase_options.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/repositories/words_repository.dart';
import 'package:teach_app/routers.dart';
import 'package:teach_app/service/firebase_service.dart';
import 'package:teach_app/views/auth/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseService()),
        ChangeNotifierProxyProvider<FirebaseService, UserRepository>(
          create: (context) => UserRepository(context.read<FirebaseService>()),
          update: (context, firebaseService, userRepository) {
            userRepository?.updateService(firebaseService);
            return userRepository!;
          },
        ),
        ChangeNotifierProxyProvider<FirebaseService, WordsRepository>(
          create: (context) => WordsRepository(context.read<FirebaseService>()),
          update: (context, firebaseService, wordsRepository) {
            wordsRepository?.updateService(firebaseService);
            return wordsRepository!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      route();
    });
  }

  Future<void> route() async {
    final user = FirebaseAuth.instance.currentUser != null;
    print("user $user");
    if (user) {
      await context.read<UserRepository>().getUser();
    }
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user ? const Routers() : AuthPage(isRegisterPage: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("DINO"),
      ),
    );
  }
}
