import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/supabase/supabase_client.dart';
import 'presentation/screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? bootstrapError;

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    bootstrapError = 'No se pudo cargar el archivo .env: $e';
    debugPrint(bootstrapError);
  }

  if (bootstrapError == null) {
    try {
      await SupabaseConfig.initialize();
    } catch (e) {
      bootstrapError = 'No se pudo inicializar Supabase: $e';
      debugPrint(bootstrapError);
    }
  }

  runApp(
    ProviderScope(
      child: MainApp(bootstrapError: bootstrapError),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.bootstrapError});

  final String? bootstrapError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Pro',
      theme: AppTheme.lightTheme,
      home: bootstrapError == null
          ? const HomeScreen()
          : BootstrapErrorScreen(message: bootstrapError!),
    );
  }
}

class BootstrapErrorScreen extends StatelessWidget {
  const BootstrapErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error de conexion',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
