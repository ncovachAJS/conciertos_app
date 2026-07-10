import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/splash_progress.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late Animation<Offset> _titleSlideAnimation;

  final AudioPlayer _crowdPlayer = AudioPlayer();

  String _loadingMessage = '';
  double _progress = 0;

  final List<String> _messages = [
    '🎸 Preparando escenario...',
    '🔊 Probando sonido...',
    '💡 Encendiendo las luces...',
    '🎫 Abriendo puertas...',
    '🤘 ¡Que empiece el show!',
  ];

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
    await Future.delayed(const Duration(seconds: 6));

    for (int i = 0; i < _messages.length; i++) {
      if (!mounted) return;

      setState(() {
        _loadingMessage = _messages[i];
        _progress = (i + 1) / _messages.length;
      });

      await Future.delayed(const Duration(milliseconds: 1700));
    }

    await _fadeOutCrowd();

    if (!mounted) return;

    // context.go('/');
  }

  Future<void> _fadeOutCrowd() async {
    double volume = 1.0;

    while (volume > 0) {
      volume -= 0.05;

      if (volume < 0) {
        volume = 0;
      }

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
          // Fondo del escenario
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

          // Capa oscura para mejorar la legibilidad
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.50)),
          ),

          // Contenido principal
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
