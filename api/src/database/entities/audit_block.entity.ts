import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('audit_blocks')
export class AuditBlock {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'integer' })
  blockIndex!: number;

  @Column({ type: 'varchar', length: 50 })
  actionType!: string;

  @Column({ type: 'text' })
  dataPayload!: string;

  @Column({ type: 'varchar', length: 64 })
  previousHash!: string;

  @Column({ type: 'varchar', length: 64 })
  hash!: string;

  @Column({ type: 'integer', default: 0 })
  nonce!: number;

  @CreateDateColumn()
  timestamp!: Date;
}
