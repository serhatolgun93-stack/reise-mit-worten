import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool showBuildLabel;
  final String localProfileId;

  const HomeScreen({
    super.key,
    required this.showBuildLabel,
    required this.localProfileId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'Ελληνικά';

  static const _languages = <({
    String label,
    String flag,
    String greeting,
    String subtitle,
    _CountryScene scene,
  })>[
    (
      label: 'English',
      flag: '🇬🇧',
      greeting: 'Welcome',
      subtitle: 'Discover the world in English',
      scene: _CountryScene.london,
    ),
    (
      label: 'Türkçe',
      flag: '🇹🇷',
      greeting: 'Hoş geldin',
      subtitle: 'Dili keşfet, dünyayı keşfet',
      scene: _CountryScene.istanbul,
    ),
    (
      label: 'Ελληνικά',
      flag: '🇬🇷',
      greeting: 'Καλώς ήρθες',
      subtitle: 'Ζήσε τη γλώσσα. Ζήσε την Ελλάδα.',
      scene: _CountryScene.greece,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _languages.firstWhere((item) => item.label == _selectedLanguage);

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 650),
            child: CustomPaint(
              key: ValueKey(selected.scene),
              painter: _CountryBackdropPainter(selected.scene),
              child: const SizedBox.expand(),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.00, 0.28, 0.56, 0.82, 1.00],
                colors: [
                  Color(0x22000000),
                  Color(0x33000000),
                  Color(0xB3050508),
                  Color(0xF208080B),
                  Color(0xFF07070A),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height -
                      MediaQuery.paddingOf(context).vertical -
                      46,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                            children: [
                              TextSpan(text: 'Reise mit ', style: TextStyle(color: Colors.white)),
                              TextSpan(text: 'Worten', style: TextStyle(color: Color(0xFFFF2E9A))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xDDFF2E9A),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(color: Color(0x55FF2E9A), blurRadius: 18, spreadRadius: 1),
                            ],
                          ),
                          child: const Text(
                            'VS1',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 210),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Text(
                        selected.greeting,
                        key: ValueKey(selected.greeting),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFF4FA8),
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Deine Reise beginnt\nmit einem Wort.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        height: 1.04,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                        shadows: [Shadow(color: Colors.black, blurRadius: 16)],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Lerne nicht nur eine Sprache. Erlebe sie.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFE6E1E8),
                        fontSize: 17,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _FlightLine(),
                    const SizedBox(height: 26),
                    const Text(
                      'Welche Sprache möchtest du erleben?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._languages.map((language) {
                      final isSelected = language.label == _selectedLanguage;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => setState(() => _selectedLanguage = language.label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xCC471027), Color(0xAA1B111A)],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xE51B1A20), Color(0xD9121116)],
                                    ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFF2E9A) : const Color(0xFF3A3740),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? const [
                                      BoxShadow(color: Color(0x44FF2E9A), blurRadius: 20, spreadRadius: 1),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(language.flag, style: const TextStyle(fontSize: 30)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        language.label,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        language.subtitle,
                                        style: const TextStyle(
                                          color: Color(0xFFC8C3CC),
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFF2E9A),
                                    ),
                                    child: const Icon(Icons.check_rounded, color: Colors.black, size: 24),
                                  )
                                else
                                  const Icon(Icons.chevron_right_rounded, color: Color(0xFFC9C5CB)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E9A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(62),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        shadowColor: const Color(0x88FF2E9A),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deine Reise in $_selectedLanguage beginnt bald.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.flight_takeoff_rounded, size: 25),
                      label: const Text(
                        'Reise beginnen',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: _Feature(icon: Icons.menu_book_rounded, text: 'Kapitelweise\nlernen')),
                        Expanded(child: _Feature(icon: Icons.description_outlined, text: 'PDFs & Übungen\nfür jede Lektion')),
                        Expanded(child: _Feature(icon: Icons.badge_outlined, text: 'Sprach-Reisepass\n& Zertifikate')),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Englisch · Türkisch · Ελληνικά',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8D8893), fontSize: 13),
                    ),
                    const SizedBox(height: 9),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border_rounded, color: Color(0xFFFF2E9A), size: 18),
                        SizedBox(width: 7),
                        Text('Mit Herz gemacht', style: TextStyle(color: Color(0xFF8D8893), fontSize: 13)),
                      ],
                    ),
                    if (widget.showBuildLabel) ...[
                      const SizedBox(height: 18),
                      const Text(
                        'Interner Entwicklungsstand',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF5F5B67), fontSize: 10.5),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: const Color(0xFFFF2E9A), size: 23),
          const SizedBox(height: 7),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFB5B0B9), fontSize: 10.5, height: 1.35),
          ),
        ],
      );
}

class _FlightLine extends StatelessWidget {
  const _FlightLine();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 34,
        child: CustomPaint(painter: _FlightLinePainter()),
      );
}

class _FlightLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF2E9A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(size.width * 0.30, size.height * 0.38)
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.36,
        size.width * 0.48,
        size.height * 0.78,
        size.width * 0.67,
        size.height * 0.55,
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final extract = metric.extractPath(distance, math.min(distance + 10, metric.length));
        canvas.drawPath(extract, paint);
        distance += 18;
      }
    }
    final plane = TextPainter(
      text: const TextSpan(text: '✈', style: TextStyle(color: Color(0xFFFF2E9A), fontSize: 22)),
      textDirection: TextDirection.ltr,
    )..layout();
    plane.paint(canvas, Offset(size.width * 0.67, size.height * 0.24));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _CountryScene { greece, london, istanbul }

