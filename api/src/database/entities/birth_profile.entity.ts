import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './user.entity';

@Entity('birth_profiles')
export class BirthProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @ManyToOne(() => User, (user) => user.birthProfiles, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column()
  name: string;

  @Column({ default: 'Self' })
  relationship: string; // Self, Partner, Mother, Father, Child, Friend

  @Column({ type: 'varchar' })
  dob: string; // YYYY-MM-DD

  @Column({ type: 'varchar' })
  birthTime: string; // HH:mm

  @Column()
  birthPlace: string;

  @Column('float')
  latitude: number;

  @Column('float')
  longitude: number;

  @Column({ default: '5.5' })
  timezone: string;

  @Column({ default: false })
  isPrimary: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
