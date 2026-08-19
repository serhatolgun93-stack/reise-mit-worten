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
  late final Animation<double> _open;
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
      duration: const Duration(milliseconds: 3600),
    );
    _open = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 5000), _finish);
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
        transitionDuration: const Duration(milliseconds: 650),
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
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width > size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF050507),
      body: Stack(
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
          AnimatedBuilder(
            animation: _open,
            builder: (_, __) => _JourneyDoubleDoor(
              progress: _open.value,
              landscape: landscape,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                landscape ? 18 : 14,
                landscape ? 8 : 12,
                landscape ? 18 : 14,
                landscape ? 10 : 18,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _open.value > .92 ? 0 : 1,
                    duration: const Duration(milliseconds: 260),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: landscape ? 560 : 520,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: landscape ? 22 : 20,
                        vertical: landscape ? 9 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xC4151418),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0x55FFFFFF)),
                      ),
                      child: Text(
                        _open.value < .08
                            ? 'Deine Reise beginnt, ${widget.name}.'
                            : _open.value < .72
                                ? 'Das Tor öffnet sich …'
                                : 'Willkommen in ${widget.language}.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: landscape ? 14.5 : 16.5,
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
      ),
    );
  }
}

class _JourneyDoubleDoor extends StatelessWidget {
  final double progress;
  final bool landscape;

  const _JourneyDoubleDoor({
    required this.progress,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    final p = Curves.easeInOutCubic.transform(progress);
    final shellOpacity =
        (1 - ((p - .90) / .10).clamp(0.0, 1.0)).toDouble();
    final glowOpacity = (((p - .02) / .13).clamp(0.0, 1.0) *
            (1 - ((p - .32) / .18).clamp(0.0, 1.0)))
        .toDouble();
    final angle = p * (math.pi / 2.18);

    return Opacity(
      opacity: shellOpacity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final side = landscape ? w * .055 : w * .045;
          final top = landscape ? h * .075 : h * .085;
          final bottom = landscape ? h * .055 : h * .075;
          final openingLeft = side;
          final openingTop = top;
          final openingWidth = w - side * 2;
          final openingHeight = h - top - bottom;
          final leafWidth = openingWidth / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0x66000000)),
              Positioned(
                left: openingLeft,
                top: openingTop,
                width: openingWidth,
                height: openingHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2A272D),
                      width: landscape ? 14 : 11,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xAA000000),
                        blurRadius: 28,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: openingLeft,
                top: openingTop,
                width: leafWidth,
                height: openingHeight,
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0016)
                    ..rotateY(-angle),
                  child: const _DoorLeaf(isLeft: true),
                ),
              ),
              Positioned(
                left: openingLeft + leafWidth,
                top: openingTop,
                width: leafWidth,
                height: openingHeight,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0016)
                    ..rotateY(angle),
                  child: const _DoorLeaf(isLeft: false),
                ),
              ),
              if (glowOpacity > 0)
                Positioned(
                  left: w / 2 - 1.5,
                  top: openingTop + openingHeight * .08,
                  width: 3,
                  height: openingHeight * .84,
                  child: Opacity(
                    opacity: glowOpacity,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF4FA5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xCCFF2E9A),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: side * .28,
                top: openingTop + openingHeight * .08,
                width: 5,
                height: openingHeight * .78,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF2E9A),
                    boxShadow: [
                      BoxShadow(color: Color(0xAAFF2E9A), blurRadius: 12),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: side * .28,
                top: openingTop + openingHeight * .08,
                width: 5,
                height: openingHeight * .78,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF2E9A),
                    boxShadow: [
                      BoxShadow(color: Color(0xAAFF2E9A), blurRadius: 12),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: w * .23,
                right: w * .23,
                top: landscape ? h * .028 : h * .038,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: landscape ? 16 : 12,
                    vertical: landscape ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xEE151318),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF4A424D)),
                    boxShadow: const [
                      BoxShadow(color: Color(0x66000000), blurRadius: 18),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'REISE MIT WORTEN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFFF5BAE),
                          fontSize: landscape ? 17 : 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Deine Reise beginnt jetzt.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFE7DFE6),
                          fontSize: landscape ? 10 : 9.5,
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

class _DoorLeaf extends StatelessWidget {
  final bool isLeft;

  const _DoorLeaf({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF171419),
        border: Border.all(color: const Color(0xFF383039), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xAA000000), blurRadius: 18),
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
                  Color(0xFF262028),
                  Color(0xFF121014),
                  Color(0xFF1D181F),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _DoorPanelPainter()),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(isLeft ? 30 : -30, 0),
              child: const Icon(
                Icons.travel_explore_rounded,
                size: 92,
                color: Color(0xFFFF5BAE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoorPanelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A3E49)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final inset = size.width * .08;
    final rect = Rect.fromLTWH(
      inset,
      size.height * .08,
      size.width - inset * 2,
      size.height * .84,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height * .34),
      Offset(size.width - inset, size.height * .34),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height * .66),
      Offset(size.width - inset, size.height * .66),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
