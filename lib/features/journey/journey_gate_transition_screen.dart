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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1900));
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
    final gateWidth = landscape ? size.width * .46 : size.width * .82;
    final gateHeight = landscape ? size.height * .76 : size.height * .57;

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _destinationAsset,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => Image.asset(widget.backgroundAsset, fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x26000000), Color(0x08000000), Color(0x20000000), Color(0x66000000)],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: gateWidth,
              height: gateHeight,
              child: AnimatedBuilder(
                animation: _open,
                builder: (_, __) => _GardenGate(openAmount: _open.value, compact: landscape),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(landscape ? 24 : 18, landscape ? 10 : 16, landscape ? 24 : 18, landscape ? 12 : 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      const Expanded(child: Text('Reise mit Worten', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
                      Text('${widget.flag} ${widget.language}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _open,
                    builder: (_, __) => Container(
                      constraints: BoxConstraints(maxWidth: landscape ? 560 : 520),
                      padding: EdgeInsets.symmetric(horizontal: landscape ? 24 : 20, vertical: landscape ? 9 : 12),
                      decoration: BoxDecoration(
                        color: const Color(0xB8141318),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0x55FFFFFF)),
                      ),
                      child: Text(
                        _open.value > .42 ? 'Deine Reise beginnt, ${widget.name}.' : 'Das Tor zu deiner neuen Sprache öffnet sich …',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: landscape ? 14.5 : 16.5, fontWeight: FontWeight.w800),
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

class _GardenGate extends StatelessWidget {
  final double openAmount;
  final bool compact;
  const _GardenGate({required this.openAmount, required this.compact});

  @override
  Widget build(BuildContext context) {
    const metal = Color(0xFF24211D);
    const bronze = Color(0xFFB99155);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(left: 0, top: 28, bottom: 0, width: compact ? 24 : 30, child: _StonePost()),
        Positioned(right: 0, top: 28, bottom: 0, width: compact ? 24 : 30, child: _StonePost()),
        Positioned(
          left: compact ? 14 : 18,
          right: compact ? 14 : 18,
          top: 0,
          height: compact ? 66 : 82,
          child: CustomPaint(painter: _ArchPainter(metal: metal, bronze: bronze)),
        ),
        Positioned(
          left: compact ? 22 : 28,
          right: compact ? 22 : 28,
          top: compact ? 54 : 68,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xE622201D),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: bronze, width: 1.5),
              ),
              child: const Text('REISE MIT WORTEN', style: TextStyle(color: Color(0xFFF4E6C9), fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ),
          ),
        ),
        Positioned.fill(
          top: compact ? 82 : 100,
          left: compact ? 22 : 28,
          right: compact ? 22 : 28,
          bottom: 8,
          child: Row(
            children: [
              Expanded(child: _IronLeaf(left: true, openAmount: openAmount)),
              Expanded(child: _IronLeaf(left: false, openAmount: openAmount)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StonePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFD8C9AE),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFF0E4CC), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x77000000), blurRadius: 12, offset: Offset(0, 5))],
    ),
  );
}

class _IronLeaf extends StatelessWidget {
  final bool left;
  final double openAmount;
  const _IronLeaf({required this.left, required this.openAmount});

  @override
  Widget build(BuildContext context) {
    final angle = openAmount * (math.pi / 2.1) * (left ? -1 : 1);
    return Transform(
      alignment: left ? Alignment.centerLeft : Alignment.centerRight,
      transform: Matrix4.identity()..setEntry(3, 2, .0018)..rotateY(angle),
      child: CustomPaint(
        painter: _IronGatePainter(left: left),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _IronGatePainter extends CustomPainter {
  final bool left;
  const _IronGatePainter({required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final iron = Paint()..color = const Color(0xFF24211D)..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final bronze = Paint()..color = const Color(0xFFB99155)..strokeWidth = 2.2..style = PaintingStyle.stroke;
    final frame = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6));
    canvas.drawRRect(frame, iron);
    final count = size.width < 150 ? 5 : 7;
    for (var i = 1; i < count; i++) {
      final x = size.width * i / count;
      canvas.drawLine(Offset(x, size.height), Offset(x, 28), iron);
      final path = Path()..moveTo(x - 7, 30)..lineTo(x, 8)..lineTo(x + 7, 30);
      canvas.drawPath(path, iron);
    }
    canvas.drawLine(Offset(0, size.height * .34), Offset(size.width, size.height * .34), iron);
    canvas.drawLine(Offset(0, size.height * .68), Offset(size.width, size.height * .68), iron);
    final cx = left ? size.width * .72 : size.width * .28;
    final cy = size.height * .51;
    canvas.drawCircle(Offset(cx, cy), math.min(size.width, size.height) * .14, bronze);
    canvas.drawCircle(Offset(cx, cy), math.min(size.width, size.height) * .08, bronze);
    canvas.drawLine(Offset(cx - 22, cy), Offset(cx + 22, cy), bronze);
    canvas.drawLine(Offset(cx, cy - 22), Offset(cx, cy + 22), bronze);
  }

  @override
  bool shouldRepaint(covariant _IronGatePainter oldDelegate) => false;
}

class _ArchPainter extends CustomPainter {
  final Color metal;
  final Color bronze;
  const _ArchPainter({required this.metal, required this.bronze});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = metal..strokeWidth = 7..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final accent = Paint()..color = bronze..strokeWidth = 2..style = PaintingStyle.stroke;
    final arch = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * .5, -size.height * .72, size.width, size.height);
    canvas.drawPath(arch, p);
    final inner = Path()
      ..moveTo(10, size.height)
      ..quadraticBezierTo(size.width * .5, -size.height * .45, size.width - 10, size.height);
    canvas.drawPath(inner, accent);
  }

  @override
  bool shouldRepaint(covariant _ArchPainter oldDelegate) => false;
}
