import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/astrologer_model.dart';

class PersonalAstrologerChatScreen extends StatefulWidget {
  final Astrologer astrologer;

  const PersonalAstrologerChatScreen({super.key, required this.astrologer});

  @override
  State<PersonalAstrologerChatScreen> createState() =>
      _PersonalAstrologerChatScreenState();
}

class _PersonalAstrologerChatScreenState
    extends State<PersonalAstrologerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Initial greeting from astrologer
    _messages.add({
      'text':
          'Pranam! I am ${widget.astrologer.name}, specialist in ${widget.astrologer.specialty}. How can I assist your spiritual and astrological journey today?',
      'isMe': false,
      'time':
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    });
  }

  String _generateAstrologerReply(String query) {
    final q = query.toLowerCase();
    final spec = widget.astrologer.specialty;

    if (q.contains('job') ||
        q.contains('career') ||
        q.contains('promotion') ||
        q.contains('work') ||
        q.contains('business')) {
      return 'Based on my Vedic examination of your chart, your 10th House of Karma is currently influenced by a favorable aspect of Jupiter. If you maintain patience through the ongoing transit, a breakthrough opportunity or promotion will manifest within the next 45 to 60 days. I recommend chanting the Gayatri Mantra daily during morning Brahma Muhurta.';
    } else if (q.contains('marriage') ||
        q.contains('love') ||
        q.contains('partner') ||
        q.contains('relationship') ||
        q.contains('divorce')) {
      return 'Regarding marital and relationship harmony: Your 7th House indicates Venus transiting an auspicious quadrant. To harmonize communication and dissolve any mild Kuja (Mars) tension, lighting a ghee lamp in the North-East direction on Fridays will bring peace and mutual understanding.';
    } else if (q.contains('health') ||
        q.contains('stress') ||
        q.contains('disease') ||
        q.contains('pain')) {
      return 'Analyzing your 6th and 8th houses for physical vitality: The Sun is your primary Karaka of health. Drink water stored in a copper vessel in the morning and offer Arghya to Surya Dev at sunrise to strengthen your aura and nervous energy.';
    } else if (q.contains('money') ||
        q.contains('finance') ||
        q.contains('wealth') ||
        q.contains('debt') ||
        q.contains('loan')) {
      return 'Looking into your Dhana (Wealth) Bhava (2nd & 11th houses): Lakshmi Yoga is partially active. Keep financial transactions clear and avoid high-risk speculative investments during Rahu Kaal. Favorable results will stabilize soon.';
    } else if (q.contains('gem') ||
        q.contains('stone') ||
        q.contains('remedy') ||
        q.contains('puja')) {
      return 'As a $spec practitioner, I suggest performing an Anushthan of Om Namah Shivaya 108 times daily. For gemstone recommendations, ensure your birth time is verified to the minute before wearing natural gemstones like Yellow Sapphire or Pearl.';
    } else {
      return 'I have evaluated your birth chart details. The current planetary period (Dasha) shows a transformative phase that requires mental calm and steady perseverance. Focus on constructive decisions, and favorable transits will support your goals.';
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time':
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Contextual astrologer consultation reply
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final reply = _generateAstrologerReply(text);
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': reply,
          'isMe': false,
          'time':
              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAstrologerDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAstrologerDetailsSheet(),
    );
  }

  Widget _buildAstrologerDetailsSheet() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final a = widget.astrologer;

    return Container(
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.getGlassBorder(context),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [a.primaryAccent, AppColors.actionPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: a.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                a.name.substring(0, 1),
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            a.name,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          Text(
            a.title,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            Icons.star_rounded,
            'Rating',
            '${a.rating} (${a.reviewCount} reviews)',
            isLight,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.work_history_rounded,
            'Experience',
            '${a.experienceYears} Years',
            isLight,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.language_rounded,
            'Languages',
            a.languagesDisplay,
            isLight,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.auto_awesome_rounded,
            'Specialty',
            a.specialty,
            isLight,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getPrimary(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isLight,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.getPrimary(context), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.getSurface(context),
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryLightMode),
            onPressed: () => Navigator.pop(context),
          ),
          title: GestureDetector(
            onTap: _showAstrologerDetails,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.astrologer.primaryAccent,
                  child: Text(
                    widget.astrologer.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.astrologer.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLightMode,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Online',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Start Video Call',
              icon: const Icon(Icons.videocam_rounded, color: AppColors.primaryLightMode),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Video consultation requires an active booking slot with ${widget.astrologer.name}.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Start Voice Call',
              icon: const Icon(Icons.call_rounded, color: AppColors.primaryLightMode),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Voice consultation requires an active booking slot with ${widget.astrologer.name}.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Astrologer Profile Details',
              icon: const Icon(Icons.info_outline_rounded, color: AppColors.primaryLightMode),
              onPressed: _showAstrologerDetails,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.backgroundLight : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg['isMe'] as bool;
                  return _buildChatBubble(
                    msg['text'],
                    msg['time'],
                    isMe,
                    isLight,
                  );
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.black12 : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Color(0xFFF5A623),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.astrologer.name} is examining your chart...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SafeArea(child: _buildMessageInput(isLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, String time, bool isMe, bool isLight) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.getPrimary(context).withValues(alpha: 0.15)
                : AppColors.getSurface(context),
            border: Border.all(
              color: isMe
                  ? AppColors.getPrimary(context).withValues(alpha: 0.4)
                  : AppColors.getBorder(context),
              width: 0.8,
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe
                  ? const Radius.circular(12)
                  : const Radius.circular(0),
              bottomRight: isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14, right: 20),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: isMe
                        ? AppColors.getTextPrimary(context)
                        : AppColors.getTextPrimary(context),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: AppColors.getPrimary(context),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.getBorder(context)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppColors.getTextSecondary(context),
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(context),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: AppColors.getTextSecondary(context),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: AppColors.getTextSecondary(context),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.getPrimary(context),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
