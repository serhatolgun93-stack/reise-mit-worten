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
      duration: const Duration(milliseconds: 1900),
    );
    _open = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

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
    final gateWidth = landscape ? size.width * .52 : size.width * .92;
    final gateHeight = landscape ? size.height * .84 : size.height * .69;

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
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x26000000),
                  Color(0x08000000),
                  Color(0x18000000),
                  Color(0x66000000),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: gateWidth,
              height: gateHeight,
              child: AnimatedBuilder(
                animation: _open,
                builder: (_, __) => _ApprovedGate(
                  openAmount: _open.value,
                  destinationAsset: _destinationAsset,
                ),
              ),
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
                  AnimatedBuilder(
                    animation: _open,
                    builder: (_, __) => Container(
                      constraints: BoxConstraints(
                        maxWidth: landscape ? 560 : 520,
                      ),
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

class _ApprovedGate extends StatelessWidget {
  final double openAmount;
  final String destinationAsset;

  const _ApprovedGate({
    required this.openAmount,
    required this.destinationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/journey_gate.png',
          fit: BoxFit.contain,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
        ClipPath(
          clipper: _DoorRevealClipper(openAmount),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(23, 185, 23, 86),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(120),
                bottom: Radius.circular(6),
              ),
              child: Image.asset(
                destinationAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: Opacity(
              opacity: (1 - openAmount * 2).clamp(0.0, 1.0),
              child: Container(
                width: 4,
                height: 330,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5A6),
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
    final maxWidth = size.width;
    final revealWidth = maxWidth * progress;
    final left = (maxWidth - revealWidth) / 2;

    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, 0, revealWidth, size.height),
          Radius.circular(size.width * .18),
        ),
      );
  }

  @override
  bool shouldReclip(covariant _DoorRevealClipper oldClipper) =>
      oldClipper.openAmount != openAmount;
}
