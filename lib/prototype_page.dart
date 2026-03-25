import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'entry_flow.dart';
import 'match_detail_page.dart';
import 'models.dart';
import 'prototype_widgets.dart';
import 'selection_field.dart';

class PrototypePage extends StatefulWidget {
  const PrototypePage({super.key, this.startInHome = false});

  final bool startInHome;

  @override
  State<PrototypePage> createState() => _PrototypePageState();
}

class _PrototypePageState extends State<PrototypePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late bool _enteredApp;
  String _displayName = '이민수';

  final List<MatchCardData> _matches = [
    MatchCardData(
      id: 'm1',
      title: '성수 수요 야간 5v5',
      location: '성수 서울숲 풋살파크',
      scheduledAt: DateTime(2026, 3, 18, 20, 30),
      level: '중급',
      timeTag: '야간',
      roleFocus: '윙어',
      surface: '실내',
      capacity: 10,
      joinedCount: 7,
      hostType: '추천 매치',
      notes: '퇴근 후 바로 참여하는 직장인 중심 매치. 패스 템포가 빠르고 분위기가 깔끔한 편입니다.',
      hostName: 'TEAM Onion',
      hostRating: 4.9,
      distanceKm: 2.4,
    ),
    MatchCardData(
      id: 'm2',
      title: '건대 루프탑 목요전',
      location: '건대입구 루프탑 경기장',
      scheduledAt: DateTime(2026, 3, 14, 20, 0),
      level: '중급',
      timeTag: '야간',
      roleFocus: '피보',
      surface: '실외',
      capacity: 12,
      joinedCount: 10,
      hostType: '인기 매치',
      notes: '혼자 와도 바로 팀 배정이 가능한 매치. 현재 참가 중인 경기입니다.',
      hostName: '건대 FC',
      hostRating: 4.8,
      distanceKm: 3.1,
    ),
    MatchCardData(
      id: 'm3',
      title: '강남 토요 아침 풋살',
      location: '강남 탄천 풋살센터',
      scheduledAt: DateTime(2026, 3, 16, 10, 0),
      level: '초급',
      timeTag: '주간',
      roleFocus: '수비',
      surface: '실외',
      capacity: 10,
      joinedCount: 6,
      hostType: '입문자 추천',
      notes: '가볍게 몸을 풀며 즐기는 초급자 중심 매치. 풋살 입문자에게 맞는 템포입니다.',
      hostName: 'Morning Kickers',
      hostRating: 4.7,
      distanceKm: 5.3,
    ),
    MatchCardData(
      id: 'm4',
      title: '마포 금요 경쟁전',
      location: '마포구민체육센터',
      scheduledAt: DateTime(2026, 3, 20, 21, 0),
      level: '상급',
      timeTag: '야간',
      roleFocus: '골키퍼',
      surface: '실내',
      capacity: 10,
      joinedCount: 8,
      hostType: '도전 매치',
      notes: '강한 압박과 빠른 전환을 선호하는 상급자 중심 경기입니다.',
      hostName: 'Mapo Rush',
      hostRating: 4.9,
      distanceKm: 4.6,
    ),
  ];

  final Set<String> _joinedMatchIds = {'m2', 'm3'};

  int _selectedIndex = 0;
  MatchFilter _selectedFilter = MatchFilter.all;
  PlayerProfile _profile = const PlayerProfile(
    position: '윙어',
    skill: '중급',
    timePreference: '야간',
  );

  String _draftLevel = '중급';
  int _draftCapacity = 10;
  late DateTime _draftDate;
  String _draftTimeLabel = '20:30';

  static const List<String> _levels = ['초급', '중급', '상급'];
  static const List<int> _capacities = [8, 10, 12, 14];
  static const List<String> _positions = ['윙어', '피보', '수비', '골키퍼'];
  static const List<String> _timePreferences = ['주간', '야간'];

  @override
  void initState() {
    super.initState();
    _enteredApp = widget.startInHome;
    _draftDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<MatchCardData> get _rankedMatches {
    final matches = [..._matches];
    matches.sort((a, b) => _scoreMatch(b).compareTo(_scoreMatch(a)));
    return matches;
  }

  List<MatchCardData> get _filteredMatches {
    return _rankedMatches.where((match) {
      switch (_selectedFilter) {
        case MatchFilter.all:
          return true;
        case MatchFilter.beginner:
          return match.level == '초급';
        case MatchFilter.intermediate:
          return match.level == '중급';
        case MatchFilter.night:
          return match.timeTag == '야간';
      }
    }).toList();
  }

  List<MatchCardData> get _scheduledMatches {
    final matches =
        _matches.where((match) => _joinedMatchIds.contains(match.id)).toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return matches;
  }

  MatchCardData get _bestMatch => _rankedMatches.first;

  int get _createdCount =>
      _matches.where((match) => match.createdByUser).length;

  int _scoreMatch(MatchCardData match) {
    var score = 58;
    if (match.level == _profile.skill) score += 18;
    if (match.timeTag == _profile.timePreference) score += 12;
    if (match.roleFocus == _profile.position) score += 10;
    if (match.level == '상급' && _profile.skill == '초급') score -= 10;
    if (match.level == '초급' && _profile.skill == '상급') score -= 8;
    return score.clamp(46, 97);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _completeEntry(String name) {
    setState(() {
      _displayName = name;
      _enteredApp = true;
    });
  }

  void _toggleJoin(MatchCardData match) {
    final index = _matches.indexWhere((item) => item.id == match.id);
    if (index == -1) return;

    final alreadyJoined = _joinedMatchIds.contains(match.id);
    if (!alreadyJoined && match.joinedCount >= match.capacity) {
      _showMessage('이 매치는 이미 모집이 마감되었습니다.');
      return;
    }

    setState(() {
      if (alreadyJoined) {
        _joinedMatchIds.remove(match.id);
        _matches[index] = match.copyWith(joinedCount: match.joinedCount - 1);
      } else {
        _joinedMatchIds.add(match.id);
        _matches[index] = match.copyWith(joinedCount: match.joinedCount + 1);
      }
    });

    _showMessage(alreadyJoined ? '참가를 취소했습니다.' : '매치가 일정에 추가되었습니다.');
  }

  void _openMatchDetails(MatchCardData match) {
    Navigator.of(context).push(
      MatchDetailPage.route(
        match: match,
        joined: _joinedMatchIds.contains(match.id),
        score: _scoreMatch(match),
        onJoin: () => _toggleJoin(match),
      ),
    );
  }

  Future<void> _pickDraftLevel() async {
    final selected = await showSelectionSheet<String>(
      context: context,
      title: '경기 레벨 선택',
      options: _levels,
      selectedValue: _draftLevel,
      labelBuilder: (option) => option,
    );
    if (selected != null) {
      setState(() {
        _draftLevel = selected;
      });
    }
  }

  Future<void> _pickDraftCapacity() async {
    final selected = await showSelectionSheet<int>(
      context: context,
      title: '모집 인원 선택',
      options: _capacities,
      selectedValue: _draftCapacity,
      labelBuilder: (option) => '$option명',
    );
    if (selected != null) {
      setState(() {
        _draftCapacity = selected;
      });
    }
  }

  Future<void> _pickDraftDate() async {
    final selected = await showDateSelectionSheet(
      context: context,
      initialDate: _draftDate,
    );
    if (selected != null) {
      setState(() {
        _draftDate = selected;
      });
    }
  }

  Future<void> _pickDraftTime() async {
    final selected = await showTimeSelectionSheet(
      context: context,
      initialTime: _parseTimeLabel(_draftTimeLabel),
    );
    if (selected != null) {
      setState(() {
        _draftTimeLabel =
            '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickProfilePosition() async {
    final selected = await showSelectionSheet<String>(
      context: context,
      title: '포지션 선택',
      options: _positions,
      selectedValue: _profile.position,
      labelBuilder: (option) => option,
    );
    if (selected != null) {
      setState(() {
        _profile = _profile.copyWith(position: selected);
      });
    }
  }

  Future<void> _pickProfileSkill() async {
    final selected = await showSelectionSheet<String>(
      context: context,
      title: '실력 선택',
      options: _levels,
      selectedValue: _profile.skill,
      labelBuilder: (option) => option,
    );
    if (selected != null) {
      setState(() {
        _profile = _profile.copyWith(skill: selected);
      });
    }
  }

  Future<void> _pickProfileTimePreference() async {
    final selected = await showSelectionSheet<String>(
      context: context,
      title: '선호 시간 선택',
      options: _timePreferences,
      selectedValue: _profile.timePreference,
      labelBuilder: (option) => option,
    );
    if (selected != null) {
      setState(() {
        _profile = _profile.copyWith(timePreference: selected);
      });
    }
  }

  void _createMatch() {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final notes = _notesController.text.trim();

    if (title.isEmpty || location.isEmpty) {
      _showMessage('매치 이름과 장소는 꼭 입력해야 합니다.');
      return;
    }

    final timeOfDay = _parseTimeLabel(_draftTimeLabel);
    final scheduledAt = DateTime(
      _draftDate.year,
      _draftDate.month,
      _draftDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    final match = MatchCardData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      location: location,
      scheduledAt: scheduledAt,
      level: _draftLevel,
      timeTag: timeOfDay.hour >= 18 ? '야간' : '주간',
      roleFocus: _profile.position,
      surface: '직접 생성',
      capacity: _draftCapacity,
      joinedCount: 1,
      hostType: '내가 만든 매치',
      notes: notes.isEmpty ? '직접 만든 시연용 매치입니다.' : notes,
      hostName: _displayName,
      hostRating: 5.0,
      distanceKm: 1.2,
      createdByUser: true,
    );

    setState(() {
      _matches.insert(0, match);
      _joinedMatchIds.add(match.id);
      _selectedIndex = 1;
    });

    _titleController.clear();
    _locationController.clear();
    _notesController.clear();
    _draftLevel = '중급';
    _draftCapacity = 10;
    _draftDate = DateTime.now().add(const Duration(days: 1));
    _draftTimeLabel = '20:30';

    _showMessage('새 매치를 만들고 일정에 바로 추가했습니다.');
  }

  List<String> _recommendationReasons() {
    return [
      '${_profile.skill} 실력대와 맞는 매치를 우선 추천합니다.',
      '${_profile.timePreference} 시간대 선호가 추천도에 반영됩니다.',
      '${_profile.position} 포지션 수요가 있는 매치가 상단에 노출됩니다.',
    ];
  }

  TimeOfDay _parseTimeLabel(String label) {
    final parts = label.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatDateOnly(DateTime value) {
    final weekday = weekdayNames[value.weekday - 1];
    return '${monthDay(value)} ($weekday)';
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildScheduleTab();
      case 2:
        return _buildCreateTab();
      case 3:
        return _buildProfileTab();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (!_enteredApp) {
      return EntryFlow(onComplete: _completeEntry);
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F3E8), Color(0xFFF1EADB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F8F43), Color(0xFF25C767)],
                        ),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'F-MATE',
                            style: GoogleFonts.blackHanSans(
                              fontSize: 22,
                              color: const Color(0xFF152217),
                            ),
                          ),
                          Text(
                            '$_displayName 님을 위한 매치데이 추천',
                            style: GoogleFonts.notoSansKr(
                              color: const Color(0xFF657166),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _switchTab(3),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFD7F2DD),
                        foregroundColor: const Color(0xFF0F8F43),
                      ),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  transitionBuilder: (child, animation) {
                    final slide =
                        Tween<Offset>(
                          begin: const Offset(0.03, 0.02),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_selectedIndex),
                    child: _buildBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              height: 72,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: '매치',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: '일정',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: '생성',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: '프로필',
                ),
              ],
              onDestinationSelected: _switchTab,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    final bestMatch = _bestMatch;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F8F43), Color(0xFF0E612F), Color(0xFF162317)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220A4C25),
                blurRadius: 32,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: CustomPaint(painter: const PitchLinesPainter()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'MATCHDAY PICK',
                            style: GoogleFonts.bebasNeue(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_scheduledMatches.length} GAMES ON',
                          style: GoogleFonts.bebasNeue(
                            color: const Color(0xFFE4F8E8),
                            fontSize: 18,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      bestMatch.title,
                      style: GoogleFonts.blackHanSans(
                        color: Colors.white,
                        fontSize: 33,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_profile.position} 포지션과 ${_profile.timePreference} 선호를 반영해 가장 적합한 매치입니다.',
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFFDDF7E4),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TagChip(
                          label: '${_scoreMatch(bestMatch)}% 적합',
                          bright: true,
                        ),
                        TagChip(label: bestMatch.level, bright: true),
                        TagChip(label: bestMatch.timeTag, bright: true),
                        TagChip(label: bestMatch.roleFocus, bright: true),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KICK OFF',
                                  style: GoogleFonts.bebasNeue(
                                    color: const Color(0xFFE1FFE9),
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  formatMatchDateTime(bestMatch.scheduledAt),
                                  style: GoogleFonts.blackHanSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                            child: Center(
                              child: Text(
                                '${_scoreMatch(bestMatch)}',
                                style: GoogleFonts.bebasNeue(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _openMatchDetails(bestMatch),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0B5C2C),
                              minimumSize: const Size.fromHeight(54),
                            ),
                            child: const Text('상세 보기'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _toggleJoin(bestMatch),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0x4DFFFFFF)),
                              minimumSize: const Size.fromHeight(54),
                            ),
                            child: Text(
                              _joinedMatchIds.contains(bestMatch.id)
                                  ? '참가 취소'
                                  : '바로 참가',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricCard(
              label: '참가 중 일정',
              value: '${_scheduledMatches.length}',
              accent: const Color(0xFF0F8F43),
            ),
            MetricCard(
              label: '직접 만든 매치',
              value: '$_createdCount',
              accent: const Color(0xFFFF8A2A),
            ),
            MetricCard(
              label: '추천 최고 점수',
              value: '${_scoreMatch(bestMatch)}%',
              accent: const Color(0xFF234B8D),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const SectionHeading(
          title: '추천 매치',
          subtitle: 'Discover',
          caption: '카드를 누르면 상세 페이지로 넘어가고, 참가 버튼은 바로 반영됩니다.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: MatchFilter.values.map((filter) {
            return ChoiceChip(
              label: Text(filter.label),
              selected: _selectedFilter == filter,
              onSelected: (_) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        ..._filteredMatches.map(
          (match) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: MatchCard(
              match: match,
              joined: _joinedMatchIds.contains(match.id),
              score: _scoreMatch(match),
              onPressed: () => _toggleJoin(match),
              onTap: () => _openMatchDetails(match),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const SectionHeading(
          title: '시연 포인트',
          subtitle: 'Prototype Scope',
          caption: '발표에서는 탐색, 상세, 참가, 일정 반영, 생성 흐름만 보여줘도 충분합니다.',
        ),
        const SizedBox(height: 12),
        const FlowCard(),
      ],
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        SectionHeading(
          title: '참가 일정',
          subtitle: 'Schedule',
          caption: '${_scheduledMatches.length}개의 매치가 내 일정에 연결되어 있습니다.',
        ),
        const SizedBox(height: 14),
        if (_scheduledMatches.isEmpty)
          const EmptyCard(
            title: '아직 참가한 매치가 없습니다.',
            description: '매치 탭에서 바로 참가하면 일정이 자동으로 생성됩니다.',
          )
        else
          ..._scheduledMatches.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ScheduleCard(
                match: entry.value,
                statusLabel: entry.key == 0 ? '확정' : '대기',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCreateTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const SectionHeading(
          title: '새 매치 만들기',
          subtitle: 'Host',
          caption: '날짜는 캘린더, 시간은 자유 선택 휠로 바꿔서 작은 화면 오버플로우와 제한된 시간 선택을 제거했습니다.',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF162317), Color(0xFF223A26)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 84,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Text(
                    _formatDateOnly(_draftDate),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.blackHanSans(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.2,
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
                      'HOST PREVIEW',
                      style: GoogleFonts.bebasNeue(
                        color: const Color(0xFFDDF5E3),
                        fontSize: 20,
                        letterSpacing: 1.4,
                      ),
                    ),
                    Text(
                      _titleController.text.trim().isEmpty
                          ? '아직 이름이 없는 새 매치'
                          : _titleController.text.trim(),
                      style: GoogleFonts.blackHanSans(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_draftTimeLabel · $_draftLevel · $_draftCapacity명 모집',
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFFDDF7E4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: '매치 이름',
                  hintText: '예: 잠실 금요 심야전',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _locationController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: '장소',
                  hintText: '예: 잠실 종합운동장 풋살장',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SelectionField(
                      label: '레벨',
                      value: _draftLevel,
                      icon: Icons.stacked_bar_chart_rounded,
                      onTap: _pickDraftLevel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectionField(
                      label: '모집 인원',
                      value: '$_draftCapacity명',
                      icon: Icons.groups_rounded,
                      onTap: _pickDraftCapacity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SelectionField(
                      label: '날짜',
                      value: _formatDateOnly(_draftDate),
                      icon: Icons.calendar_today_rounded,
                      onTap: _pickDraftDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectionField(
                      label: '시간',
                      value: _draftTimeLabel,
                      icon: Icons.access_time_rounded,
                      onTap: _pickDraftTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '메모',
                  hintText: '준비물, 분위기, 유니폼 색상 등을 적어주세요.',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _createMatch,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: const Text('매치 생성하고 일정에 추가'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    final reasons = _recommendationReasons();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const SectionHeading(
          title: '내 프로필',
          subtitle: 'Profile',
          caption: '프로필을 바꾸면 추천 매치 우선순위가 즉시 갱신됩니다.',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF6E8), Color(0xFFF7FBEA)],
            ),
            border: Border.all(color: const Color(0x14000000)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x140F8F43),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 34,
                      color: Color(0xFF0F8F43),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName,
                          style: GoogleFonts.blackHanSans(
                            fontSize: 24,
                            color: const Color(0xFF152217),
                          ),
                        ),
                        Text(
                          '${_profile.position} | ${_profile.skill} | ${_profile.timePreference} 선호',
                          style: GoogleFonts.notoSansKr(
                            color: const Color(0xFF677264),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TagChip(label: _profile.position),
                  TagChip(label: _profile.skill),
                  TagChip(label: _profile.timePreference),
                  TagChip(label: '추천 ${_scoreMatch(_bestMatch)}점'),
                ],
              ),
              const SizedBox(height: 18),
              SelectionField(
                label: '포지션',
                value: _profile.position,
                icon: Icons.assistant_direction_rounded,
                onTap: _pickProfilePosition,
              ),
              const SizedBox(height: 12),
              SelectionField(
                label: '실력',
                value: _profile.skill,
                icon: Icons.local_fire_department_outlined,
                onTap: _pickProfileSkill,
              ),
              const SizedBox(height: 12),
              SelectionField(
                label: '선호 시간',
                value: _profile.timePreference,
                icon: Icons.nights_stay_outlined,
                onTap: _pickProfileTimePreference,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeading(
          title: '추천 사유',
          subtitle: 'Insight',
          caption: '발표 때는 이 로직을 간단히 설명하면 됩니다.',
        ),
        const SizedBox(height: 10),
        ...reasons.map(
          (reason) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InsightCard(text: reason),
          ),
        ),
      ],
    );
  }
}
