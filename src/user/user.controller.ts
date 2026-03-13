import { Controller, Get, Param, Put, Body, Session, UnauthorizedException, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { UserService } from './user.service';
import { UploadService } from '../upload/upload.service';

@Controller('users')
export class UserController {
  constructor(
    private userService: UserService,
    private uploadService: UploadService,
  ) {}

  @Put('profile')
  async updateProfile(@Body() body: any, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Please login first');
    }
    return this.userService.updateProfile(session.userId, body);
  }

  @Post('avatar')
  @UseInterceptors(FileInterceptor('file'))
  async uploadAvatar(@UploadedFile() file: Express.Multer.File, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Please login first');
    }
    const result = await this.uploadService.uploadFile(file);
    return this.userService.updateProfile(session.userId, { avatarUrl: result.secure_url });
  }

  @Get('leaderboard')
  async getLeaderboard() {
    return this.userService.getLeaderboard();
  }

  @Get(':username')
  async getUserProfile(@Param('username') username: string) {
    return this.userService.getUserProfile(username);
  }
}
