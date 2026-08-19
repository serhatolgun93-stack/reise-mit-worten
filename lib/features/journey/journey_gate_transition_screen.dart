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

class _JourneyGateTransitionScreenState extends State<JourneyGateTransitionScreen>
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
      duration: const Duration(milliseconds: 3400),
    );
    _open = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 4800), _finish);
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
      backgroundColor: const Color(0xFF07070A),
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
            builder: (_, __) => _GateScene(openAmount: _open.value),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                landscape ? 24 : 18,
                landscape ? 10 : 16,
                landscape ? 24 : 18,
                landscape ? 12 : 20,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.travel_explore_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Reise mit Worten',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.flag} ${widget.language}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _open.value > .92 ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: landscape ? 560 : 520),
                      padding: EdgeInsets.symmetric(
                        horizontal: landscape ? 24 : 20,
                        vertical: landscape ? 9 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xB8141318),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0x55FFFFFF)),
                      ),
                      child: Text(
                        _open.value > .42
                            ? 'Deine Reise beginnt, ${widget.name}.'
                            : 'Das Tor zu deiner neuen Sprache öffnet sich …',
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

class _GateScene extends StatelessWidget {
  final double openAmount;

  const _GateScene({required this.openAmount});

  static const double canvasWidth = 1404;
  static const double canvasHeight = 1536;
  static const double doorLeft = 320;
  static const double doorCenter = 702;
  static const double doorRight = 1084;
  static const double doorTop = 405;
  static const double doorBottom = 1130;

  @override
  Widget build(BuildContext context) {
    final fade = (1 - ((openAmount - .86) / .14).clamp(0.0, 1.0));
    final angle = openAmount * (math.pi / 2.7);
    final slitOpacity = ((openAmount - .03) / .14).clamp(0.0, 1.0) *
        (1 - ((openAmount - .18) / .16).clamp(0.0, 1.0));

    return Opacity(
      opacity: fade,
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        child: SizedBox(
          width: canvasWidth,
          height: canvasHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: const _FrameClipper(),
                child: Image.asset(
                  'assets/journey_gate.png',
                  width: canvasWidth,
                  height: canvasHeight,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                left: doorLeft,
                top: doorTop,
                width: doorCenter - doorLeft,
                height: doorBottom - doorTop,
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .0018)
                    ..rotateY(-angle),
                  child: ClipPath(
                    clipper: const _LeftDoorClipper(),
                    child: _DoorCrop(
                      sourceLeft: doorLeft,
                      sourceTop: doorTop,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: doorCenter,
                top: doorTop,
                width: doorRight - doorCenter,
                height: doorBottom - doorTop,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .0018)
                    ..rotateY(angle),
                  child: ClipPath(
                    clipper: const _RightDoorClipper(),
                    child: _DoorCrop(
                      sourceLeft: doorCenter,
                      sourceTop: doorTop,
                    ),
                  ),
                ),
              ),
              if (slitOpacity > 0)
                Positioned(
                  left: doorCenter - 2,
                  top: doorTop + 6,
                  width: 4,
                  height: doorBottom - doorTop - 10,
                  child: Opacity(
                    opacity: slitOpacity,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE6AE),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xCCFFD36A),
                            blurRadius: 18,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoorCrop extends StatelessWidget {
  final double sourceLeft;
  final double sourceTop;

  const _DoorCrop({
    required this.sourceLeft,
    required this.sourceTop,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: _GateScene.canvasWidth,
        maxWidth: _GateScene.canvasWidth,
        minHeight: _GateScene.canvasHeight,
        maxHeight: _GateScene.canvasHeight,
        child: Transform.translate(
          offset: Offset(-sourceLeft, -sourceTop),
          child: Image.asset(
            'assets/journey_gate.png',
            width: _GateScene.canvasWidth,
            height: _GateScene.canvasHeight,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _FrameClipper extends CustomClipper<Path> {
  const _FrameClipper();

  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;
    path.addRect(Offset.zero & size);
    path.moveTo(_GateScene.doorLeft, 492);
    path.quadraticBezierTo(
      _GateScene.doorCenter,
      330,
      _GateScene.doorRight,
      492,
    );
    path.lineTo(_GateScene.doorRight, _GateScene.doorBottom);
    path.lineTo(_GateScene.doorLeft, _GateScene.doorBottom);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _FrameClipper oldClipper) => false;
}

class _LeftDoorClipper extends CustomClipper<Path> {
  const _LeftDoorClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 87)
      ..quadraticBezierTo(size.width * .52, 0, size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _LeftDoorClipper oldClipper) => false;
}

class _RightDoorClipper extends CustomClipper<Path> {
  const _RightDoorClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width * .48, 0, size.width, 87)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _RightDoorClipper oldClipper) => false;
}
