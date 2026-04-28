import { Controller, Get, Param, Put, Body, Post, UploadedFile, UseInterceptors, UseGuards, Req } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { UserService } from './user.service';
import { UploadService } from '../upload/upload.service';
import { JwtGuard } from '../auth/jwt.guard';

@Controller('users')
export class UserController {
  constructor(
    private userService: UserService,
    private uploadService: UploadService,
  ) {}

  @Put('profile')
  @UseGuards(JwtGuard)
  async updateProfile(@Body() body: any, @Req() req: any) {
    return this.userService.updateProfile(req.user.id, body);
  }

  @Post('avatar')
  @UseGuards(JwtGuard)
  @UseInterceptors(FileInterceptor('file'))
  async uploadAvatar(@UploadedFile() file: Express.Multer.File, @Req() req: any) {
    const result = await this.uploadService.uploadFile(file);
    return this.userService.updateProfile(req.user.id, { avatarUrl: result.secure_url });
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
