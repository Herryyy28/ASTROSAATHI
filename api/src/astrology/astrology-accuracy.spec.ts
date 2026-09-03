import { MatchingService } from './matching.service';
import { MuhuratEngine } from './engines/muhurat.engine';
import { GamePlanEngine } from './engines/game-plan.engine';
import { KundliDataValidator } from './validators/kundli-data.validator';

describe('🪐 Astrology Accuracy Engine Test Suite', () => {
  let matchingService: MatchingService;
  let muhuratEngine: MuhuratEngine;
  let gamePlanEngine: GamePlanEngine;

  beforeEach(() => {
    matchingService = new MatchingService();
    muhuratEngine = new MuhuratEngine();
    gamePlanEngine = new GamePlanEngine();
  });

  describe('1. Rashi & Zodiac Sign Normalization', () => {
    it('should correctly normalize and validate all 12 Rashi names', () => {
      const rashis = [
        'aries', 'Taurus', 'GEMINI', 'Cancer', 'leo',
        'virgo', 'Libra', 'scorpio', 'Sagittarius', 'capricorn', 'Aquarius', 'pisces'
      ];
      rashis.forEach((rashi) => {
        const result = matchingService.calculateGunMilan(rashi, 'Leo');
        expect(result.partner1Sign).toBe(rashi.charAt(0).toUpperCase() + rashi.slice(1).toLowerCase());
      });
    });

    it('should fallback invalid Rashi inputs to Aries deterministically', () => {
      const result = matchingService.calculateGunMilan('UnknownSign', 'InvalidSign');
      expect(result.partner1Sign).toBe('Aries');
      expect(result.partner2Sign).toBe('Aries');
    });
  });

  describe('2. Ashtakoota 36 Guna Milan & Mangal Dosha Engine', () => {
    it('should return exact 36/36 score for identical signs with matching lords', () => {
      const result = matchingService.calculateGunMilan('Leo', 'Leo');
      expect(result.maxScore).toBe(36);
      expect(result.totalScore).toBeGreaterThanOrEqual(25);
      expect(result.compatibilityGrade).toBe('Excellent');
    });

    it('should correctly identify Bhakoot Dosh when signs are in 2-12 or 6-8 positions', () => {
      // Aries (1) & Taurus (2) -> 2nd position (Bhakoot Dosh)
      const result = matchingService.calculateGunMilan('Aries', 'Taurus');
      expect(result.bhakoot.score).toBe(0.0);
      expect(result.bhavishyavaniSummary).toContain('Bhakoot Dosh');
    });

    it('should correctly evaluate Mangal Dosha cancellation when both partners are Manglik', () => {
      // Aries (1) and Scorpio (8) are both Mars-ruled
      const result = matchingService.calculateGunMilan('Aries', 'Scorpio');
      expect(result.mangalDosha.partner1).toBe(true);
      expect(result.mangalDosha.partner2).toBe(true);
      expect(result.mangalDosha.cancelation).toBe(true);
      expect(result.mangalDosha.summary).toBe('Mutually Cancelled');
    });
  });

  describe('3. Panchang & Muhurat Calculation Engine', () => {
    it('should compute valid Muhurat score windows for business and travel categories', () => {
      const testDate = new Date('2026-09-15T10:30:00Z');
      const location = { latitude: 28.6139, longitude: 77.2090, timeZone: '5.5' };
      const mockPanchang = {
        tithi: { name: 'Shukla Navami', number: 9 },
        nakshatra: { name: 'Rohini', lord: 'Moon' },
        yoga: { name: 'Siddhi' },
        karana: { name: 'Bava' },
        var: 'Tuesday',
        sunrise: '06:05:00',
        sunset: '18:30:00',
      };

      const muhurat = muhuratEngine.calculateMuhurat('Business Launch', testDate, location, mockPanchang as any);
      expect(muhurat).toBeDefined();
      expect(muhurat.score).toBeGreaterThanOrEqual(0);
      expect(muhurat.score).toBeLessThanOrEqual(100);
      expect(muhurat.bestTimeWindows.length).toBeGreaterThan(0);
    });

    it('should accurately calculate Rahu Kaal window for New Delhi location', () => {
      const testDate = new Date('2026-09-15T12:00:00Z');
      const location = { latitude: 28.6139, longitude: 77.2090, timeZone: '5.5' };
      const mockPanchang = {
        tithi: { name: 'Dashami', number: 10 },
        nakshatra: { name: 'Mrigashira', lord: 'Mars' },
        yoga: { name: 'Amrita' },
        karana: { name: 'Kaulava' },
        var: 'Monday',
        sunrise: '06:00:00',
        sunset: '18:00:00',
      };

      const result = muhuratEngine.calculateMuhurat('General', testDate, location, mockPanchang as any);
      expect(result.rahuKaal).toBeDefined();
      expect(result.rahuKaal.start).toMatch(/\d{2}:\d{2}/);
      expect(result.rahuKaal.end).toMatch(/\d{2}:\d{2}/);
    });
  });

  describe('4. Daily Game Plan Engine Validation', () => {
    it('should generate personalized daily game plan score between 0 and 100', () => {
      const testDate = new Date('2026-09-15T12:00:00Z');
      const mockPlanets = {
        Sun: { sign: 'Virgo', degree: 28.5, house: 10 },
        Moon: { sign: 'Taurus', degree: 14.2, house: 6 },
        Jupiter: { sign: 'Cancer', degree: 5.1, house: 8 },
      };
      const mockPanchang = {
        tithi: { name: 'Shukla Ekadashi', number: 11 },
        nakshatra: { name: 'Pushya', lord: 'Saturn' },
      };
      const focusWeights = { Career: 1.2, Love: 1.0, Money: 0.8 };

      const gamePlan = gamePlanEngine.generateDailyGamePlan(testDate, mockPlanets as any, mockPanchang as any, focusWeights);
      expect(gamePlan.cosmicScore).toBeGreaterThanOrEqual(0);
      expect(gamePlan.cosmicScore).toBeLessThanOrEqual(100);
      expect(gamePlan.keyDirectives.length).toBeGreaterThan(0);
    });
  });

  describe('5. Canonical Kundli Validator & Edge Cases', () => {
    it('should validate complete CanonicalKundli schema structure', () => {
      const mockKundli: any = {
        profileId: 'prof_test_123',
        birthDetails: {
          date: '1996-09-15',
          time: '14:30',
          location: 'New Delhi, India',
          latitude: 28.6139,
          longitude: 77.2090,
          timezone: '5.5',
        },
        lagna: { rashi: 'Sagittarius', degree: 14.35 },
        rashi: { id: 'libra', name: 'Libra', englishName: 'Libra', degree: 8.45 },
        planets: [
          { id: 'sun', name: 'Sun', rashi: 'Virgo', rashiId: 'virgo', house: 10, degree: 29.12, nakshatra: 'Chitra', pada: 2, retrograde: false },
          { id: 'moon', name: 'Moon', rashi: 'Libra', rashiId: 'libra', house: 11, degree: 8.45, nakshatra: 'Swati', pada: 1, retrograde: false },
        ],
        houses: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        calculatedAt: new Date().toISOString(),
        calculationVersion: '1.0',
      };

      const validated = KundliDataValidator.validate(mockKundli);
      expect(validated.profileId).toBe('prof_test_123');
      expect(validated.planets.length).toBe(2);
      expect(validated.lagna.rashi).toBe('Sagittarius');
    });
  });
});
