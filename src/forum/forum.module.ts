import { Module } from '@nestjs/common';
import { ForumService } from './forum.service';
import { ForumController } from './forum.controller';
import { NotificationController } from './notification.controller';

@Module({
  providers: [ForumService],
  controllers: [ForumController, NotificationController]
})
export class ForumModule {}
