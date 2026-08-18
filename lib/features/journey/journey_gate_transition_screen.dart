import 'dart:async';

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
    if (widget.language == 'Türkçe') return 'assets/backgrounds/gate_turkish.jpg';
    if (widget.language == 'Ελληνικά') return 'assets/backgrounds/gate_greek.jpg';
    return 'assets/backgrounds/gate_english.jpg';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
    _open = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _controller.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 2850), _finish);
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
        transitionDuration: const Duration(milliseconds: 520),
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
            builder: (_, __) => _FullscreenGate(
              openAmount: _open.value,
              destinationAsset: _destinationAsset,
            ),
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
                      const Icon(Icons.travel_explore_rounded,
                          color: Colors.white, size: 28),
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
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenGate extends StatelessWidget {
  final double openAmount;
  final String destinationAsset;

  const _FullscreenGate({
    required this.openAmount,
    required this.destinationAsset,
  });

  @override
  Widget build(BuildContext context) {
    final revealOpacity = Curves.easeIn.transform(
      ((openAmount - .18) / .82).clamp(0.0, 1.0),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/journey_gate.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
        Opacity(
          opacity: revealOpacity,
          child: ClipPath(
            clipper: _DoorRevealClipper(openAmount),
            child: Image.asset(
              destinationAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: Opacity(
              opacity: (1 - openAmount * 2.4).clamp(0.0, 1.0),
              child: FractionallySizedBox(
                heightFactor: .55,
                child: Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5A6),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xCCFFD36A),
                        blurRadius: 22,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DoorRevealClipper extends CustomClipper<Path> {
  final double openAmount;

  const _DoorRevealClipper(this.openAmount);

  @override
  Path getClip(Size size) {
    final progress = Curves.easeInOutCubic.transform(openAmount);
    final revealWidth = size.width * progress;
    final left = (size.width - revealWidth) / 2;
    return Path()..addRect(Rect.fromLTWH(left, 0, revealWidth, size.height));
  }

  @override
  bool shouldReclip(covariant _DoorRevealClipper oldClipper) =>
      oldClipper.openAmount != openAmount;
}
