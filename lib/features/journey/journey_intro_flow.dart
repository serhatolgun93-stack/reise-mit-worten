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

  String get learningGreeting {
    switch (widget.language) {
      case 'Türkçe': return 'Merhaba!';
      case 'Ελληνικά': return 'Γεια σου!';
      default: return 'Hello!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    return Scaffold(
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
                colors: [Color(0x22000000), Color(0x18000000), Color(0xB8000000)],
                stops: [0.0, 0.48, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: _showStepTwo ? _stepTwo(screen) : _stepOne(screen),
            ),
          ),
        ],
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
            width: screen.width * 0.72,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  const Icon(Icons.favorite_rounded, color: Color(0xFFFF2E9A), size: 21),
                  const SizedBox(width: 8),
                  Flexible(child: Text(learningGreeting, style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 17, fontWeight: FontWeight.w800))),
                ]),
                const SizedBox(height: 14),
                const Text('Maria begrüßt dich', style: TextStyle(color: Colors.white, fontSize: 29, height: 1.08, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                const Divider(color: Color(0xCCFF2E9A), thickness: 1.2),
                const SizedBox(height: 14),
                const Text('Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.', style: TextStyle(color: Color(0xFFF2EDF2), fontSize: 15, height: 1.45, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text('${widget.flag} ${widget.language}', style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _pinkButton('Weiter', () => setState(() => _showStepTwo = true)),
      ],
    );
  }

  Widget _stepTwo(Size screen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header('2 / 8', () => setState(() => _showStepTwo = false)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('SCHRITT 2', style: TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('Wie darf ich dich nennen?', style: TextStyle(color: Colors.white, fontSize: 32, height: 1.08, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              const Text('Dein Name macht deine Reise persönlicher. Maria wird dich während des Lernens damit ansprechen.', style: TextStyle(color: Color(0xFFF2EDF2), fontSize: 16, height: 1.45)),
              const SizedBox(height: 16),
              Text('${widget.flag} ${widget.language}', style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _pinkButton('Weiter', () {}),
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

  Widget _pinkButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF2E9A),
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
