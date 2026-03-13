import { Controller, Get, Post, Param, Session, UnauthorizedException } from '@nestjs/common';
import { ForumService } from './forum.service';

@Controller('notifications')
export class NotificationController {
  constructor(private forumService: ForumService) {}

  @Get()
  async getNotifications(@Session() session: any) {
    if (!session.userId) throw new UnauthorizedException();
    return this.forumService.getNotifications(session.userId);
  }

  @Post(':id/read')
  async markAsRead(@Param('id') id: string, @Session() session: any) {
    if (!session.userId) throw new UnauthorizedException();
    return this.forumService.markNotificationAsRead(id);
  }

  @Post('read-all')
  async markAllAsRead(@Session() session: any) {
    if (!session.userId) throw new UnauthorizedException();
    return this.forumService.markAllNotificationsAsRead(session.userId);
  }
}
