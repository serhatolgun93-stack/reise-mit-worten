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
  String _selectedLanguage = 'English';

  static const _languages = <({String label, String flag, String greeting})>[
    (label: 'English', flag: '🇬🇧', greeting: 'Welcome'),
    (label: 'Türkçe', flag: '🇹🇷', greeting: 'Hoş geldin'),
    (label: 'Ελληνικά', flag: '🇬🇷', greeting: 'Καλώς ήρθες'),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _languages.firstWhere((item) => item.label == _selectedLanguage);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF15131A), Color(0xFF08080B)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reise mit Worten',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x22FF2E9A),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0x66FF2E9A)),
                      ),
                      child: const Text(
                        'VS1',
                        style: TextStyle(color: Color(0xFFFF78BC), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  selected.greeting,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFF4FA8),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Deine Reise beginnt mit einem Wort.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 31,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Lerne nicht nur eine Sprache. Erlebe sie.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB9B6C2),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Welche Sprache möchtest du erleben?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                ..._languages.map((language) {
                  final isSelected = language.label == _selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _selectedLanguage = language.label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0x22FF2E9A) : const Color(0xFF1A191F),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF2E9A) : const Color(0xFF2C2A32),
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(language.flag, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                language.label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Color(0xFFFF2E9A)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E9A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reise in $_selectedLanguage wird vorbereitet.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    'Reise beginnen',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Englisch · Türkisch · Griechisch',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF7F7B88), fontSize: 12),
                ),
                const Spacer(),
                if (widget.showBuildLabel)
                  const Text(
                    'Interner Entwicklungsstand',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF5F5B67), fontSize: 11),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
