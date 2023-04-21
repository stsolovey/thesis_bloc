import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/auth_api_service.dart';
import '../routes.dart';
import '../storage.dart';
import 'authentication_bloc.dart';

class LoginPage extends StatefulWidget {
  final AuthApiService _authApiService;

  const LoginPage({Key? key, required AuthApiService authApiService})
      : _authApiService = authApiService,
        super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        storageService: StorageService(),
        authApiService: widget._authApiService,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacementNamed(context, AppRoutes.courses);
            }
          },
          child: _buildLoginForm(context),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login(context);
                        }
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.register);
                      },
                      child: const Text('Register'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    try {
      _isLoading.value = true;
      final user = await widget._authApiService.login(username, password);
      authenticationBloc.add(LoggedIn(token: user.token!));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading.value = false;
    }
  }
}
