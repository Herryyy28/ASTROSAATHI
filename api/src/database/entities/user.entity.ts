import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { UserProfile } from './profile.entity';
import { BirthProfile } from './birth_profile.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', length: 255 })
  email!: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  firebaseUid!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @OneToMany(() => UserProfile, profile => profile.user)
  profiles!: UserProfile[];

  @OneToMany(() => BirthProfile, birthProfile => birthProfile.user)
  birthProfiles!: BirthProfile[];
}
