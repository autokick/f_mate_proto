import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models.dart';
import 'prototype_widgets.dart';

class MatchDetailPage extends StatelessWidget {
  const MatchDetailPage({
    super.key,
    required this.match,
    required this.joined,
    required this.score,
    required this.onJoin,
  });

  final MatchCardData match;
  final bool joined;
  final int score;
  final VoidCallback onJoin;

  static Route<void> route({
    required MatchCardData match,
    required bool joined,
    required int score,
    required VoidCallback onJoin,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: MatchDetailPage(
            match: match,
            joined: joined,
            score: score,
            onJoin: onJoin,
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset =
            Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return SlideTransition(position: offset, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3EDD9), Color(0xFFF8F4EB)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: const Color(0xFF162317),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0F8F43),
                            Color(0xFF0E612F),
                            Color(0xFF162317),
                          ],
                        ),
                      ),
                    ),
                    const CustomPaint(painter: PitchLinesPainter()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 110, 24, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.hostType.toUpperCase(),
                            style: GoogleFonts.bebasNeue(
                              color: const Color(0xFFDDF5E3),
                              fontSize: 22,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            match.title,
                            style: GoogleFonts.blackHanSans(
                              color: Colors.white,
                              fontSize: 32,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TagChip(label: '$score% 적합', bright: true),
                              TagChip(label: match.level, bright: true),
                              TagChip(label: match.timeTag, bright: true),
                              TagChip(label: match.roleFocus, bright: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _InfoGrid(match: match, score: score),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: '매치 설명',
                    child: Text(
                      match.notes,
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFF314032),
                        height: 1.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: '호스트 정보',
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7EF),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            color: Color(0xFF0F8F43),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                match.hostName,
                                style: GoogleFonts.blackHanSans(
                                  fontSize: 18,
                                  color: const Color(0xFF152217),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '매너 점수 ${match.hostRating.toStringAsFixed(1)} / 5.0 · 응답 빠름',
                                style: GoogleFonts.notoSansKr(
                                  color: const Color(0xFF6D7A6B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          child: FilledButton(
            onPressed: onJoin,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              backgroundColor: joined
                  ? const Color(0xFF234B8D)
                  : const Color(0xFF0F8F43),
            ),
            child: Text(joined ? '참가 취소하기' : '이 매치 참가하기'),
          ),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.match, required this.score});

  final MatchCardData match;
  final int score;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('일정', formatMatchDateTime(match.scheduledAt)),
      ('장소', match.location),
      ('거리', '${match.distanceKm.toStringAsFixed(1)}km'),
      ('모집', '${match.joinedCount}/${match.capacity}명'),
      ('실력대', match.level),
      ('추천도', '$score점'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.$1,
                style: GoogleFonts.bebasNeue(
                  color: const Color(0xFF73806F),
                  fontSize: 18,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                item.$2,
                style: GoogleFonts.notoSansKr(
                  color: const Color(0xFF152217),
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.blackHanSans(
              fontSize: 20,
              color: const Color(0xFF152217),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
