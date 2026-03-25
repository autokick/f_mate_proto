import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models.dart';

const List<String> weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];

String monthDay(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$month.$day';
}

String formatMatchDateTime(DateTime dateTime) {
  final weekday = weekdayNames[dateTime.weekday - 1];
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$month.$day ($weekday) $hour:$minute';
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
    required this.caption,
  });

  final String title;
  final String subtitle;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.toUpperCase(),
          style: GoogleFonts.bebasNeue(
            color: const Color(0xFF6B7567),
            letterSpacing: 1.8,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.blackHanSans(
            fontSize: 28,
            color: const Color(0xFF142114),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          caption,
          style: GoogleFonts.notoSansKr(
            color: const Color(0xFF6B7567),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, accent.withValues(alpha: 0.08)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.notoSansKr(
              color: const Color(0xFF657166),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.blackHanSans(fontSize: 30, color: accent),
          ),
        ],
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, this.bright = false});

  final String label;
  final bool bright;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: bright
            ? Colors.white.withValues(alpha: 0.14)
            : const Color(0xFFEDF7EF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: bright
              ? Colors.white.withValues(alpha: 0.18)
              : const Color(0x140F8F43),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          color: bright ? Colors.white : const Color(0xFF0F8F43),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    required this.joined,
    required this.score,
    required this.onPressed,
    required this.onTap,
  });

  final MatchCardData match;
  final bool joined;
  final int score;
  final VoidCallback onPressed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF162317), Color(0xFF0F8F43)],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      monthDay(match.scheduledAt),
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 28,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      weekdayNames[match.scheduledAt.weekday - 1],
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFFD4F5DF),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${match.scheduledAt.hour.toString().padLeft(2, '0')}:${match.scheduledAt.minute.toString().padLeft(2, '0')}',
                      style: GoogleFonts.blackHanSans(
                        color: const Color(0xFFFFE9D7),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.hostType,
                            style: GoogleFonts.bebasNeue(
                              color: const Color(0xFF6B7567),
                              fontSize: 18,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: const Color(0xFFF3F8E8),
                          ),
                          child: Text(
                            '$score% 적합',
                            style: GoogleFonts.notoSansKr(
                              color: const Color(0xFF0F8F43),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.title,
                      style: GoogleFonts.blackHanSans(
                        fontSize: 22,
                        height: 1.15,
                        color: const Color(0xFF142114),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.location,
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFF5F6B5E),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F1E6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${match.joinedCount}/${match.capacity}명 모집',
                              style: GoogleFonts.notoSansKr(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A201A),
                              ),
                            ),
                          ),
                          Text(
                            match.level,
                            style: GoogleFonts.bebasNeue(
                              color: const Color(0xFFFF8A2A),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      match.notes,
                      style: GoogleFonts.notoSansKr(
                        height: 1.5,
                        color: const Color(0xFF2A302A),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: match.tags
                          .map((tag) => TagChip(label: tag))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: onPressed,
                            style: FilledButton.styleFrom(
                              backgroundColor: joined
                                  ? const Color(0x14234B8D)
                                  : const Color(0x140F8F43),
                              foregroundColor: joined
                                  ? const Color(0xFF234B8D)
                                  : const Color(0xFF0F8F43),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: Text(joined ? '참가 취소' : '참가 신청'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          onPressed: onTap,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF2EAD9),
                            foregroundColor: const Color(0xFF1A201A),
                          ),
                          icon: const Icon(Icons.arrow_outward_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.match,
    required this.statusLabel,
  });

  final MatchCardData match;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final confirmed = statusLabel == '확정';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF7F2E9)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF162317),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  monthDay(match.scheduledAt),
                  style: GoogleFonts.bebasNeue(
                    fontSize: 28,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weekdayNames[match.scheduledAt.weekday - 1],
                  style: GoogleFonts.notoSansKr(
                    color: const Color(0xFFD4F5DF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.title,
                  style: GoogleFonts.blackHanSans(
                    fontSize: 21,
                    color: const Color(0xFF142114),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${formatMatchDateTime(match.scheduledAt)} | ${match.location}',
                  style: GoogleFonts.notoSansKr(
                    color: const Color(0xFF677264),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: confirmed
                  ? const Color(0x140F8F43)
                  : const Color(0x14FF8A2A),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.notoSansKr(
                color: confirmed
                    ? const Color(0xFF0F8F43)
                    : const Color(0xFFB7641C),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x120F8F43)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0x140F8F43),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 18,
              color: Color(0xFF0F8F43),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.notoSansKr(height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class FlowCard extends StatelessWidget {
  const FlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('01', '매치 탐색', '필터와 추천도를 이용해 빠르게 경기 선택'),
      ('02', '즉시 참가', '카드에서 바로 참가해 사용자 흐름 단축'),
      ('03', '일정 반영', '참가한 매치가 일정 탭에 자동 연결'),
      ('04', '직접 개설', '모집글 생성 후 내가 주최자인 흐름까지 시연'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF162317), Color(0xFF223A26)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: steps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0x14FFFFFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      step.$1,
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.$2,
                        style: GoogleFonts.blackHanSans(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.$3,
                        style: GoogleFonts.notoSansKr(
                          color: const Color(0xFFD5DDD3),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x120F8F43)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 42,
            color: Color(0xFF0F8F43),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.blackHanSans(
              fontSize: 20,
              color: const Color(0xFF142114),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              color: const Color(0xFF677264),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class MatchDetailSheet extends StatelessWidget {
  const MatchDetailSheet({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F1E7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0x22000000),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF162317), Color(0xFF0F8F43)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.hostType.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        color: const Color(0xFFDDF5E3),
                        fontSize: 20,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      match.title,
                      style: GoogleFonts.blackHanSans(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TagChip(label: '$score% 적합', bright: true),
                        TagChip(label: match.level, bright: true),
                        TagChip(label: match.timeTag, bright: true),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _DetailRow(
                icon: Icons.calendar_month_outlined,
                label: '일정',
                value: formatMatchDateTime(match.scheduledAt),
              ),
              _DetailRow(
                icon: Icons.place_outlined,
                label: '장소',
                value: match.location,
              ),
              _DetailRow(
                icon: Icons.groups_outlined,
                label: '모집 현황',
                value: '${match.joinedCount}/${match.capacity}명',
              ),
              _DetailRow(
                icon: Icons.sports_soccer_outlined,
                label: '매치 톤',
                value:
                    '${match.level} · ${match.roleFocus} 모집 · ${match.surface}',
              ),
              const SizedBox(height: 14),
              Text(
                '매치 메모',
                style: GoogleFonts.blackHanSans(
                  fontSize: 18,
                  color: const Color(0xFF142114),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                match.notes,
                style: GoogleFonts.notoSansKr(
                  height: 1.6,
                  color: const Color(0xFF324033),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onJoin,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: joined
                        ? const Color(0xFF223C77)
                        : const Color(0xFF0F8F43),
                  ),
                  child: Text(joined ? '참가 취소하기' : '이 매치 참가하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0F8F43)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFF73806F),
                    fontSize: 18,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.notoSansKr(
                    color: const Color(0xFF1A201A),
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PitchLinesPainter extends CustomPainter {
  const PitchLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(30),
    );
    canvas.drawRRect(rect, linePaint);

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.12,
      linePaint,
    );

    final leftBox = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        size.height * 0.22,
        size.width * 0.18,
        size.height * 0.56,
      ),
      const Radius.circular(18),
    );
    final rightBox = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.82,
        size.height * 0.22,
        size.width * 0.18,
        size.height * 0.56,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(leftBox, linePaint);
    canvas.drawRRect(rightBox, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
