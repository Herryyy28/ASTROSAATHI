import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditBlock } from '../entities/audit_block.entity';
import * as crypto from 'crypto';

@Injectable()
export class BlockchainService {
  constructor(
    @InjectRepository(AuditBlock)
    private readonly auditRepo: Repository<AuditBlock>,
  ) {}

  /// Calculate SHA-256 hash for a given block's contents
  calculateHash(
    index: number,
    previousHash: string,
    timestamp: string,
    actionType: string,
    dataPayload: string,
    nonce: number,
  ): string {
    const raw = `${index}${previousHash}${timestamp}${actionType}${dataPayload}${nonce}`;
    return crypto.createHash('sha256').update(raw).digest('hex');
  }

  /// Appends a new immutable block to the tamper-proof ledger
  async recordBlock(actionType: string, payload: Record<string, any>): Promise<AuditBlock> {
    const lastBlock = await this.auditRepo.findOne({
      order: { blockIndex: 'DESC' },
    });

    const index = lastBlock ? lastBlock.blockIndex + 1 : 0;
    const previousHash = lastBlock ? lastBlock.hash : '0000000000000000000000000000000000000000000000000000000000000000';
    const timestampStr = new Date().toISOString();
    const payloadStr = JSON.stringify(payload);
    const nonce = 0;

    const hash = this.calculateHash(
      index,
      previousHash,
      timestampStr,
      actionType,
      payloadStr,
      nonce,
    );

    const block = this.auditRepo.create({
      blockIndex: index,
      actionType,
      dataPayload: payloadStr,
      previousHash,
      hash,
      nonce,
    });

    return await this.auditRepo.save(block);
  }

  /// Verifies the full chain integrity from Genesis block to latest block
  async verifyChainIntegrity(): Promise<{ isValid: boolean; brokenAtBlockIndex?: number }> {
    const blocks = await this.auditRepo.find({
      order: { blockIndex: 'ASC' },
    });

    for (let i = 0; i < blocks.length; i++) {
      const current = blocks[i];

      // Check current block's hash validity
      const recalculated = this.calculateHash(
        current.blockIndex,
        current.previousHash,
        current.timestamp instanceof Date ? current.timestamp.toISOString() : new Date(current.timestamp).toISOString(),
        current.actionType,
        current.dataPayload,
        current.nonce,
      );

      if (current.hash !== recalculated) {
        return { isValid: false, brokenAtBlockIndex: current.blockIndex };
      }

      // Check pointer link to previous block
      if (i > 0) {
        const previous = blocks[i - 1];
        if (current.previousHash !== previous.hash) {
          return { isValid: false, brokenAtBlockIndex: current.blockIndex };
        }
      }
    }

    return { isValid: true };
  }

  /// Fetch all recorded blocks for developer/admin inspection
  async getAllBlocks(): Promise<AuditBlock[]> {
    return await this.auditRepo.find({
      order: { blockIndex: 'DESC' },
    });
  }
}
