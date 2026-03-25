import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionField extends StatelessWidget {
  const SelectionField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0x14000000)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7EF),
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
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.notoSansKr(
                        color: const Color(0xFF152217),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF758171),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T option) labelBuilder,
  T? selectedValue,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF6F1E7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  Text(
                    title,
                    style: GoogleFonts.blackHanSans(
                      fontSize: 22,
                      color: const Color(0xFF152217),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final selected = option == selectedValue;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(option),
                              borderRadius: BorderRadius.circular(22),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF162317)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        labelBuilder(option),
                                        style: GoogleFonts.notoSansKr(
                                          color: selected
                                              ? Colors.white
                                              : const Color(0xFF152217),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<DateTime?> showDateSelectionSheet({
  required BuildContext context,
  required DateTime initialDate,
}) {
  final today = DateTime.now();
  final firstDate = DateTime(today.year, today.month, today.day);
  final lastDate = firstDate.add(const Duration(days: 365));

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      var selectedDate = initialDate.isBefore(firstDate)
          ? firstDate
          : initialDate;
      final maxHeight = MediaQuery.sizeOf(context).height * 0.78;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F1E7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                      Text(
                        '날짜 선택',
                        style: GoogleFonts.blackHanSans(
                          fontSize: 22,
                          color: const Color(0xFF152217),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateChanged: (date) {
                            setModalState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(context).pop(selectedDate),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                          ),
                          child: const Text('이 날짜로 선택'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<TimeOfDay?> showTimeSelectionSheet({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      var selectedHour = initialTime.hour;
      var selectedMinute = initialTime.minute;
      final hourController = FixedExtentScrollController(
        initialItem: initialTime.hour,
      );
      final minuteController = FixedExtentScrollController(
        initialItem: initialTime.minute,
      );
      final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F1E7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                      Text(
                        '시간 선택',
                        style: GoogleFonts.blackHanSans(
                          fontSize: 22,
                          color: const Color(0xFF152217),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 42,
                          color: const Color(0xFF0F8F43),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: Row(
                          children: [
                            Expanded(
                              child: _TimeWheel(
                                controller: hourController,
                                itemCount: 24,
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    selectedHour = index;
                                  });
                                },
                              ),
                            ),
                            Text(
                              ':',
                              style: GoogleFonts.blackHanSans(
                                fontSize: 36,
                                color: const Color(0xFF152217),
                              ),
                            ),
                            Expanded(
                              child: _TimeWheel(
                                controller: minuteController,
                                itemCount: 60,
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    selectedMinute = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop(
                              TimeOfDay(
                                hour: selectedHour,
                                minute: selectedMinute,
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                          ),
                          child: const Text('이 시간으로 선택'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _TimeWheel extends StatelessWidget {
  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.onSelectedItemChanged,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 44,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.25,
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= itemCount) {
              return null;
            }
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: GoogleFonts.bebasNeue(
                  fontSize: 30,
                  letterSpacing: 1.1,
                  color: const Color(0xFF152217),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
