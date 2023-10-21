import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/bloc/authentication/authentication_bloc.dart';
import 'package:livestock/page/home/home_page.dart';
import 'package:livestock/page/login/login_page.dart';
import 'package:livestock/page/provimi/provimi_page.dart';
import 'package:livestock/page/purina/purina_page.dart';
import 'package:livestock/page/setting/setting_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => fadeTransition(state, const HomePage()),
      redirect: (context, state) {
        if (context.read<AuthenticationBloc>().state is! LoginState) {
          return '/login';
        }

        return null;
      },
    ),
    GoRoute(
      path: '/login',
      redirect: (context, state) {
        if (context.read<AuthenticationBloc>().state is LoginState) {
          return '/home';
        }

        return null;
      },
      pageBuilder: (context, state) => fadeTransition(state, const LoginPage()),
    ),
    GoRoute(
      path: '/settings',
      redirect: (context, state) {
        if (context.read<AuthenticationBloc>().state is! LoginState) {
          return '/login';
        }

        return null;
      },
      pageBuilder: (context, state) => fadeTransition(state, const SettingPage()),
    ),
    GoRoute(
      path: '/provimi',
      redirect: (context, state) {
        if (context.read<AuthenticationBloc>().state is! LoginState) {
          return '/login';
        }

        return null;
      },
      pageBuilder: (context, state) => fadeTransition(state, const ProvimiPage()),
    ),
    GoRoute(
      path: '/purina',
      redirect: (context, state) {
        if (context.read<AuthenticationBloc>().state is! LoginState) {
          return '/login';
        }

        return null;
      },
      pageBuilder: (context, state) => fadeTransition(state, const PurinaPage()),
    ),
  ],
);

CustomTransitionPage fadeTransition(GoRouterState state, Widget child) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
