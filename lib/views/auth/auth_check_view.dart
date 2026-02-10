import 'package:flutter/material.dart';
import '../../services/auth_storage_service.dart';
import '../home/home_view.dart';
import 'login_view.dart';

class AuthCheckView extends StatelessWidget {
  const AuthCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthStorageService.getLoggedInUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != null) {
          return HomeView();
        } else {
          return LoginView();
        }
      },
    );
  }
}
