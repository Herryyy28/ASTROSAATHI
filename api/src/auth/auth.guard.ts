import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { FirebaseService } from './firebase.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private readonly firebaseService: FirebaseService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      // Allow development override or throw error
      if (process.env.NODE_ENV !== 'production' && process.env.ALLOW_UNAUTH === 'true') {
         request.user = { uid: 'dev-user-id', email: 'dev@astrosaathi.com' };
         return true;
      }
      throw new UnauthorizedException('Missing or invalid Authorization header');
    }

    const token = authHeader.split('Bearer ')[1];

    try {
      const decodedToken = await this.firebaseService.verifyToken(token);
      request.user = {
        uid: decodedToken.uid,
        email: decodedToken.email,
      };
      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid Firebase Token');
    }
  }
}
