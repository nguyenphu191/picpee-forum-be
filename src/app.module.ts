import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { ForumModule } from './forum/forum.module';
import { AdminModule } from './admin/admin.module';
import { UserModule } from './user/user.module';
import { UploadModule } from './upload/upload.module';

@Module({
  imports: [PrismaModule, AuthModule, ForumModule, AdminModule, UserModule, UploadModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
