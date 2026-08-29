import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('knowledge_rashi')
export class KnowledgeRashi {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string; // e.g. 'Aries'

  @Column()
  sanskritName!: string; // e.g. 'Mesha'

  @Column()
  gujaratiName!: string; // e.g. 'મેષ'

  @Column()
  hindiName!: string; // e.g. 'मेष'

  @Column()
  symbol!: string;

  @Column()
  element!: string; // Fire, Earth, Air, Water

  @Column()
  modality!: string; // Cardinal, Fixed, Mutable

  @Column()
  gender!: string; // Male, Female

  @Column()
  lord!: string; // Mars, Venus, etc.

  @Column()
  nature!: string;

  @Column('simple-array', { nullable: true })
  bodyAssociation: string[] = [];

  @Column('simple-array', { nullable: true })
  temperament: string[] = [];

  @Column('simple-array', { nullable: true })
  strengths: string[] = [];

  @Column('simple-array', { nullable: true })
  challenges: string[] = [];

  @Column('simple-array', { nullable: true })
  careerThemes: string[] = [];

  @Column('simple-array', { nullable: true })
  relationshipThemes: string[] = [];

  @Column('simple-array', { nullable: true })
  moneyThemes: string[] = [];

  @Column('simple-array', { nullable: true })
  spiritualThemes: string[] = [];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
