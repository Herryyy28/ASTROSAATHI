import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './user.entity';

export enum EventCategory {
  BUSINESS = 'Business',
  MEETING = 'Meeting',
  TRAVEL = 'Travel',
  INVESTMENT = 'Investment',
  CONTRACT = 'Contract',
  MARRIAGE = 'Marriage',
  PROPERTY = 'Property',
  MEDICAL = 'Medical',
  PERSONAL = 'Personal',
}

@Entity('reminders')
export class Reminder {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column()
  title: string;

  @Column({
    type: 'varchar',
    default: EventCategory.BUSINESS,
  })
  category: EventCategory;

  @Column()
  eventTime: Date;

  @Column({ nullable: true })
  notes: string;

  @Column({ type: 'float', default: 8.0 })
  astroScore: number;

  @Column({ type: 'varchar', nullable: true })
  astroRecommendation: string;

  @Column({ default: true })
  reminderEnabled: boolean;

  @Column({ default: 20 }) // Lead time in minutes before event
  leadTimeMinutes: number;

  @Column({ default: false })
  isNotified: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
