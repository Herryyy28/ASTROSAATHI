import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);

  constructor() {
    if (!admin.apps.length) {
      try {
        admin.initializeApp({
          credential: admin.credential.applicationDefault(), // Assumes GOOGLE_APPLICATION_CREDENTIALS is set
        });
        this.logger.log('Firebase Admin initialized successfully.');
      } catch (error) {
        this.logger.error('Failed to initialize Firebase Admin', error);
      }
    }
  }

  async verifyToken(token: string): Promise<admin.auth.DecodedIdToken> {
    return admin.auth().verifyIdToken(token);
  }
}
