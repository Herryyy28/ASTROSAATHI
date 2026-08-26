import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { User } from './user.entity';

@Entity('user_profiles')
export class UserProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, user => user.profiles, { onDelete: 'CASCADE' })
  user: User;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  // Birth Details
  @Column({ type: 'date' })
  dob: Date;

  @Column({ type: 'time' })
  birthTime: string;

  @Column({ type: 'float' })
  birthLatitude: number;

  @Column({ type: 'float' })
  birthLongitude: number;

  @Column({ type: 'varchar', length: 100 })
  birthTimeZone: string;

  // Current Location (for location-sensitive calculations)
  @Column({ type: 'float', nullable: true })
  currentLatitude: number;

  @Column({ type: 'float', nullable: true })
  currentLongitude: number;

  @Column({ type: 'varchar', length: 100, nullable: true })
  currentTimeZone: string;

  // User Focus (e.g., 'Career', 'Love', 'Money')
  @Column({ type: 'jsonb', default: {} })
  focusWeights: Record<string, number>;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
