import 'package:flutter/material.dart';

import '../journey/journey_intro_flow.dart';

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
  static const _flags = <String>['🇬🇧', '🇹🇷', '🇬🇷'];
  static const _greetings = <String>['Welcome', 'Hoş geldin', 'Καλώς ήρθες'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 760;

          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                child: Image.asset(
                  _assets[_selectedIndex],
                  key: ValueKey(_assets[_selectedIndex]),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => const _FallbackBackground(),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x05000000),
                      Color(0x00000000),
                      Color(0x77000000),
                      Color(0xF0050508),
                    ],
                    stops: [0.0, 0.42, 0.72, 1.0],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 34),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          const _BrandHeader(),
                          SizedBox(height: compact ? 250 : 320),
                          const _SectionTitle(),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: compact ? 142 : 156,
                            child: Row(
                              children: [
                                for (var i = 0; i < _labels.length; i++) ...[
                                  Expanded(
                                    child: _LanguagePhotoCard(
                                      asset: _assets[i],
                                      flag: _flags[i],
                                      label: _labels[i],
                                      selected: i == _selectedIndex,
                                      onTap: () => _select(i),
                                    ),
                                  ),
                                  if (i != _labels.length - 1)
                                    const SizedBox(width: 8),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          _Dots(selectedIndex: _selectedIndex),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: FilledButton(
                              onPressed: _beginJourney,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFF2E9A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Reise beginnt',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          const _BottomMenu(),
                          if (widget.showBuildLabel) ...[
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0.9.5+27 start selector',
                                style: TextStyle(
                                  color: Color(0x88FFFFFF),
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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

  void _select(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  void _beginJourney() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JourneyIntroFlow(
          language: _labels[_selectedIndex],
          flag: _flags[_selectedIndex],
          greeting: _greetings[_selectedIndex],
          backgroundAsset: _assets[_selectedIndex],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.travel_explore_rounded, size: 54, color: Colors.white),
        const SizedBox(height: 4),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
            children: [
              TextSpan(text: 'Reise '),
              TextSpan(text: 'mit', style: TextStyle(color: Color(0xFFFF5BAE))),
              TextSpan(text: ' Worten'),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Container(width: 185, height: 2, color: const Color(0xFFFF2E9A)),
        const SizedBox(height: 10),
        const Text(
          "Don't learn the language.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Live it.',
          style: TextStyle(
            color: Color(0xFFFF5BAE),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0x99FF2E9A), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Sprache auswählen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0x99FF2E9A), thickness: 1)),
      ],
    );
  }
}

class _LanguagePhotoCard extends StatelessWidget {
  final String asset;
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguagePhotoCard({
    required this.asset,
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? const Color(0xFFFF2E9A) : const Color(0xCCFFFFFF),
              width: selected ? 2.4 : 1.2,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x88FF2E9A),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.center),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xCC000000)],
                      stops: [0.42, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: 11,
                  right: 8,
                  bottom: 11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int selectedIndex;

  const _Dots({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == selectedIndex
                ? const Color(0xFFFF2E9A)
                : const Color(0xFF8B8990),
          ),
        );
      }),
    );
  }
}

class _BottomMenu extends StatelessWidget {
  const _BottomMenu();

  @override
  Widget build(BuildContext context) {
    const items = <({IconData icon, String label})>[
      (icon: Icons.menu_book_rounded, label: 'Sprachordner'),
      (icon: Icons.public_rounded, label: 'Reisepass'),
      (icon: Icons.workspace_premium_outlined, label: 'Zertifikate'),
      (icon: Icons.settings_outlined, label: 'Einstellungen'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final item in items)
          Expanded(
            child: Column(
              children: [
                Icon(item.icon, color: Colors.white, size: 26),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
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
          colors: [Color(0xFF1D1230), Color(0xFF080910), Color(0xFF160716)],
        ),
      ),
    );
  }
}
