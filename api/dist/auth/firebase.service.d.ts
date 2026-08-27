import * as admin from 'firebase-admin';
export declare class FirebaseService {
    private readonly logger;
    constructor();
    verifyToken(token: string): Promise<admin.auth.DecodedIdToken>;
}
