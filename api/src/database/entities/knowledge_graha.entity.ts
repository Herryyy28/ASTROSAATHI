import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('knowledge_graha')
export class KnowledgeGraha {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string; // e.g. 'Sun'

  @Column()
  sanskritName!: string; // e.g. 'Surya'

  @Column()
  nature!: string; // Benefic/Malefic

  @Column('simple-array', { nullable: true })
  karakatwa: string[] = []; // Natural significations

  @Column('simple-array', { nullable: true })
  signOwnership: string[] = []; // e.g. ['Leo']

  @Column()
  exaltation!: string; // e.g. 'Aries'

  @Column()
  debilitation!: string; // e.g. 'Libra'

  @Column('simple-array', { nullable: true })
  friendlySigns: string[] = [];

  @Column('simple-array', { nullable: true })
  enemySigns: string[] = [];

  @Column('simple-array', { nullable: true })
  neutralSigns: string[] = [];

  @Column()
  digbala!: number; // House number where it gets directional strength, e.g. 10 for Sun

  @Column('simple-array', { nullable: true })
  traditionalRemedies: string[] = [];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
