import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  app.setGlobalPrefix('api/v1');
  await app.listen(3000, '0.0.0.0');
  console.log('AstroSaathi API is running on: http://0.0.0.0:3000/api/v1');
}
bootstrap();
