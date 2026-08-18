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
    final gateWidth = landscape ? size.width * .44 : size.width * .80;
    final gateHeight = landscape ? size.height * .78 : size.height * .60;

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
              filterQuality: FilterQuality.high,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x30000000),
                  Color(0x08000000),
                  Color(0x26000000),
                  Color(0x77000000),
                ],
                stops: [0, .28, .68, 1],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: gateWidth,
              height: gateHeight,
              child: AnimatedBuilder(
                animation: _open,
                builder: (context, _) => _Gate(
                  openAmount: _open.value,
                  compact: landscape,
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
                    builder: (context, _) {
                      final opened = _open.value > .42;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 320),
                        opacity: _open.value > .92 ? .72 : 1,
                        child: Container(
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
                            border: Border.all(
                              color: const Color(0x55FFFFFF),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 18,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            opened
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
                      );
                    },
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

class _Gate extends StatelessWidget {
  final double openAmount;
  final bool compact;

  const _Gate({
    required this.openAmount,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(compact ? 28 : 34);
    final frameWidth = compact ? 10.0 : 13.0;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: const Color(0xFFE8D8BA),
              width: frameWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 30,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: Color(0x55FFD99C),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        Positioned(
          top: compact ? -25 : -31,
          left: compact ? 24 : 28,
          right: compact ? 24 : 28,
          child: Container(
            height: compact ? 46 : 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1460A8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE8D8BA),
                width: compact ? 3 : 4,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x66000000), blurRadius: 10),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'REISE MIT WORTEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 14 : 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(frameWidth),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DoorLeaf(
                        left: true,
                        openAmount: openAmount,
                      ),
                    ),
                    Expanded(
                      child: _DoorLeaf(
                        left: false,
                        openAmount: openAmount,
                      ),
                    ),
                  ],
                ),
                IgnorePointer(
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: (1 - openAmount * 1.45).clamp(0.0, 1.0),
                      duration: const Duration(milliseconds: 80),
                      child: Container(
                        width: compact ? 3 : 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE2A8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xCCFFD36A),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
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
  }
}

class _DoorLeaf extends StatelessWidget {
  final bool left;
  final double openAmount;

  const _DoorLeaf({
    required this.left,
    required this.openAmount,
  });

  @override
  Widget build(BuildContext context) {
    final angle = openAmount * (math.pi / 2.15) * (left ? -1 : 1);
    final alignment = left ? Alignment.centerLeft : Alignment.centerRight;

    return Transform(
      alignment: alignment,
      transform: Matrix4.identity()
        ..setEntry(3, 2, .0018)
        ..rotateY(angle),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1767B6),
              borderRadius: BorderRadius.only(
                topLeft: left ? const Radius.circular(18) : Radius.zero,
                bottomLeft: left ? const Radius.circular(18) : Radius.zero,
                topRight: left ? Radius.zero : const Radius.circular(18),
                bottomRight: left ? Radius.zero : const Radius.circular(18),
              ),
              border: Border.all(
                color: const Color(0xFF8ABCE8),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                for (var i = 1; i < 5; i++)
                  Positioned(
                    left: 12,
                    right: 12,
                    top: constraints.maxHeight * (i / 5),
                    child: Container(
                      height: 2,
                      color: const Color(0x558ABCE8),
                    ),
                  ),
                Positioned(
                  right: left ? 12 : null,
                  left: left ? null : 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFD36A),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xAAFFD36A),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
