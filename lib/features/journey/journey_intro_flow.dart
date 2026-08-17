import 'package:flutter/material.dart';

class JourneyIntroFlow extends StatefulWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;

  const JourneyIntroFlow({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
    required this.backgroundAsset,
  });

  @override
  State<JourneyIntroFlow> createState() => _JourneyIntroFlowState();
}

class _JourneyIntroFlowState extends State<JourneyIntroFlow> {
  bool _showStepTwo = false;
  final TextEditingController _nameController = TextEditingController();

  String get learningGreeting {
    switch (widget.language) {
      case 'Türkçe':
        return 'Merhaba!';
      case 'Ελληνικά':
        return 'Γεια σου!';
      default:
        return 'Hello!';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF050508)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x16000000), Color(0x08000000), Color(0xB8000000)],
                stops: [0.0, 0.50, 1.0],
              ),
            ),
          ),
          _mariaLayer(screen),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: _showStepTwo ? _stepTwo(screen) : _stepOne(screen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mariaLayer(Size screen) {
    // maria_wave.png currently contains a visible checkerboard background.
    // Use the clean transparent welcome pose for step 1 until the wave asset is replaced.
    final asset = _showStepTwo
        ? 'assets/characters/maria_confident.png'
        : 'assets/characters/maria_welcome.png';

    return Positioned(
      left: _showStepTwo ? null : -34,
      right: _showStepTwo ? -42 : null,
      bottom: _showStepTwo ? 108 : 138,
      child: IgnorePointer(
        child: SizedBox(
          width: screen.width * (_showStepTwo ? 0.61 : 0.67),
          height: screen.height * (_showStepTwo ? 0.58 : 0.61),
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
            alignment: _showStepTwo ? Alignment.bottomRight : Alignment.bottomLeft,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _stepOne(Size screen) {
    return Column(
      children: [
        _header('1 / 8', () => Navigator.of(context).pop()),
        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screen.width * 0.68,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Color(0xFFFF2E9A), size: 21),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        learningGreeting,
                        style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Maria begrüßt dich', style: TextStyle(color: Colors.white, fontSize: 28, height: 1.08, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Divider(color: Color(0xCCFF2E9A), thickness: 1.2),
                const SizedBox(height: 12),
                const Text(
                  'Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.',
                  style: TextStyle(color: Color(0xFFF2EDF2), fontSize: 14.5, height: 1.42, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 14),
                Text('${widget.flag} ${widget.language}', style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _pinkButton('Weiter', () => setState(() => _showStepTwo = true)),
      ],
    );
  }

  Widget _stepTwo(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('2 / 8', () {
          FocusScope.of(context).unfocus();
          setState(() => _showStepTwo = false);
        }),
        const Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: screen.width * 0.66,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('LERNEN WIR UNS KENNEN', style: TextStyle(color: Color(0xFFFF5BAE), fontSize: 14.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                const Text('Wie darf ich dich nennen?', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.07, fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                const Text(
                  'Dein Name macht deine Reise persönlicher. Maria wird dich während des Lernens damit ansprechen.',
                  style: TextStyle(color: Color(0xFFF2EDF2), fontSize: 13.5, height: 1.36),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: 'Dein Vorname',
                    hintStyle: const TextStyle(color: Color(0xFFAAA3AC)),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFFF2E9A)),
                    filled: true,
                    fillColor: const Color(0xE61E1C22),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFF514A56)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFFF2E9A), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xC91E1C22),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: const Color(0xFF3C3740)),
                  ),
                  child: Row(
                    children: [
                      Text(widget.flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Du lernst ${widget.language} – Schritt für Schritt und in deinem Tempo.',
                          style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.28, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _pinkButton(
          'Weiter',
          _nameController.text.trim().isEmpty
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Willkommen, ${_nameController.text.trim()}! Schritt 3 folgt als Nächstes.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
        ),
      ],
    );
  }

  Widget _header(String step, VoidCallback onBack) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 34)),
        Text(step, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: const Color(0xE817161A),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x44FFFFFF)),
        boxShadow: const [BoxShadow(color: Color(0x77000000), blurRadius: 28, offset: Offset(0, 12))],
      );

  Widget _pinkButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF2E9A),
          disabledBackgroundColor: const Color(0x88FF2E9A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded, size: 28),
          ],
        ),
      ),
    );
  }
}
