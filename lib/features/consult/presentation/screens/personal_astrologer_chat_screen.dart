import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/astrologer_model.dart';

class PersonalAstrologerChatScreen extends StatefulWidget {
  final Astrologer astrologer;

  const PersonalAstrologerChatScreen({super.key, required this.astrologer});

  @override
  State<PersonalAstrologerChatScreen> createState() => _PersonalAstrologerChatScreenState();
}

class _PersonalAstrologerChatScreenState extends State<PersonalAstrologerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial greeting from astrologer
    _messages.add({
      'text': 'Pranam! I am ${widget.astrologer.name}. How can I guide you with your astrological chart today?',
      'isMe': false,
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate reply after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': 'Let me check your planetary alignments regarding this. Give me a moment.',
          'isMe': false,
          'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
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
                colors: [a.primaryAccent, const Color(0xFFFF8F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: a.primaryAccent.withOpacity(0.3), blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: Center(
              child: Text(
                a.name.substring(0, 1),
                style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            a.name,
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
          ),
          Text(
            a.title,
            style: GoogleFonts.inter(fontSize: 16, color: AppColors.getTextSecondary(context)),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(Icons.star_rounded, 'Rating', '${a.rating} (${a.reviewCount} reviews)', isLight),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.work_history_rounded, 'Experience', '${a.experienceYears} Years', isLight),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.language_rounded, 'Languages', a.languagesDisplay, isLight),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.auto_awesome_rounded, 'Specialty', a.specialty, isLight),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, height: 44, child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getPrimary(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Close Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isLight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.getPrimary(context), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context))),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.getTextPrimary(context))),
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
      backgroundColor: isLight ? const Color(0xFFE5E5E5) : const Color(0xFF0D0D0D),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: isLight ? const Color(0xFF075E54) : const Color(0xFF1F2C34),
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Online',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.videocam_rounded, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.call_rounded, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.more_vert_rounded, color: Colors.white), onPressed: () {}),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/chat_bg.png'), // Typical WhatsApp background fallback
            fit: BoxFit.cover,
            colorFilter: isLight 
                ? ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.lighten)
                : ColorFilter.mode(const Color(0xFF0D1418).withOpacity(0.95), BlendMode.darken),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg['isMe'] as bool;
                  return _buildChatBubble(msg['text'], msg['time'], isMe, isLight);
                },
              ),
            ),
            _buildMessageInput(isLight),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, String time, bool isMe, bool isLight) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe 
                ? (isLight ? const Color(0xFFDCF8C6) : const Color(0xFF005C4B))
                : (isLight ? Colors.white : const Color(0xFF202C33)),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
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
                        ? (isLight ? Colors.black87 : const Color(0xFFE9EDEF))
                        : (isLight ? Colors.black87 : const Color(0xFFE9EDEF)),
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
                        color: isMe 
                            ? (isLight ? Colors.black54 : Colors.white60)
                            : (isLight ? Colors.black54 : Colors.white60),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.done_all_rounded, size: 14, color: isLight ? const Color(0xFF34B7F1) : const Color(0xFF53BDEB)),
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
                color: isLight ? Colors.white : const Color(0xFF2A3942),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined, color: isLight ? Colors.black54 : const Color(0xFF8696A0)),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      style: TextStyle(color: isLight ? Colors.black87 : const Color(0xFFD1D7DB)),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: isLight ? Colors.black54 : const Color(0xFF8696A0)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file_rounded, color: isLight ? Colors.black54 : const Color(0xFF8696A0)),
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
            decoration: const BoxDecoration(
              color: Color(0xFF00A884),
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
