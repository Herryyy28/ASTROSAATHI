import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('astro_messages')
export class AstroMessage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column()
  conversationId: string;

  @Column({ type: 'text' })
  userQuestion: string;

  @Column({ type: 'text' })
  aiAnswer: string;

  @Column({ type: 'jsonb', nullable: true })
  contextData: any;

  @CreateDateColumn()
  createdAt: Date;
}
