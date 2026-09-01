import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../database/entities/user.entity';
import { UserProfile } from '../database/entities/profile.entity';
import { AuditBlock } from '../database/entities/audit_block.entity';
import { BlockchainService } from '../database/services/blockchain.service';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User) private readonly userRepo: Repository<User>,
    @InjectRepository(UserProfile) private readonly profileRepo: Repository<UserProfile>,
    @InjectRepository(AuditBlock) private readonly auditRepo: Repository<AuditBlock>,
    private readonly blockchainService: BlockchainService,
  ) {}

  /// Record an incoming user/auth/payment event into the immutable blockchain audit table
  async logEvent(dto: { actionType: string; userId: string; userEmail: string; name?: string; details?: any }) {
    const block = await this.blockchainService.recordBlock(dto.actionType, {
      userId: dto.userId,
      email: dto.userEmail,
      name: dto.name || '',
      details: dto.details || {},
      loggedAt: new Date().toISOString(),
    });

    // Also sync to User repository if not exists
    let user = await this.userRepo.findOne({ where: { email: dto.userEmail } });
    if (!user && dto.userEmail) {
      user = this.userRepo.create({
        firebaseUid: dto.userId,
        email: dto.userEmail,
      });
      await this.userRepo.save(user);
    }

    return { success: true, blockIndex: block.blockIndex, hash: block.hash };
  }

  /// Exports all system records (Users, Profiles, Audit Logs) as formatted SQL INSERT statements
  async exportFormattedSqlStatements(): Promise<string> {
    const users = await this.userRepo.find();
    const profiles = await this.profileRepo.find();
    const blocks = await this.auditRepo.find({ order: { blockIndex: 'ASC' } });

    let sql = `-- ASTROSAATHI AUTOMATED DEVELOPER SQL DATA DUMP\n`;
    sql += `-- Generated At: ${new Date().toISOString()}\n\n`;

    sql += `-- ==========================================\n`;
    sql += `-- TABLE: users\n`;
    sql += `-- ==========================================\n`;
    for (const u of users) {
      sql += `INSERT INTO users (id, firebaseUid, email, createdAt) VALUES ('${u.id}', '${u.firebaseUid}', '${u.email}', '${u.createdAt.toISOString()}');\n`;
    }

    sql += `\n-- ==========================================\n`;
    sql += `-- TABLE: user_profiles\n`;
    sql += `-- ==========================================\n`;
    for (const p of profiles) {
      const dobStr = p.dob ? (p.dob instanceof Date ? p.dob.toISOString() : new Date(p.dob).toISOString()) : '';
      const weightsStr = JSON.stringify(p.focusWeights || {}).replace(/'/g, "''");
      const createdStr = p.createdAt ? (p.createdAt instanceof Date ? p.createdAt.toISOString() : new Date(p.createdAt).toISOString()) : '';
      sql += `INSERT INTO user_profiles (id, name, dob, birthTime, birthLatitude, birthLongitude, birthTimeZone, focusWeights, createdAt) VALUES ('${p.id}', '${p.name || ''}', '${dobStr}', '${p.birthTime || ''}', ${p.birthLatitude || 0.0}, ${p.birthLongitude || 0.0}, '${p.birthTimeZone || ''}', '${weightsStr}', '${createdStr}');\n`;
    }

    sql += `\n-- ==========================================\n`;
    sql += `-- TABLE: audit_blocks (Immutable Blockchain Ledger)\n`;
    sql += `-- ==========================================\n`;
    for (const b of blocks) {
      const cleanPayload = (b.dataPayload || '').replace(/'/g, "''");
      sql += `INSERT INTO audit_blocks (blockIndex, actionType, dataPayload, previousHash, hash, nonce, timestamp) VALUES (${b.blockIndex}, '${b.actionType}', '${cleanPayload}', '${b.previousHash}', '${b.hash}', ${b.nonce}, '${b.timestamp.toISOString()}');\n`;
    }

    return sql;
  }

  /// Renders a developer dashboard sheet in HTML table format
  async renderDeveloperSheetHtml(): Promise<string> {
    const blocks = await this.auditRepo.find({ order: { blockIndex: 'DESC' } });
    const users = await this.userRepo.find();

    let html = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>AstroSaathi Developer Data Sheet</title>
      <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #0f0c1b; color: #e2e8f0; margin: 20px; }
        h1 { color: #f59e0b; font-size: 24px; border-bottom: 2px solid #334155; padding-bottom: 10px; }
        h2 { color: #38bdf8; font-size: 18px; margin-top: 30px; }
        .btn { display: inline-block; background: #8b5cf6; color: white; padding: 10px 18px; text-decoration: none; border-radius: 8px; font-weight: bold; margin-bottom: 20px; }
        .btn:hover { background: #7c3aed; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; background: #1e1b4b; border-radius: 8px; overflow: hidden; }
        th { background: #312e81; color: #a5b4fc; text-align: left; padding: 12px; font-size: 13px; text-transform: uppercase; }
        td { padding: 12px; border-bottom: 1px solid #312e81; font-size: 13px; font-family: monospace; }
        tr:hover { background: #2e1065; }
        .tag { background: #059669; color: white; padding: 3px 8px; border-radius: 4px; font-size: 11px; }
        .tag-payment { background: #d97706; }
      </style>
    </head>
    <body>
      <h1>🔮 AstroSaathi Developer Real-time SQL Sheet</h1>
      <a href="/admin/export-sql" target="_blank" class="btn">📥 Download Raw SQL Dump</a>

      <h2>Registered Users (${users.length})</h2>
      <table>
        <thead>
          <tr>
            <th>User ID</th>
            <th>Firebase UID</th>
            <th>Email</th>
            <th>Created At</th>
          </tr>
        </thead>
        <tbody>
          ${users.map(u => `
            <tr>
              <td>${u.id}</td>
              <td>${u.firebaseUid}</td>
              <td>${u.email}</td>
              <td>${u.createdAt}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>

      <h2>Blockchain Audit Log Sheet (${blocks.length} Blocks)</h2>
      <table>
        <thead>
          <tr>
            <th>Block #</th>
            <th>Action Type</th>
            <th>Data Payload</th>
            <th>Hash (SHA-256)</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          ${blocks.map(b => `
            <tr>
              <td>#${b.blockIndex}</td>
              <td><span class="tag ${b.actionType.includes('PAYMENT') ? 'tag-payment' : ''}">${b.actionType}</span></td>
              <td>${b.dataPayload}</td>
              <td>${b.hash.substring(0, 16)}...</td>
              <td>${b.timestamp}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </body>
    </html>
    `;

    return html;
  }
}
