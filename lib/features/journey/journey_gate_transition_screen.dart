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
  State<JourneyGateTransitionScreen> createState() => _JourneyGateTransitionScreenState();
}

class _JourneyGateTransitionScreenState extends State<JourneyGateTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _finishTimer;

  String get _destinationAsset {
    if (widget.language == 'Türkçe') return 'assets/backgrounds/gate_turkish.jpg';
    if (widget.language == 'Ελληνικά') return 'assets/backgrounds/gate_greek.jpg';
    return 'assets/backgrounds/gate_english.jpg';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4700),
    );
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 6200), _finish);
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
        transitionDuration: const Duration(milliseconds: 550),
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
          final p = Curves.easeInOutCubic.transform(_controller.value);
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
              _ApprovedGate(progress: p, destinationAsset: _destinationAsset),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: Column(
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: p > .88 ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 560),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xC8151318),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0x55FFFFFF)),
                          ),
                          child: Text(
                            p < .10
                                ? 'Deine Reise beginnt, ${widget.name}.'
                                : p < .72
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

class _ApprovedGate extends StatelessWidget {
  final double progress;
  final String destinationAsset;

  const _ApprovedGate({required this.progress, required this.destinationAsset});

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);
    final fade = (1 - ((p - .94) / .06).clamp(0.0, 1.0)).toDouble();
    final angle = p * (math.pi / 2.12);
    final glowIn = ((p - .03) / .10).clamp(0.0, 1.0);
    final glowOut = 1 - ((p - .30) / .18).clamp(0.0, 1.0);
    final glow = (glowIn * glowOut).toDouble();

    return Opacity(
      opacity: fade,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final landscape = w > h;

          final doorW = landscape ? math.min(w * .44, h * .80) : w * .72;
          final doorH = landscape ? h * .70 : h * .59;
          final doorLeft = (w - doorW) / 2;
          final doorTop = landscape ? h * .235 : h * .355;
          final leafW = doorW / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/journey_gate.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),

              // The country scene is visible only through the actual doorway.
              Positioned(
                left: doorLeft,
                top: doorTop,
                width: doorW,
                height: doorH,
                child: ClipRect(
                  child: Image.asset(
                    destinationAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),

              Positioned(
                left: doorLeft,
                top: doorTop,
                width: leafW,
                height: doorH,
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .0016)
                    ..rotateY(-angle),
                  child: const _DoorLeaf(leftHalf: true),
                ),
              ),
              Positioned(
                left: doorLeft + leafW,
                top: doorTop,
                width: leafW,
                height: doorH,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .0016)
                    ..rotateY(angle),
                  child: const _DoorLeaf(leftHalf: false),
                ),
              ),

              if (glow > 0)
                Positioned(
                  left: w / 2 - 1.5,
                  top: doorTop + doorH * .035,
                  width: 3,
                  height: doorH * .93,
                  child: Opacity(
                    opacity: glow,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF4FA5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xDDFF2E9A),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
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
  final bool leftHalf;

  const _DoorLeaf({required this.leftHalf});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF171419),
          border: Border.all(color: const Color(0xFF3D303A), width: 1.4),
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF242027),
                    Color(0xFF151216),
                    Color(0xFF0D0B0E),
                  ],
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: _DoorPanelPainter())),
            Positioned.fill(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: double.infinity,
                alignment: leftHalf ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionalTranslation(
                  translation: Offset(leftHalf ? .5 : -.5, 0),
                  child: const SizedBox(
                    width: 320,
                    child: _SplitDoorLogo(),
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

class _SplitDoorLogo extends StatelessWidget {
  const _SplitDoorLogo();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFF5BAE), width: 3),
                  ),
                ),
                const Positioned(
                  top: 10,
                  child: Icon(Icons.sailing_rounded, color: Color(0xFFFF5BAE), size: 70),
                ),
                const Positioned(
                  bottom: 8,
                  child: Icon(Icons.menu_book_rounded, color: Color(0xFFFF5BAE), size: 78),
                ),
                const Positioned(
                  bottom: 4,
                  child: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFFF5BAE), size: 31),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'REISE',
            style: TextStyle(
              color: Color(0xFFFF5BAE),
              fontSize: 33,
              height: 1,
              letterSpacing: 7,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'MIT WORTEN',
            style: TextStyle(
              color: Color(0xFFFF5BAE),
              fontSize: 12,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
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
      ..color = const Color(0xFF4B3A46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final inset = size.width * .08;
    final rect = Rect.fromLTWH(
      inset,
      size.height * .06,
      size.width - inset * 2,
      size.height * .88,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(7)),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height * .34),
      Offset(size.width - inset, size.height * .34),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height * .67),
      Offset(size.width - inset, size.height * .67),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
