import 'package:flutter/material.dart';
import 'package:studyplusplus/pages/login.page.dart';

class SignUpPage extends StatelessWidget {

	const SignUpPage({super.key});

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
								'Create Account',
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
								hintText: 'Name',
								filled: true,
								fillColor: Colors.purpleAccent[850],
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
							decoration: InputDecoration(
								hintText: 'Email',
								filled: true,
								fillColor: Colors.grey[850],
								hintStyle: const TextStyle(
									color: Colors.white70),
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
								fillColor: Colors.purple[850],
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
								hintText: 'Confirm Password',
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
						const SizedBox(height: 40),
						ElevatedButton(
							onPressed: () {
								// Ação de cadastro
							},
							style: ElevatedButton.styleFrom(
								padding: const EdgeInsets.symmetric(
									vertical: 16),
									shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(12),
								),
								backgroundColor: Colors.purpleAccent, // Cor do botão de cadastro
							),
							child: const Text(
								'Sign Up',
								style: TextStyle(fontSize: 18, color: Colors.white),
							),
						),
						const SizedBox(height: 30),
						const Center(
							child: Text(
								"Already have an account?",
								style: TextStyle(color: Colors.white70),
							),
						),
						Center(
							child: TextButton(
								onPressed: () {
									// Voltar para a tela de login
									Navigator.push(
										context,
										MaterialPageRoute(builder: (context) => LoginPage()),
									);
								},
								child: const Text(
									'Login',
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