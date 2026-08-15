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
    'assets/backgrounds/english_london.png',
    'assets/backgrounds/turkish_istanbul.png',
    'assets/backgrounds/greek_santorini.png',
  ];

  static const _labels = <String>['English', 'Türkçe', 'Ελληνικά'];
  static const _subtitles = <String>[
    'London · United Kingdom',
    'İstanbul · Türkiye',
    'Santorini · Ελλάδα',
  ];
  static const _flags = <String>['🇬🇧', '🇹🇷', '🇬🇷'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070B),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final heroHeight = constraints.maxHeight * 0.50;
          final heroGap = constraints.maxHeight * 0.23;

          return Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0xFF07070B)),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: Image.asset(
                    _assets[_selectedIndex],
                    key: ValueKey(_assets[_selectedIndex]),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const _FallbackBackground(),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight + 90,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x22000000),
                        Color(0x33000000),
                        Color(0x9907070B),
                        Color(0xFF07070B),
                      ],
                      stops: [0.0, 0.48, 0.82, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Reise mit Worten',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Center(
                        child: Text(
                          'Deine Reise beginnt mit einem Wort.',
                          style: TextStyle(
                            color: Color(0xFFE5E5EA),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: heroGap),
                      Text(
                        'Willkommen 👋',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.98),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Welche Sprache möchtest du heute erleben?',
                        style: TextStyle(
                          color: Color(0xFFF0F0F3),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 18),
                      for (var i = 0; i < _labels.length; i++) ...[
                        _LanguageCard(
                          flag: _flags[i],
                          label: _labels[i],
                          subtitle: _subtitles[i],
                          selected: i == _selectedIndex,
                          onTap: () => _select(i),
                        ),
                        if (i != _labels.length - 1)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          onPressed: _beginJourney,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFF2E9A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Reise beginnen',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      const _FeatureRow(
                        icon: Icons.route_rounded,
                        title: 'Kapitelweise lernen',
                      ),
                      const SizedBox(height: 9),
                      const _FeatureRow(
                        icon: Icons.picture_as_pdf_rounded,
                        title: 'PDFs & Übungen',
                      ),
                      const SizedBox(height: 9),
                      const _FeatureRow(
                        icon: Icons.workspace_premium_rounded,
                        title: 'Sprach-Reisepass & Zertifikate',
                      ),
                      if (widget.showBuildLabel) ...[
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '0.9.5+22 hero layout',
                            style: TextStyle(
                              color: Color(0x88FFFFFF),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
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

  void _select(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  void _beginJourney() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deine Reise in ${_labels[_selectedIndex]} beginnt.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _FallbackBackground extends StatelessWidget {
  const _FallbackBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF251027), Color(0xFF0A0B14), Color(0xFF160716)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.flight_takeoff_rounded,
          size: 92,
          color: Color(0x33FF2E9A),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.flag,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xDD2A1024)
                : const Color(0xD917171D),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFF2E9A)
                  : const Color(0x665F5F69),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x44FF2E9A),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 25)),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFB7B7C0),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.chevron_right_rounded,
                color: selected
                    ? const Color(0xFFFF2E9A)
                    : const Color(0xFFB7B7C0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: const Color(0xFFFF2E9A)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE3E3E8),
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
