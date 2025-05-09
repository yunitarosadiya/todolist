import 'package:flutter/material.dart';
import 'todopage.dart';

class SplashScreen extends StatefulWidget {
    final VoidCallback onToggleTheme;
    const SplashScreen({super.key, required this.onToggleTheme});

    @override
    State<SplashScreen> createState() => _SplashScreenSate();
}

class _SplashScreenSate extends State<SplashScreen> {
    @override
    void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => TodoPage(onToggleTheme: widget.onToggleTheme,)
                ),
            );
        });
    }

    @override
    Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.blue.shade700,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(Icons.event_note, size: 80, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                            'Agendaku',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Tagesschrift',
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}