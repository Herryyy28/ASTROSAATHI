import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_notification.dart';
import '../../../reminders/data/models/reminder_model.dart';
import '../../../reminders/providers/reminder_provider.dart';

class AddEventModal extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const AddEventModal({super.key, this.initialDate});

  static Future<void> show(BuildContext context, {DateTime? initialDate}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => AddEventModal(initialDate: initialDate),
    );
  }

  @override
  ConsumerState<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends ConsumerState<AddEventModal> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  EventCategory _selectedCategory = EventCategory.business;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _leadTimeMinutes = 20;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate.add(const Duration(hours: 1)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime get _fullEventDateTime {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  double get _calculatedScore {
    final hour = _selectedTime.hour;
    double score = 7.8;
    if (hour >= 10 && hour <= 12) score += 1.4;
    else if (hour >= 13 && hour <= 15) score -= 1.2;
    else if (hour >= 16 && hour <= 18) score += 0.8;
    return (score > 10.0) ? 10.0 : ((score < 4.0) ? 4.0 : double.parse(score.toStringAsFixed(1)));
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final eventDt = _fullEventDateTime;
    final score = _calculatedScore;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: isLight ? AppColors.surfaceLight.withOpacity(0.96) : const Color(0xF20F141C),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: AppColors.getGlassBorder(context), width: 1.0),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.getTextMuted(context),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.event_available_rounded, color: Colors.black, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Schedule Personal Event',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Event Title Input
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.inter(color: AppColors.getTextPrimary(context)),
                    decoration: InputDecoration(
                      labelText: 'Event Title (e.g. Client Meeting, Property Deal)',
                      labelStyle: TextStyle(color: AppColors.getTextSecondary(context), fontSize: 13),
                      filled: true,
                      fillColor: AppColors.getSurfaceSecondary(context),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Selector
                  Text('EVENT CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getTextMuted(context))),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: EventCategory.values.map((cat) {
                        final isSel = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? cat.color.withOpacity(0.2) : AppColors.getSurfaceSecondary(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? cat.color : AppColors.getGlassBorder(context),
                                width: isSel ? 1.5 : 0.6,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(cat.icon, size: 14, color: isSel ? cat.color : AppColors.getTextSecondary(context)),
                                const SizedBox(width: 6),
                                Text(
                                  cat.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                    color: isSel ? cat.color : AppColors.getTextSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date & Time Picker Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceSecondary(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.getGlassBorder(context), width: 0.8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date', style: TextStyle(fontSize: 10, color: AppColors.getTextMuted(context))),
                                    Text(
                                      DateFormat('EEE, dd MMM').format(_selectedDate),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) setState(() => _selectedTime = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceSecondary(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.getGlassBorder(context), width: 0.8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time', style: TextStyle(fontSize: 10, color: AppColors.getTextMuted(context))),
                                    Text(
                                      _selectedTime.format(context),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Astrological Alignment Compatibility Preview Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              score.toStringAsFixed(1),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                                'Astro Compatibility Score',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                score >= 8.5
                                    ? '✦ Peak Window! Favorable transits for ${_selectedCategory.label.toLowerCase()}.'
                                    : (score >= 6.5 ? 'Good timing. Planetary energy aligns favorably.' : '⚠️ Caution Window! Consider shifting time by 30 mins.'),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        final title = _titleController.text.trim();
                        if (title.isEmpty) {
                          CosmicNotification.show(
                            context,
                            message: 'Please enter an event title',
                            icon: Icons.warning_rounded,
                          );
                          return;
                        }

                        await ref.read(reminderProvider.notifier).addReminder(
                          title: title,
                          category: _selectedCategory,
                          eventTime: eventDt,
                          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          leadTimeMinutes: _leadTimeMinutes,
                        );

                        if (mounted) {
                          Navigator.pop(context);
                          CosmicNotification.show(
                            context,
                            message: '✦ Scheduled "$title" with Astro Score ${score.toStringAsFixed(1)}/10',
                            icon: Icons.event_available_rounded,
                          );
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.black, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'SCHEDULE & SET REMINDER',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
