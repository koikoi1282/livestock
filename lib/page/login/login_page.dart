import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:livestock/bloc/authentication/authentication_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/utils/image_utils.dart';
import 'package:livestock/widget/general_background.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final TextEditingController emailAddressController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: context.read<AuthenticationBloc>(),
      listener: (context, state) {
        if (state is AuthenticationErrorState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(state.message),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 4,
                );
              });
        } else if (state is LoginState) {
          GoRouter.of(context).go('/home');
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: context.read<AuthenticationBloc>(),
        builder: (context, state) {
          if (state is LogoutState) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Scaffold(
                appBar: AppBar(automaticallyImplyLeading: false),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: imageMap['provimi']!,
                                      width: 250,
                                    ),
                                    const SizedBox(width: 50),
                                    Image(
                                      image: imageMap['purina']!,
                                      width: 250,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  width: 400,
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: '帳號', border: OutlineInputBorder()),
                                    controller: emailAddressController,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return '不可為空';
                                      }

                                      if (!(value?.contains('@') ?? true)) {
                                        return '請填入email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 400,
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: '密碼', border: OutlineInputBorder()),
                                    controller: passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return '不可為空';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<AuthenticationBloc>().add(LogInEvent(
                                          emailAddress: emailAddressController.text,
                                          password: passwordController.text));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(200, 60),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      backgroundColor: primaryGreen),
                                  child: const Text(
                                    '登入',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const GeneralBackground(),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
