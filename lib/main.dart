import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/auth/firebase_auth_provider.dart';
import 'package:rev/constants/routes.dart';
import 'package:rev/loading/loading_screen.dart';
import 'package:rev/views/authenticationViews/email_verification_view.dart';
import 'package:rev/views/authenticationViews/login_view.dart';
import 'package:rev/views/authenticationViews/register_view.dart';
import 'package:rev/views/authenticationViews/user_info_view.dart';
import 'package:rev/views/bottom_navigation_view.dart';
import 'package:rev/views/create_review_view.dart';
import 'package:rev/views/review_expand.dart';
import 'package:rev/views/splash/splash_screen.dart';

import 'bloc/nav_bloc.dart';
import 'bloc/nav_event.dart';
import 'bloc/nav_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => NavBloc(FirebaseAuthProvider()),
        lazy: false,
        child: const MyHomePage(),
      ),
      routes: {
        userInfoRoute: (context) => const UserInfo(),
        emailVerificationRoute: (context) => EmailVerificationView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        bottomNavigationRoute: (context) => const BottomNavigationView(),
        createReviewRoute: (context) => const CreateReviewView(),
        reviewExpandRoute: (context) => const ReviewExpand(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final provider = AuthService.firebase();
  @override
  Widget build(BuildContext context) {
    context.read<NavBloc>().add(const NavEventInitialize());
    return BlocConsumer<NavBloc, NavState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText);
        } else if (!state.isLoading) {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is NavStateUninitialized) {
          return const SplashScreen();
        } else if (state is NavStateLoggedIn) {
          return const BottomNavigationView();
        } else if (state is NavStateLoggedOut) {
          return const LoginView();
        } else if (state is NavStateDataFetched) {
          return const BottomNavigationView();
        } else if (state is NavStateNotVerified) {
          return EmailVerificationView();
        } else if (state is NavStateRegistering) {
          return const RegisterView();
        } else if (state is NavStateGettingUserData) {
          return const UserInfo();
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
