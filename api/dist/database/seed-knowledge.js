"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedKnowledgeDatabase = seedKnowledgeDatabase;
const knowledge_rashi_entity_1 = require("./entities/knowledge_rashi.entity");
const knowledge_graha_entity_1 = require("./entities/knowledge_graha.entity");
async function seedKnowledgeDatabase(dataSource) {
    const rashiRepo = dataSource.getRepository(knowledge_rashi_entity_1.KnowledgeRashi);
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
    const grahaRepo = dataSource.getRepository(knowledge_graha_entity_1.KnowledgeGraha);
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
//# sourceMappingURL=seed-knowledge.js.map