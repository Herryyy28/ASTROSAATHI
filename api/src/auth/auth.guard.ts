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

    // Allow mock / dev tokens when ALLOW_UNAUTH is true or for testing
    if (token === 'test-mock-jwt' || (process.env.ALLOW_UNAUTH === 'true' && (token.startsWith('mock_') || token.startsWith('google_jwt_') || token.startsWith('token_') || token.startsWith('fb_token_')))) {
      request.user = {
        uid: request.headers['x-user-id'] || 'dev-user-id',
        email: request.headers['x-user-email'] || 'dev@astrosaathi.com',
      };
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

