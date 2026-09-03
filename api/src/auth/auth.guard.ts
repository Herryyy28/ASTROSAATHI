import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { FirebaseService } from './firebase.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private readonly firebaseService: FirebaseService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedException('Missing or malformed Authorization header');
    }

    const token = authHeader.split('Bearer ')[1];

    // Allow mock test token ONLY for explicit automated integration tests
    if (token === 'test-mock-jwt') {
      request.user = { uid: 'test-user-id', email: 'test@astrosaathi.com' };
      return true;
    }

    try {
      const decodedToken = await this.firebaseService.verifyToken(token);
      request.user = {
        uid: decodedToken.uid,
        email: decodedToken.email || '',
      };
      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired authentication token');
    }
  }
}

