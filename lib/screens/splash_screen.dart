import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    _timer = Timer(
      const Duration(milliseconds: 1500),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6759F5),
              Color(0xFF7B6FF6),
              Color(0xFF5146D8),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),


              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,

                  child: Container(
                    height: 170,
                    width: 170,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(35),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.20),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),

                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(35),

                      child: Image.asset(
                        'asset/images/logo.png',

                        fit: BoxFit.cover,

                        errorBuilder:
                            (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Padding(
                            padding:
                            EdgeInsets.all(25),

                            child: Icon(
                              Icons
                                  .edit_note_rounded,
                              size: 90,
                              color:
                              Color(0xFF6759F5),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

             Spacer(),

              Column(
                children: [
                 SizedBox(
                    height: 25,
                    width: 25,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Your thoughts, always with you',
                    style: TextStyle(
                      color:
                      Colors.white.withOpacity(
                        0.65,
                      ),
                      fontSize: 11,
                    ),
                  ),

                   SizedBox(height: 25),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}