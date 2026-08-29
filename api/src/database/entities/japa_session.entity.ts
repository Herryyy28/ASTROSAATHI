import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('japa_sessions')
export class JapaSession {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  userId!: string;

  @Column()
  mantraTitle!: string;

  @Column({ type: 'int', default: 108 })
  count!: number;

  @Column({ type: 'int', default: 1 })
  completedRounds!: number;

  @CreateDateColumn()
  createdAt!: Date;
}
