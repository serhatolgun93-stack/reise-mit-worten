import 'package:flutter/material.dart';

import 'journey_intro_flow.dart';

class GuideSelectionScreen extends StatefulWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;

  const GuideSelectionScreen({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
    required this.backgroundAsset,
  });

  @override
  State<GuideSelectionScreen> createState() => _GuideSelectionScreenState();
}

class _GuideSelectionScreenState extends State<GuideSelectionScreen> {
  String? _selectedGuide;

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
            widget.backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x26000000),
                  Color(0x52000000),
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.48, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                landscape ? 28 : 18,
                landscape ? 10 : 14,
                landscape ? 28 : 18,
                landscape ? 12 : 18,
              ),
              child: landscape
                  ? _landscapeContent(size)
                  : _portraitContent(size),
            ),
          ),
        ],
      ),
    );
  }

  Widget _portraitContent(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 12),
        const Text(
          'Wer begleitet dich auf deiner Reise?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            height: 1.08,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Wähle deinen persönlichen Reiseführer. Du kannst später jederzeit wechseln.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE8E2E7),
            fontSize: 14,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _guideCard(
                  keyName: 'maria',
                  name: 'Maria',
                  subtitle: 'Mit Maria reisen',
                  asset: 'assets/characters/maria_welcome.png',
                  imageAlignment: Alignment.bottomCenter,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _guideCard(
                  keyName: 'leon',
                  name: 'Leon',
                  subtitle: 'Mit Leon reisen',
                  asset: 'assets/characters/leon_invite.png',
                  imageAlignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _continueButton(),
      ],
    );
  }

  Widget _landscapeContent(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 4),
        const Text(
          'Wer begleitet dich auf deiner Reise?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Wähle Maria oder Leon als persönlichen Reiseführer.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFE8E2E7), fontSize: 13),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.34,
                child: _guideCard(
                  keyName: 'maria',
                  name: 'Maria',
                  subtitle: 'Mit Maria reisen',
                  asset: 'assets/characters/maria_welcome.png',
                  imageAlignment: Alignment.bottomCenter,
                ),
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: size.width * 0.34,
                child: _guideCard(
                  keyName: 'leon',
                  name: 'Leon',
                  subtitle: 'Mit Leon reisen',
                  asset: 'assets/characters/leon_invite.png',
                  imageAlignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(width: 520, child: _continueButton(height: 48)),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
        Text(
          '${widget.flag} ${widget.language}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _guideCard({
    required String keyName,
    required String name,
    required String subtitle,
    required String asset,
    required Alignment imageAlignment,
  }) {
    final selected = _selectedGuide == keyName;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedGuide = keyName),
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: const Color(0xD917161A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFF2E9A)
                  : const Color(0x66FFFFFF),
              width: selected ? 3 : 1.2,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0xAAFF2E9A),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x77000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 70),
                    child: Image.asset(
                      asset,
                      fit: BoxFit.contain,
                      alignment: imageAlignment,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
                          Color(0x00000000),
                          Color(0x16000000),
                          Color(0xE6000000),
                        ],
                        stops: [0.45, 0.64, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFFF5BAE)
                              : const Color(0xFFE4DEE3),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFFF2E9A),
                      child: Icon(Icons.check_rounded, color: Colors.white, size: 21),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton({double height = 60}) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: _selectedGuide == null ? null : _startJourney,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF2E9A),
          disabledBackgroundColor: const Color(0x88FF2E9A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedGuide == null
                  ? 'Reiseführer auswählen'
                  : 'Reise mit ${_selectedGuide == 'maria' ? 'Maria' : 'Leon'} beginnen',
              style: TextStyle(
                fontSize: height < 55 ? 17 : 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 25),
          ],
        ),
      ),
    );
  }

  void _startJourney() {
    final guideKey = _selectedGuide!;
    final guideName = guideKey == 'maria' ? 'Maria' : 'Leon';

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => JourneyIntroFlow(
          language: widget.language,
          flag: widget.flag,
          greeting: widget.greeting,
          backgroundAsset: widget.backgroundAsset,
          guideKey: guideKey,
          guideName: guideName,
        ),
      ),
    );
  }
}
