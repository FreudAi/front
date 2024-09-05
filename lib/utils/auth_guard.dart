import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_state.dart';

class AuthGuard extends StatelessWidget {
  final Widget authenticatedRoute;
  final Widget unauthenticatedRoute;

  const AuthGuard({
    required this.authenticatedRoute,
    required this.unauthenticatedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return authState.isAuthenticated ? authenticatedRoute : unauthenticatedRoute;
  }
}