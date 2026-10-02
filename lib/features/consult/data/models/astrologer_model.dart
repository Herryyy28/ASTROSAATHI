import 'package:flutter/material.dart';

enum AstrologerCategory {
  all,
  love,
  career,
  marriage,
  wealth,
  health,
  vedic,
  kpSystem,
  lalKitab,
  tarot,
  numerology,
}

class Astrologer {
  final String id;
  final String name;
  final String title;
  final String specialty;
  final List<String> languages;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int followersCount;
  final int ratePerMinute;
  final bool isFreeFirstChat;
  final bool isOnline;
  final bool isLive;
  final bool isVerified;
  final String? todaysOffer;
  final AstrologerCategory category;
  final Color primaryAccent;
  final String personalityPrompt;

  const Astrologer({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.languages,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.followersCount,
    required this.ratePerMinute,
    this.isFreeFirstChat = true,
    this.isOnline = true,
    this.isLive = false,
    this.isVerified = true,
    this.todaysOffer,
    required this.category,
    required this.primaryAccent,
    required this.personalityPrompt,
  });

  String get languagesDisplay => languages.join(', ');
}

/// Curated AI & Live Astrologer Directory inspired by AstroSage UI
class AstrologerRepository {
  static const List<Astrologer> aiAstrologers = [
    Astrologer(
      id: 'swami_ji',
      name: 'Swami Ji',
      title: 'Vedic Astrology & Spiritual Guide',
      specialty: 'Vedic astrology, Kundli Dosha, Shanti Puja',
      languages: ['English', 'Hindi', 'Sanskrit'],
      experienceYears: 28,
      rating: 4.6,
      reviewCount: 6217,
      followersCount: 38400,
      ratePerMinute: 9,
      category: AstrologerCategory.vedic,
      primaryAccent: Color(0xFFE65100),
      personalityPrompt:
          'You are Swami Ji, an enlightened Vedic astrologer. Speak with deep compassion, beginning with "Om Namah Shivaya" or "Pranam". Provide profound traditional Vedic wisdom and practical remedies.',
    ),
    Astrologer(
      id: 'love_guru',
      name: 'Love Guru',
      title: 'Relationship & Marriage Astrologer',
      specialty: 'Love compatibility, Breakup healing, Venus transit',
      languages: ['English', 'Hindi'],
      experienceYears: 12,
      rating: 4.6,
      reviewCount: 7461,
      followersCount: 52100,
      ratePerMinute: 21,
      category: AstrologerCategory.love,
      primaryAccent: Color(0xFFD81B60),
      personalityPrompt:
          'You are Love Guru, a warm, empathetic astrological relationship advisor. Analyze Venus, Mars, 7th house, and emotional compatibility. Be positive, encouraging, and emotionally comforting.',
    ),
    Astrologer(
      id: 'dr_raman',
      name: 'Dr. Raman',
      title: 'Vedic & Career Astrology Scholar',
      specialty: 'Career elevation, Wealth dasha, D10 Dashamsha',
      languages: ['English', 'Hindi'],
      experienceYears: 24,
      rating: 4.5,
      reviewCount: 18239,
      followersCount: 89400,
      ratePerMinute: 11,
      category: AstrologerCategory.career,
      primaryAccent: Color(0xFF1565C0),
      personalityPrompt:
          'You are Dr. Raman, a scholarly authority on Vedic predictive astrology. Analyze Dashas, Saturn transits, 10th house karma, and give clear, strategic career and business advice.',
    ),
    Astrologer(
      id: 'mr_krishnamurti',
      name: 'Mr. Krishnamurti',
      title: 'KP System & Timing Specialist',
      specialty: 'KP System, Horary/Prashna, Exact event timing',
      languages: ['English', 'Tamil', 'Hindi'],
      experienceYears: 32,
      rating: 4.5,
      reviewCount: 201481,
      followersCount: 412000,
      ratePerMinute: 16,
      category: AstrologerCategory.kpSystem,
      primaryAccent: Color(0xFF6A1B9A),
      personalityPrompt:
          'You are Mr. Krishnamurti, a master of Krishnamurti Paddhati (KP System). Focus on Sub-Lords, cuspal positions, ruling planets, and precise timing of events.',
    ),
    Astrologer(
      id: 'pt_radheshyam',
      name: 'Pt. Radheshyam',
      title: 'Lal Kitab & Upay Specialist',
      specialty: 'Lal Kitab, Debt removal, Nazar dosha remedies',
      languages: ['Hindi', 'Gujarati'],
      experienceYears: 19,
      rating: 4.8,
      reviewCount: 92410,
      followersCount: 120500,
      ratePerMinute: 14,
      category: AstrologerCategory.lalKitab,
      primaryAccent: Color(0xFFC2185B),
      personalityPrompt:
          'You are Pandit Radheshyam, a famous Lal Kitab exponent. Give fast, simple, and effective daily remedies (totke, flowing items in water, feeding birds).',
    ),
    Astrologer(
      id: 'tarot_maya',
      name: 'Tarot Maya',
      title: 'Intuitive Tarot & Aura Reader',
      specialty: 'Celtic Cross spreads, Energy clearing, Future insights',
      languages: ['English', 'Hindi'],
      experienceYears: 10,
      rating: 4.7,
      reviewCount: 38200,
      followersCount: 64000,
      ratePerMinute: 18,
      category: AstrologerCategory.tarot,
      primaryAccent: Color(0xFF00897B),
      personalityPrompt:
          'You are Tarot Maya, an intuitive tarot master. Draw cards, explain their cosmic archetypes, and provide intuitive clarity on life directions and love.',
    ),
  ];

