import 'package:audioplayers/audioplayers.dart';
import 'package:conciertos_app/core/initialization/app_initializer.dart';
import 'package:conciertos_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:conciertos_app/features/concerts/presentation/providers/concerts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../widgets/splash_progress.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _titleSlideAnimation;

  final AudioPlayer _crowdPlayer = AudioPlayer();
  final _authController = AuthController.instance;

  // AppInitializer recibe un callback que pre-calienta el provider.
  // Con ref.read(concertsProvider.future) el notifier arranca build()
  // y la lista queda en caché para el resto de la app.
  late final AppInitializer _initializer = AppInitializer(
    onLoadConcerts: () => ref.read(concertsProvider.future),
  );

  String _loadingMessage = '';
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _playCrowd();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
    _startLoadingSequence();
  }

  Future<void> _playCrowd() async {
    try {
      await _crowdPlayer.setReleaseMode(ReleaseMode.stop);
      await _crowdPlayer.setVolume(1.0);
      await _crowdPlayer.play(AssetSource('audio/crowd.mp3'));
    } catch (e) {
      debugPrint('ERROR CROWD: $e');
    }
  }

  Future<void> _startLoadingSequence() async {
    await _initializer.initialize(
      onProgress: (message, progress) {
        if (!mounted) return;
        setState(() {
          _loadingMessage = message;
          _progress = progress;
        });
      },
    );

    await _fadeOutCrowd();

    if (!mounted) return;
    context.go('/');
  }

  Future<void> _fadeOutCrowd() async {
    double volume = 1.0;
    while (volume > 0) {
      volume = (volume - 0.05).clamp(0, 1);
      await _crowdPlayer.setVolume(volume);
      await Future.delayed(const Duration(milliseconds: 150));
    }
    await _crowdPlayer.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _crowdPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _titleSlideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/stage_background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.50)),
          ),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'LA VIDA\n',
                                  style: GoogleFonts.teko(
                                    fontSize: 68,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 0.85,
                                    letterSpacing: 2,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 20,
                                        color: Colors.black87,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: 'EN DIRECTO',
                                  style: GoogleFonts.teko(
                                    fontSize: 62,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFB300),
                                    height: 0.85,
                                    letterSpacing: 2,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 20,
                                        color: Colors.black87,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Cada concierto cuenta una historia.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              color: Colors.white70,
                              letterSpacing: .6,
                              shadows: const [
                                Shadow(blurRadius: 10, color: Colors.black87),
                              ],
                            ),
                          ),

                          const SizedBox(height: 65),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              _loadingMessage,
                              key: ValueKey(_loadingMessage),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                fontSize: 22,
                                color: Colors.white,
                                letterSpacing: .5,
                                shadows: const [
                                  Shadow(blurRadius: 10, color: Colors.black87),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          SplashProgress(progress: _progress),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
