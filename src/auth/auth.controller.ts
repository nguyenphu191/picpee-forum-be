import { Controller, Post, Body, Session, Get, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  async login(@Body() dto: LoginDto, @Session() session: any) {
    const user = await this.authService.login(dto);
    session.userId = user.id;
    session.role = user.role;
    return user;
  }

  @Post('logout')
  logout(@Session() session: any) {
    session.destroy();
    return { message: 'Đăng xuất thành công' };
  }

  @Get('me')
  async me(@Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Chưa đăng nhập');
    }
    const user = await this.authService.getUserById(session.userId);
    if (!user) throw new UnauthorizedException('Người dùng không tồn tại');
    return user;
  }
}