  static const List<Astrologer> directoryAstrologers = [
    Astrologer(
      id: 'akhil_p',
      name: 'Akhil P',
      title: 'Vedic Astrologer',
      specialty: 'Vedic, Vastu, Ashtakvarga, Palmistry',
      languages: ['Hindi', 'English'],
      experienceYears: 2,
      rating: 4.8,
      reviewCount: 4,
      followersCount: 101,
      ratePerMinute: 40,
      category: AstrologerCategory.vedic,
      primaryAccent: Color(0xFFFB8C00),
      personalityPrompt: 'You are Akhil P, practical and grounded Vedic and Vastu advisor.',
    ),
    Astrologer(
      id: 'jitender_sharma',
      name: 'Jitender Sharma',
      title: 'Prashna & Horary Astrologer',
      specialty: 'Vedic, Prashna / Horary, Muhurta',
      languages: ['Hindi', 'English'],
      experienceYears: 4,
      rating: 4.7,
      reviewCount: 176,
      followersCount: 1319,
      ratePerMinute: 30,
      category: AstrologerCategory.vedic,
      primaryAccent: Color(0xFF43A047),
      personalityPrompt: 'You are Jitender Sharma, specialized in Prashna Kundli and Auspicious Muhuratas.',
    ),
    Astrologer(
      id: 'vivek_mishra',
      name: 'Vivek Kumar Mishra',
      title: 'Lal Kitab Master',
      specialty: 'Vedic, Lal Kitab',
      languages: ['Hindi'],
      experienceYears: 2,
      rating: 4.7,
      reviewCount: 129,
      followersCount: 1649,
      ratePerMinute: 31,
      category: AstrologerCategory.lalKitab,
      primaryAccent: Color(0xFFE53935),
      personalityPrompt: 'You are Vivek Kumar Mishra, providing quick Lal Kitab remedies.',
    ),
    Astrologer(
      id: 'navneet_kaur',
      name: 'Navneet',
      title: 'Numerology & Tarot Expert',
      specialty: 'Numerology, Tarot, Name Correction',
      languages: ['Hindi', 'Punjabi', 'English'],
      experienceYears: 6,
      rating: 4.7,
      reviewCount: 890,
      followersCount: 4200,
      ratePerMinute: 66,
      todaysOffer: "Today's Offer",
      category: AstrologerCategory.numerology,
      primaryAccent: Color(0xFF8E24AA),
      personalityPrompt: 'You are Navneet, expert in numerological vibrations and life path numbers.',
    ),
    Astrologer(
      id: 'neeraj_gupta',
      name: 'Neeraj Kumar G...',
      title: 'Senior Vedic Consultant',
      specialty: 'Kundli Matching, Career, Manglik Dosha',
      languages: ['Hindi', 'English'],
      experienceYears: 9,
      rating: 4.9,
      reviewCount: 2400,
      followersCount: 9800,
      ratePerMinute: 90,
      todaysOffer: "Today's Offer",
      category: AstrologerCategory.marriage,
      primaryAccent: Color(0xFF00ACC1),
      personalityPrompt: 'You are Neeraj Kumar Gupta, specialized in authentic Gun Milan and Mangal Dosha.',
    ),
    Astrologer(
      id: 'puran_chand',
      name: 'Puran',
      title: 'KP System Consultant',
      specialty: 'KP System, Transit, Business Prosperity',
      languages: ['Hindi', 'English'],
      experienceYears: 14,
      rating: 4.8,
      reviewCount: 3100,
      followersCount: 14200,
      ratePerMinute: 100,
      todaysOffer: "Today's Offer",
      category: AstrologerCategory.kpSystem,
      primaryAccent: Color(0xFF3949AB),
      personalityPrompt: 'You are Puran Chand, KP astrology scholar.',
    ),
  ];

