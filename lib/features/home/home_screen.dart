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
  int _selectedIndex = 2;

  static const _assets = <String>[
    'assets/screens/english.jpg',
    'assets/screens/turkish.jpg',
    'assets/screens/greek.jpg',
  ];

  static const _labels = <String>['English', 'Türkçe', 'Ελληνικά'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Image.asset(
                  _assets[_selectedIndex],
                  key: ValueKey(_selectedIndex),
                  width: w,
                  height: h,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              _TapZone(top: h * 0.515, left: w * 0.045, width: w * 0.91, height: h * 0.078, semanticLabel: 'Englisch auswählen', onTap: () => _select(0)),
              _TapZone(top: h * 0.605, left: w * 0.045, width: w * 0.91, height: h * 0.078, semanticLabel: 'Türkisch auswählen', onTap: () => _select(1)),
              _TapZone(top: h * 0.690, left: w * 0.045, width: w * 0.91, height: h * 0.082, semanticLabel: 'Griechisch auswählen', onTap: () => _select(2)),
              _TapZone(top: h * 0.785, left: w * 0.045, width: w * 0.91, height: h * 0.075, semanticLabel: 'Reise beginnen', onTap: _beginJourney),
              if (widget.showBuildLabel)
                Positioned(
                  right: 8,
                  bottom: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: const Color(0xAA000000), borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      child: Text('0.9.5 Foto-Preview', style: TextStyle(color: Color(0x99FFFFFF), fontSize: 9)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _select(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  void _beginJourney() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deine Reise in ${_labels[_selectedIndex]} beginnt.'), behavior: SnackBarBehavior.floating),
    );
  }
}

class _TapZone extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final double height;
  final String semanticLabel;
  final VoidCallback onTap;

  const _TapZone({required this.top, required this.left, required this.width, required this.height, required this.semanticLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0x33FF2E9A),
            highlightColor: const Color(0x22FF2E9A),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
