import 'package:flutter/material.dart';
import 'package:studyplusplus/pages/signup.page.dart';

class LoginPage extends StatelessWidget {

	const LoginPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.black87,
			appBar: AppBar(
				backgroundColor: Colors.black87,
				leading: IconButton(
					icon: const Icon(Icons.arrow_back, color: Colors.white),
					onPressed: () {
						Navigator.pop(context);
					},
				),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					const Center(
						child: Text(
							'Welcome Back!',
							style: TextStyle(
								color: Colors.white,
								fontSize: 32,
								fontWeight: FontWeight.bold,
							),
						),
					),
					const SizedBox(height: 40),
					TextFormField(
						decoration: InputDecoration(
							hintText: 'Email',
							filled: true,
							fillColor: Colors.grey[850],
							hintStyle: const TextStyle(color: Colors.white70),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(12),
								borderSide: BorderSide.none,
							),
						),
						style: const TextStyle(color: Colors.white),
					),
					const SizedBox(height: 20),
					TextFormField(
						obscureText: true,
						decoration: InputDecoration(
							hintText: 'Password',
							filled: true,
							fillColor: Colors.grey[850],
							hintStyle: const TextStyle(color: Colors.white70),
							border: OutlineInputBorder(
							borderRadius: BorderRadius.circular(12),
							borderSide: BorderSide.none,
							),
						),
						style: const TextStyle(color: Colors.white),
					),
					const SizedBox(height: 20),
					Align(
						alignment: Alignment.centerRight,
						child: TextButton(
							onPressed: () {
								// Ação de "Esqueci minha senha"
							},
							child: const Text(
								'Forgot Password?',
								style: TextStyle(color: Colors.purple),
							),
						),
					),
					const SizedBox(height: 20),
					ElevatedButton(
						onPressed: () {
							// Ação de login
						},
						style: ElevatedButton.styleFrom(
							backgroundColor: Colors.purple, // Cor do botão de login
							padding: const EdgeInsets.symmetric(vertical: 16),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
						child: const Text(
							'Login',
							style: TextStyle(fontSize: 18, color: Colors.white),
						),
					),
					const SizedBox(height: 30),
					const Center(
						child: Text(
							"Don't have an account?",
							style: TextStyle(color: Colors.white70),
						),
					),
					Center(
						child: TextButton(
							onPressed: () {
								// Navegar para a tela de cadastro
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => const SignUpPage()),
								);
							},
							child: const Text(
								'Sign Up',
								style: TextStyle(color: Colors.purple),
							),
						),
					),
				],
				),
			),
		);
	}
}