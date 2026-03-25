import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryFlow extends StatefulWidget {
  const EntryFlow({super.key, required this.onComplete});

  final ValueChanged<String> onComplete;

  @override
  State<EntryFlow> createState() => _EntryFlowState();
}

class _EntryFlowState extends State<EntryFlow> {
  final PageController _pageController = PageController();
  final TextEditingController _nicknameController = TextEditingController(
    text: '이민수',
  );
  final TextEditingController _emailController = TextEditingController(
    text: '20220000@univ.ac.kr',
  );

  int _pageIndex = 0;
  bool _showLogin = false;

  static const _slides = [
    (
      '매치 탐색을\n진짜 빠르게',
      '필터와 추천 점수로 단톡방을 뒤지지 않고 바로 경기 후보를 찾습니다.',
      Icons.explore_rounded,
      Color(0xFF0F8F43),
    ),
    (
      '참가부터 일정까지\n한 흐름으로',
      '참가 버튼 한 번이면 일정 탭에 자동 반영되어 매치 관리가 끊기지 않습니다.',
      Icons.calendar_month_rounded,
      Color(0xFFFF8A2A),
    ),
    (
      '프로필 기반 추천으로\n고민을 줄이기',
      '포지션, 실력, 선호 시간에 맞춰 잘 맞는 경기부터 위로 끌어올립니다.',
      Icons.auto_awesome_rounded,
      Color(0xFF234B8D),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _next() {
    if (_pageIndex == _slides.length - 1) {
      setState(() {
        _showLogin = true;
      });
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: _showLogin
          ? _LoginCard(
              key: const ValueKey('login'),
              nicknameController: _nicknameController,
              emailController: _emailController,
              onBack: () {
                setState(() {
                  _showLogin = false;
                });
              },
              onEnter: () {
                widget.onComplete(
                  _nicknameController.text.trim().isEmpty
                      ? '이민수'
                      : _nicknameController.text.trim(),
                );
              },
            )
          : Scaffold(
              key: const ValueKey('onboarding'),
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF4EEDC), Color(0xFFECE2CF)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'F-MATE',
                              style: GoogleFonts.blackHanSans(
                                fontSize: 24,
                                color: const Color(0xFF142114),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => setState(() {
                                _showLogin = true;
                              }),
                              child: const Text('건너뛰기'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (value) {
                              setState(() {
                                _pageIndex = value;
                              });
                            },
                            itemCount: _slides.length,
                            itemBuilder: (context, index) {
                              final slide = _slides[index];
                              return _OnboardingSlide(
                                title: slide.$1,
                                body: slide.$2,
                                icon: slide.$3,
                                accent: slide.$4,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_slides.length, (index) {
                            final active = _pageIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              width: active ? 30 : 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: active
                                    ? const Color(0xFF152217)
                                    : const Color(0x22000000),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _showLogin = true;
                                }),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                ),
                                child: const Text('프로토타입 바로 보기'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: _next,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                ),
                                child: Text(
                                  _pageIndex == _slides.length - 1
                                      ? '시작하기'
                                      : '다음',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, const Color(0xFF162317)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -10,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PLAY SMART',
                              style: GoogleFonts.bebasNeue(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 22,
                                letterSpacing: 1.6,
                              ),
                            ),
                            Text(
                              title,
                              style: GoogleFonts.blackHanSans(
                                color: Colors.white,
                                fontSize: 34,
                                height: 1.12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Icon(icon, color: Colors.white, size: 42),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Expanded(
          flex: 3,
          child: Text(
            body,
            style: GoogleFonts.notoSansKr(
              color: const Color(0xFF556355),
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    super.key,
    required this.nicknameController,
    required this.emailController,
    required this.onBack,
    required this.onEnter,
  });

  final TextEditingController nicknameController;
  final TextEditingController emailController;
  final VoidCallback onBack;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF162317), Color(0xFF0F8F43)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 20),
                Text(
                  'TEAM READY?\n들어가자.',
                  style: GoogleFonts.blackHanSans(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '실제 인증 대신 발표용 입장 화면입니다. 닉네임만 넣고 바로 프로토타입으로 들어갑니다.',
                  style: GoogleFonts.notoSansKr(
                    color: const Color(0xFFDDF7E4),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: '학교 이메일'),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: nicknameController,
                        decoration: const InputDecoration(labelText: '프로필 이름'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onEnter,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: const Text('프로토타입 입장'),
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
