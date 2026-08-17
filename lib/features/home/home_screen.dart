import 'package:flutter/material.dart';

import '../journey/guide_selection_screen.dart';

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
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          final w = constraints.maxWidth;
          final landscape = w > h;
          final small = h < 760;
          final cardHeight = landscape
              ? (h * 0.30).clamp(118.0, 170.0)
              : (small ? 132.0 : 158.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Image.asset(
                    _assets[_selectedIndex],
                    key: ValueKey(_assets[_selectedIndex]),
                    width: w,
                    height: h,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const _FallbackBackground(),
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x15000000),
                        Color(0x08000000),
                        Color(0x12000000),
                        Color(0x88000000),
                        Color(0xF2000000),
                      ],
                      stops: [0.0, 0.28, 0.50, 0.72, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    landscape ? 26 : 16,
                    landscape ? 4 : 6,
                    landscape ? 26 : 16,
                    landscape ? 6 : 10,
                  ),
                  child: landscape
                      ? _landscapeContent(cardHeight)
                      : _portraitContent(cardHeight, small),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _portraitContent(double cardHeight, bool small) {
    return Column(
      children: [
        SizedBox(height: small ? 2 : 8),
        const _BrandHeader(),
        const Spacer(flex: 5),
        const _SectionTitle(),
        const SizedBox(height: 10),
        _languageRow(cardHeight),
        const SizedBox(height: 9),
        _Dots(selectedIndex: _selectedIndex),
        const SizedBox(height: 12),
        _startButton(height: small ? 54 : 60),
        const SizedBox(height: 13),
        const _BottomMenu(),
        if (widget.showBuildLabel) const SizedBox(height: 2),
      ],
    );
  }

  Widget _landscapeContent(double cardHeight) {
    return Column(
      children: [
        const SizedBox(height: 2),
        const _BrandHeader(compact: true),
        const Spacer(),
        const _SectionTitle(),
        const SizedBox(height: 6),
        _languageRow(cardHeight),
        const SizedBox(height: 6),
        _Dots(selectedIndex: _selectedIndex),
        const SizedBox(height: 7),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 520,
            child: _startButton(height: 48),
          ),
        ),
      ],
    );
  }

  Widget _languageRow(double cardHeight) {
    return SizedBox(
      height: cardHeight,
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
            if (i != _labels.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _startButton({required double height}) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: _beginJourney,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF2E9A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reise beginnt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward_rounded, size: 25),
          ],
        ),
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
        builder: (_) => GuideSelectionScreen(
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
  final bool compact;
  const _BrandHeader({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.travel_explore_rounded,
          size: compact ? 31 : 48,
          color: Colors.white,
        ),
        SizedBox(height: compact ? 0 : 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 24 : 31,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
              children: const [
                TextSpan(text: 'Reise '),
                TextSpan(
                  text: 'mit',
                  style: TextStyle(color: Color(0xFFFF5BAE)),
                ),
                TextSpan(text: ' Worten'),
              ],
            ),
          ),
        ),
        SizedBox(height: compact ? 3 : 6),
        Container(
          width: compact ? 150 : 190,
          height: 2,
          color: const Color(0xFFFF2E9A),
        ),
        SizedBox(height: compact ? 3 : 8),
        Text(
          "Don't learn the language.",
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 12.5 : 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          'Live it.',
          style: TextStyle(
            color: const Color(0xFFFF5BAE),
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.w900,
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
        Expanded(
          child: Divider(color: Color(0xBFFF2E9A), thickness: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Sprache auswählen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Color(0xBFFF2E9A), thickness: 1),
        ),
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
              color: selected
                  ? const Color(0xFFFF2E9A)
                  : const Color(0xCCFFFFFF),
              width: selected ? 2.6 : 1.2,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0xAAFF2E9A),
                      blurRadius: 17,
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
                Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0xD9000000)],
                      stops: [0.42, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 7,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 27)),
                      const SizedBox(height: 1),
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
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == selectedIndex
                ? const Color(0xFFFF2E9A)
                : const Color(0xFF98969D),
          ),
        ),
      ),
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
      children: [
        for (final item in items)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, color: Colors.white, size: 25),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
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
          colors: [
            Color(0xFF1D1230),
            Color(0xFF080910),
            Color(0xFF160716),
          ],
        ),
      ),
    );
  }
}
