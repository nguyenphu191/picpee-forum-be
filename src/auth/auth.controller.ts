import { Controller, Post, Body, Get, UnauthorizedException, BadRequestException, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';
import { JwtGuard } from './jwt.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('firebase')
  async firebaseLogin(@Body('idToken') idToken: string) {
    if (!idToken) throw new BadRequestException('idToken is required');
    return this.authService.firebaseLogin(idToken);
  }

  @Post('logout')
  logout() {
    return { message: 'Đăng xuất thành công' };
  }

  @Get('me')
  @UseGuards(JwtGuard)
  async me(@Req() req: any) {
    const user = await this.authService.getUserById(req.user.id);
    if (!user) throw new UnauthorizedException('Người dùng không tồn tại');
    return user;
  }
}