  static const List<Astrologer> liveAstrologers = [
    Astrologer(
      id: 'live_abhinav',
      name: 'Abhinav Du...',
      title: 'Vedic Live Guru',
      specialty: 'Live Tarot & Daily Horoscope',
      languages: ['Hindi'],
      experienceYears: 8,
      rating: 4.8,
      reviewCount: 520,
      followersCount: 18200,
      ratePerMinute: 0,
      isLive: true,
      category: AstrologerCategory.vedic,
      primaryAccent: Color(0xFFFF6D00),
      personalityPrompt: 'You are hosting a lively interactive astrology livestream.',
    ),
    Astrologer(
      id: 'live_deepika',
      name: 'Deepika Ma...',
      title: 'Love & Relationship Live',
      specialty: 'Live Kundli Milan & Venus analysis',
      languages: ['Hindi', 'English'],
      experienceYears: 7,
      rating: 4.9,
      reviewCount: 840,
      followersCount: 24100,
      ratePerMinute: 0,
      isLive: true,
      category: AstrologerCategory.love,
      primaryAccent: Color(0xFFE91E63),
      personalityPrompt: 'You are Deepika, answering relationship questions on livestream.',
    ),
    Astrologer(
      id: 'live_laxmi',
      name: 'Laxmi Rai',
      title: 'Lal Kitab Live',
      specialty: 'Instant Remedies on Live Chat',
      languages: ['Hindi'],
      experienceYears: 11,
      rating: 4.8,
      reviewCount: 1100,
      followersCount: 31000,
      ratePerMinute: 0,
      isLive: true,
      category: AstrologerCategory.lalKitab,
      primaryAccent: Color(0xFFFF9800),
      personalityPrompt: 'You are Laxmi Rai, doing live public remedies analysis.',
    ),
    Astrologer(
      id: 'live_kiran',
      name: 'Kiran Sharma',
      title: 'Career & Wealth Live',
      specialty: 'Job & Business Dasha reading',
      languages: ['Hindi', 'English'],
      experienceYears: 10,
      rating: 4.7,
      reviewCount: 490,
      followersCount: 15400,
      ratePerMinute: 0,
      isLive: true,
      category: AstrologerCategory.career,
      primaryAccent: Color(0xFF00897B),
      personalityPrompt: 'You are Kiran Sharma, analyzing live career questions.',
    ),
  ];
}
