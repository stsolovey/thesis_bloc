// registration_page.dart
import 'package:flutter/material.dart';
import '../api/auth_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_bloc.dart';
import '../routes.dart';
import '../authentication/authentication_bloc.dart';

class RegistrationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final AuthApiService _authApiService;

  RegistrationPage({Key? key, required AuthApiService authApiService})
      : _authApiService = authApiService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocProvider<RegistrationBloc>(
        create: (context) => RegistrationBloc(
          authApiService: _authApiService,
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is RegistrationSuccess) {
              Navigator.pushReplacementNamed(context, AppRoutes.courses);
            }
          },
          builder: (context, state) {
            return _buildRegisterForm(context, state is RegistrationLoading);
          },
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, bool isLoading) {
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
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _register(context),
                    child: const Text('Register'),
                  ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;

      BlocProvider.of<RegistrationBloc>(context)
          .add(Register(username: username, password: password, email: email));
    }
  }
}
