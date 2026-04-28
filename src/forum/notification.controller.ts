import { Controller, Get, Post, Param, UseGuards, Req } from '@nestjs/common';
import { ForumService } from './forum.service';
import { JwtGuard } from '../auth/jwt.guard';

@Controller('notifications')
export class NotificationController {
  constructor(private forumService: ForumService) {}

  @Get()
  @UseGuards(JwtGuard)
  async getNotifications(@Req() req: any) {
    return this.forumService.getNotifications(req.user.id);
  }

  @Post(':id/read')
  @UseGuards(JwtGuard)
  async markAsRead(@Param('id') id: string) {
    return this.forumService.markNotificationAsRead(id);
  }

  @Post('read-all')
  @UseGuards(JwtGuard)
  async markAllAsRead(@Req() req: any) {
    return this.forumService.markAllNotificationsAsRead(req.user.id);
  }
}
