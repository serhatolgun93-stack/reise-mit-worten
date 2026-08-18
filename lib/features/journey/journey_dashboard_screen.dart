import 'package:flutter/material.dart';

class JourneyDashboardScreen extends StatelessWidget {
  final String name;
  final String language;
  final String flag;
  final String guideName;
  final String guideKey;
  final String backgroundAsset;

  const JourneyDashboardScreen({
    super.key,
    required this.name,
    required this.language,
    required this.flag,
    required this.guideName,
    required this.guideKey,
    required this.backgroundAsset,
  });

  bool get _isLeon => guideKey == 'leon';

  String get _guideAsset => _isLeon
      ? 'assets/characters/leon_invite.png'
      : 'assets/characters/maria_welcome.png';

  String get _chapterTitle {
    if (language == 'Türkçe') return 'Ankommen & Begrüßen';
    if (language == 'Ελληνικά') return 'Άφιξη & Χαιρετισμοί';
    return 'Arriving & Greetings';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width > size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF09090C)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x22000000),
                  Color(0x33000000),
                  Color(0xA8000000),
                  Color(0xF0000000),
                ],
                stops: [0.0, 0.38, 0.72, 1.0],
              ),
            ),
          ),
          Positioned(
            left: landscape ? -10 : -34,
            bottom: landscape ? -18 : 72,
            child: IgnorePointer(
              child: SizedBox(
                width: landscape ? size.width * .30 : size.width * .48,
                height: landscape ? size.height * .82 : size.height * .48,
                child: Image.asset(
                  _guideAsset,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomLeft,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                landscape ? 26 : 18,
                landscape ? 10 : 16,
                landscape ? 26 : 18,
                landscape ? 12 : 18,
              ),
              child: landscape
                  ? _landscapeContent(context, size)
                  : _portraitContent(context, size),
            ),
          ),
        ],
      ),
    );
  }

  Widget _portraitContent(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width * .69,
            child: _mainCard(context, compact: false),
          ),
        ),
        const SizedBox(height: 14),
        _quickAccess(compact: false),
      ],
    );
  }

  Widget _landscapeContent(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width * .58,
            child: _mainCard(context, compact: true),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width * .58,
            child: _quickAccess(compact: true),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 30),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Reise mit Worten',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '$flag  $language',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _mainCard(BuildContext context, {required bool compact}) {
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 19),
      decoration: BoxDecoration(
        color: const Color(0xE817161A),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x44FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x77000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEINE REISE',
            style: TextStyle(
              color: const Color(0xFFFF5BAE),
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Willkommen, $name!',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 25 : 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$guideName begleitet dich. Heute beginnt dein erstes Kapitel.',
            style: TextStyle(
              color: const Color(0xFFF0EAF0),
              fontSize: compact ? 11.5 : 13,
              height: 1.3,
            ),
          ),
          SizedBox(height: compact ? 10 : 14),
          Container(
            padding: EdgeInsets.all(compact ? 12 : 14),
            decoration: BoxDecoration(
              color: const Color(0xD91E1C22),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x66FFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0x33FF2E9A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        color: Color(0xFFFF2E9A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kapitel 1',
                            style: TextStyle(
                              color: Color(0xFFFF5BAE),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            _chapterTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: compact ? 17 : 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const LinearProgressIndicator(
                    value: 0,
                    minHeight: 7,
                    backgroundColor: Color(0xFF3B373E),
                    valueColor: AlwaysStoppedAnimation(Color(0xFFFF2E9A)),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '0 % abgeschlossen',
                  style: TextStyle(color: Color(0xFFD8D0D7), fontSize: 10.5),
                ),
                SizedBox(height: compact ? 9 : 12),
                SizedBox(
                  width: double.infinity,
                  height: compact ? 46 : 54,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kapitel 1 wird als Nächstes aufgebaut.'),
                        ),
                      );
                    },
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
                          'Reise starten',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAccess({required bool compact}) {
    const items = <({IconData icon, String label})>[
      (icon: Icons.public_rounded, label: 'Reisepass'),
      (icon: Icons.menu_book_rounded, label: 'Sprachbuch'),
      (icon: Icons.folder_copy_outlined, label: 'Sprachordner'),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: Container(
              height: compact ? 54 : 66,
              decoration: BoxDecoration(
                color: const Color(0xD917161A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x44FFFFFF)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i].icon,
                    color: const Color(0xFFFF5BAE),
                    size: compact ? 20 : 23,
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      items[i].label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 9.5 : 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 7),
        ],
      ],
    );
  }
}