class _CountryBackdropPainter extends CustomPainter {
  final _CountryScene scene;
  _CountryBackdropPainter(this.scene);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sky = switch (scene) {
      _CountryScene.greece => const [Color(0xFF153A67), Color(0xFFF49A78), Color(0xFF8B4A77)],
      _CountryScene.london => const [Color(0xFF173354), Color(0xFFF28A62), Color(0xFF7A445F)],
      _CountryScene.istanbul => const [Color(0xFF18334C), Color(0xFFE77D55), Color(0xFF6D3B54)],
    };
    canvas.drawRect(
      rect,
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: sky).createShader(rect),
    );

    final sun = Paint()..color = const Color(0x44FFE0A0);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.18), size.width * 0.20, sun);

    switch (scene) {
      case _CountryScene.greece:
        _paintGreece(canvas, size);
      case _CountryScene.london:
        _paintLondon(canvas, size);
      case _CountryScene.istanbul:
        _paintIstanbul(canvas, size);
    }
  }

  void _paintGreece(Canvas canvas, Size size) {
    final sea = Paint()..color = const Color(0xCC183C62);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.22, size.width, size.height * 0.33), sea);

    final cliff = Path()
      ..moveTo(0, size.height * 0.43)
      ..lineTo(size.width * 0.20, size.height * 0.35)
      ..lineTo(size.width * 0.33, size.height * 0.40)
      ..lineTo(size.width * 0.48, size.height * 0.31)
      ..lineTo(size.width * 0.70, size.height * 0.37)
      ..lineTo(size.width, size.height * 0.29)
      ..lineTo(size.width, size.height * 0.56)
      ..lineTo(0, size.height * 0.56)
      ..close();
    canvas.drawPath(cliff, Paint()..color = const Color(0xFF5E5060));

    final white = Paint()..color = const Color(0xFFF6F3EE);
    final blue = Paint()..color = const Color(0xFF1768A5);
    for (var i = 0; i < 8; i++) {
      final x = size.width * (0.18 + i * 0.09);
      final y = size.height * (0.30 + (i % 3) * 0.035);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, size.width * 0.11, size.height * 0.07), const Radius.circular(4)),
        white,
      );
    }
    final cx = size.width * 0.58;
    final cy = size.height * 0.31;
    canvas.drawRect(Rect.fromLTWH(cx - 26, cy, 52, 42), white);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: 26), math.pi, math.pi, true, blue);
    canvas.drawRect(Rect.fromLTWH(cx - 3, cy - 43, 6, 18), Paint()..color = Colors.white);
  }

  void _paintLondon(Canvas canvas, Size size) {
    final silhouette = Paint()..color = const Color(0xE61A1720);
    final ground = Path()
      ..moveTo(0, size.height * 0.44)
      ..lineTo(size.width, size.height * 0.39)
      ..lineTo(size.width, size.height * 0.56)
      ..lineTo(0, size.height * 0.56)
      ..close();
    canvas.drawPath(ground, silhouette);

    final x = size.width * 0.66;
    final top = size.height * 0.15;
    canvas.drawRect(Rect.fromLTWH(x, top + 44, size.width * 0.10, size.height * 0.29), silhouette);
    final spire = Path()
      ..moveTo(x + size.width * 0.05, top)
      ..lineTo(x + size.width * 0.02, top + 48)
      ..lineTo(x + size.width * 0.08, top + 48)
      ..close();
    canvas.drawPath(spire, silhouette);
    canvas.drawCircle(Offset(x + size.width * 0.05, top + 92), size.width * 0.027, Paint()..color = const Color(0xFFEACD9A));

    canvas.drawRect(Rect.fromLTWH(size.width * 0.08, size.height * 0.35, size.width * 0.48, size.height * 0.08), silhouette);
    for (var i = 0; i < 5; i++) {
      canvas.drawRect(Rect.fromLTWH(size.width * (0.10 + i * 0.09), size.height * 0.30, size.width * 0.035, size.height * 0.05), silhouette);
    }
    final bus = Paint()..color = const Color(0xFFE32636);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.14, size.height * 0.41, size.width * 0.16, size.height * 0.06), const Radius.circular(5)),
      bus,
    );
  }

  void _paintIstanbul(Canvas canvas, Size size) {
    final silhouette = Paint()..color = const Color(0xE61A1820);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.43, size.width, size.height * 0.13), silhouette);

    final center = Offset(size.width * 0.52, size.height * 0.35);
    canvas.drawArc(Rect.fromCenter(center: center, width: size.width * 0.28, height: size.height * 0.16), math.pi, math.pi, true, silhouette);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.38, size.height * 0.35, size.width * 0.28, size.height * 0.11), silhouette);

    for (final x in [0.28, 0.73]) {
      canvas.drawRect(Rect.fromLTWH(size.width * x, size.height * 0.22, size.width * 0.025, size.height * 0.23), silhouette);
      final minaret = Path()
        ..moveTo(size.width * (x + 0.0125), size.height * 0.15)
        ..lineTo(size.width * x, size.height * 0.23)
        ..lineTo(size.width * (x + 0.025), size.height * 0.23)
        ..close();
      canvas.drawPath(minaret, silhouette);
    }
    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width * 0.52, size.height * 0.32), width: size.width * 0.18, height: size.height * 0.09),
      math.pi,
      math.pi,
      true,
      silhouette,
    );
  }

  @override
  bool shouldRepaint(covariant _CountryBackdropPainter oldDelegate) => oldDelegate.scene != scene;
}
