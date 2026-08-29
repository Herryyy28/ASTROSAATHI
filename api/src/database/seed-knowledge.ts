import { DataSource } from 'typeorm';
import { KnowledgeRashi } from './entities/knowledge_rashi.entity';
import { KnowledgeBhava } from './entities/knowledge_bhava.entity';
import { KnowledgeGraha } from './entities/knowledge_graha.entity';

// This is a minimal baseline seeder for the Knowledge Brain.
// It populates the core deterministic facts of astrology to ensure the AI doesn't hallucinate.

export async function seedKnowledgeDatabase(dataSource: DataSource) {
  const rashiRepo = dataSource.getRepository(KnowledgeRashi);
  
  // Seed Mesha (Aries) as an example
  const existingAries = await rashiRepo.findOneBy({ name: 'Aries' });
  if (!existingAries) {
    const aries = rashiRepo.create({
      name: 'Aries',
      sanskritName: 'Mesha',
      hindiName: 'मेष',
      gujaratiName: 'મેષ',
      symbol: 'Ram',
      element: 'Fire',
      modality: 'Cardinal',
      gender: 'Male',
      lord: 'Mars',
      nature: 'Energetic, impulsive, courageous',
      strengths: ['Leadership', 'Bravery', 'Initiative'],
      challenges: ['Impatience', 'Aggression', 'Stubbornness'],
      careerThemes: ['Military', 'Engineering', 'Sports', 'Entrepreneurship'],
      relationshipThemes: ['Passionate', 'Direct', 'Independent'],
    });
    await rashiRepo.save(aries);
    console.log('Seeded Aries knowledge.');
  }

  const grahaRepo = dataSource.getRepository(KnowledgeGraha);
  const existingSun = await grahaRepo.findOneBy({ name: 'Sun' });
  if (!existingSun) {
    const sun = grahaRepo.create({
      name: 'Sun',
      sanskritName: 'Surya',
      nature: 'Cruel (Krura) but pure',
      signOwnership: ['Leo'],
      exaltation: 'Aries',
      debilitation: 'Libra',
      friendlySigns: ['Aries', 'Cancer', 'Scorpio', 'Sagittarius', 'Pisces'],
      enemySigns: ['Taurus', 'Capricorn', 'Aquarius'],
      neutralSigns: ['Gemini', 'Virgo'],
      digbala: 10,
    });
    await grahaRepo.save(sun);
    console.log('Seeded Sun knowledge.');
  }

  console.log('Knowledge seeding complete.');
}
