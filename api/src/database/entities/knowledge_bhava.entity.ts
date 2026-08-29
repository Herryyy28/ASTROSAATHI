import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('knowledge_bhava')
export class KnowledgeBhava {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  houseNumber!: number; // 1 to 12

  @Column()
  sanskritName!: string; // e.g. 'Tanu Bhava'

  @Column('simple-array', { nullable: true })
  primaryThemes: string[] = [];

  @Column('simple-array', { nullable: true })
  secondaryThemes: string[] = [];

  @Column('simple-array', { nullable: true })
  traditionalAssociations: string[] = [];

  @Column('simple-array', { nullable: true })
  lifeAreas: string[] = [];

  @Column('simple-array', { nullable: true })
  naturalSignificators: string[] = []; // e.g. Sun for 1st House

  @Column('simple-array', { nullable: true })
  positiveManifestations: string[] = [];

  @Column('simple-array', { nullable: true })
  challengingManifestations: string[] = [];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
