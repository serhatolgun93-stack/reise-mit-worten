import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'journey_dashboard_screen.dart';

class JourneyGateTransitionScreen extends StatefulWidget {
  final String name;
  final String language;
  final String flag;
  final String guideName;
  final String guideKey;
  final String backgroundAsset;

  const JourneyGateTransitionScreen({
    super.key,
    required this.name,
    required this.language,
    required this.flag,
    required this.guideName,
    required this.guideKey,
    required this.backgroundAsset,
  });

  @override
  State<JourneyGateTransitionScreen> createState() =>
      _JourneyGateTransitionScreenState();
}

class _JourneyGateTransitionScreenState
    extends State<JourneyGateTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _finishTimer;

  String get _destinationAsset {
    if (widget.language == 'Türkçe') {
      return 'assets/backgrounds/gate_turkish.jpg';
    }
    if (widget.language == 'Ελληνικά') {
      return 'assets/backgrounds/gate_greek.jpg';
    }
    return 'assets/backgrounds/gate_english.jpg';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 6400), _finish);
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: JourneyDashboardScreen(
            name: widget.name,
            language: widget.language,
            flag: widget.flag,
            guideName: widget.guideName,
            guideKey: widget.guideKey,
            backgroundAsset: widget.backgroundAsset,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050507),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final raw = _controller.value;
          final open = CurvedAnimation(
            parent: _controller,
            curve: const Interval(.18, .80, curve: Curves.easeInOutCubic),
          ).value;
          final portalFade = raw < .90
              ? 1.0
              : (1 - ((raw - .90) / .10)).clamp(0.0, 1.0).toDouble();

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _destinationAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => Image.asset(
                  widget.backgroundAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Opacity(
                opacity: portalFade,
                child: _ReferenceGate(
                  progress: open,
                  rawProgress: raw,
                  destinationAsset: _destinationAsset,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: Column(
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: raw > .88 ? 0 : 1,
                        duration: const Duration(milliseconds: 280),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 560),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xC8151318),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0x55FFFFFF)),
                          ),
                          child: Text(
                            raw < .16
                                ? 'Deine Reise beginnt, ${widget.name}.'
                                : raw < .76
                                    ? 'Das Tor zu deiner neuen Sprache öffnet sich …'
                                    : 'Willkommen in ${widget.language}.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReferenceGate extends StatelessWidget {
  final double progress;
  final double rawProgress;
  final String destinationAsset;

  const _ReferenceGate({
    required this.progress,
    required this.rawProgress,
    required this.destinationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final landscape = w > h;

        final portalWidth = landscape ? math.min(w * .62, h * 1.34) : w * .94;
        final portalHeight = landscape ? h * .94 : h * .90;
        final portalLeft = (w - portalWidth) / 2;
        final portalTop = landscape ? h * .03 : h * .04;

        final doorWidth = portalWidth * .63;
        final doorHeight = portalHeight * .66;
        final doorLeft = portalLeft + (portalWidth - doorWidth) / 2;
        final doorTop = portalTop + portalHeight * .245;
        final leafWidth = doorWidth / 2;
        final angle = progress * (math.pi / 2.18);

        final glowIn = ((rawProgress - .08) / .10).clamp(0.0, 1.0);
        final glowOut = 1 - ((rawProgress - .38) / .16).clamp(0.0, 1.0);
        final glowOpacity = (glowIn * glowOut).toDouble();

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xE8050508)),
            Positioned(
              left: doorLeft,
              top: doorTop,
              width: doorWidth,
              height: doorHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  destinationAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              left: portalLeft,
              top: portalTop,
              width: portalWidth,
              height: portalHeight,
              child: CustomPaint(
                painter: _PortalPainter(),
              ),
            ),
            Positioned(
              left: portalLeft + portalWidth * .31,
              top: portalTop + portalHeight * .07,
              width: portalWidth * .38,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: landscape ? 6 : 8,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xF0121014),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFF332A31)),
                  boxShadow: const [
                    BoxShadow(color: Color(0xAA000000), blurRadius: 18),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'REISE MIT WORTEN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFF4F9D),
                        fontSize: landscape ? 13 : 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .7,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Deine Reise beginnt jetzt.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFE6E0E4),
                        fontSize: landscape ? 8 : 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: doorLeft,
              top: doorTop,
              width: leafWidth,
              height: doorHeight,
              child: Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .0017)
                  ..rotateY(-angle),
                child: const _ReferenceDoorLeaf(leftHalf: true),
              ),
            ),
            Positioned(
              left: doorLeft + leafWidth,
              top: doorTop,
              width: leafWidth,
              height: doorHeight,
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .0017)
                  ..rotateY(angle),
                child: const _ReferenceDoorLeaf(leftHalf: false),
              ),
            ),
            if (glowOpacity > 0)
              Positioned(
                left: w / 2 - 1.5,
                top: doorTop,
                width: 3,
                height: doorHeight,
                child: Opacity(
                  opacity: glowOpacity,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5BAE),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF2E9A),
                          blurRadius: 22,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReferenceDoorLeaf extends StatelessWidget {
  final bool leftHalf;

  const _ReferenceDoorLeaf({required this.leftHalf});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0C10),
          border: Border.all(color: const Color(0xFF29242A), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0xCC000000), blurRadius: 20),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF17151A),
                    Color(0xFF09080B),
                    Color(0xFF141217),
                  ],
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: _BlackDoorPainter())),
            Positioned.fill(
              child: ClipRect(
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: 440,
                  alignment: leftHalf ? Alignment.centerLeft : Alignment.centerRight,
                  child: FractionalTranslation(
                    translation: Offset(leftHalf ? .5 : -.5, 0),
                    child: const SizedBox(
                      width: 340,
                      child: _ReferenceDoorLogo(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceDoorLogo extends StatelessWidget {
  const _ReferenceDoorLogo();

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF5BAE);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 175,
            height: 150,
            child: CustomPaint(painter: _JourneyLogoPainter()),
          ),
          const SizedBox(height: 4),
          const Text(
            'REISE',
            style: TextStyle(
              color: pink,
              fontFamily: 'serif',
              fontSize: 36,
              letterSpacing: 7,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'MIT WORTEN',
            style: TextStyle(
              color: pink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Mut beginnt mit einem Wort.',
            style: TextStyle(
              color: pink,
              fontSize: 8.5,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stone = Paint()..color = const Color(0xFF2A211F);
    final edge = Paint()
      ..color = const Color(0xFF6E4F31)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .018;
    final pink = Paint()
      ..color = const Color(0xFFFF2E9A)
      ..strokeWidth = size.width * .006
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      size.width * .08,
      size.height * .05,
      size.width * .84,
      size.height * .90,
    );
    final arch = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.width * .35)
      ..arcToPoint(
        Offset(rect.right, rect.top + rect.width * .35),
        radius: Radius.circular(rect.width * .50),
        clockwise: true,
      )
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(arch, stone);
    canvas.drawPath(arch, edge);

    canvas.drawLine(
      Offset(size.width * .13, size.height * .31),
      Offset(size.width * .13, size.height * .76),
      pink,
    );
    canvas.drawLine(
      Offset(size.width * .87, size.height * .31),
      Offset(size.width * .87, size.height * .76),
      pink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlackDoorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF322B31)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final inset = size.width * .07;
    final rect = Rect.fromLTWH(
      inset,
      size.height * .04,
      size.width - inset * 2,
      size.height * .92,
    );
    canvas.drawRect(rect, paint);
    for (var i = 1; i <= 3; i++) {
      final x = inset + (rect.width / 4) * i;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), paint);
    }
    canvas.drawLine(
      Offset(inset, size.height * .32),
      Offset(size.width - inset, size.height * .32),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height * .68),
      Offset(size.width - inset, size.height * .68),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _JourneyLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const pink = Color(0xFFFF5BAE);
    final stroke = Paint()
      ..color = pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height * .43;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: size.width * .34),
      math.pi * .10,
      math.pi * 1.80,
      false,
      stroke,
    );

    final mast = Path()
      ..moveTo(cx + 3, size.height * .16)
      ..lineTo(cx + 3, size.height * .63);
    canvas.drawPath(mast, stroke);

    final leftSail = Path()
      ..moveTo(cx - 1, size.height * .22)
      ..lineTo(cx - size.width * .17, size.height * .53)
      ..lineTo(cx - 1, size.height * .58)
      ..close();
    canvas.drawPath(leftSail, stroke);

    final rightSail = Path()
      ..moveTo(cx + 8, size.height * .27)
      ..lineTo(cx + size.width * .20, size.height * .50)
      ..lineTo(cx + 8, size.height * .55)
      ..close();
    canvas.drawPath(rightSail, stroke);

    final bookY = size.height * .68;
    final book = Path()
      ..moveTo(size.width * .15, bookY)
      ..quadraticBezierTo(size.width * .33, bookY - 16, cx, bookY + 3)
      ..quadraticBezierTo(size.width * .67, bookY - 16, size.width * .85, bookY)
      ..moveTo(size.width * .15, bookY + 12)
      ..quadraticBezierTo(size.width * .33, bookY - 2, cx, bookY + 14)
      ..quadraticBezierTo(size.width * .67, bookY - 2, size.width * .85, bookY + 12)
      ..moveTo(size.width * .15, bookY + 24)
      ..quadraticBezierTo(size.width * .33, bookY + 10, cx, bookY + 25)
      ..quadraticBezierTo(size.width * .67, bookY + 10, size.width * .85, bookY + 24);
    canvas.drawPath(book, stroke);

    final bubble = Rect.fromCircle(
      center: Offset(cx, size.height * .87),
      radius: size.width * .10,
    );
    canvas.drawOval(bubble, stroke);
    for (final dx in [-.035, 0.0, .035]) {
      canvas.drawCircle(
        Offset(cx + size.width * dx, size.height * .87),
        2.4,
        Paint()..color = pink,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
