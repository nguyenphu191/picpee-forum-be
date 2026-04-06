import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';
import * as bcrypt from 'bcrypt';
import admin from './firebase-admin';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

  async register(dto: RegisterDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email đã tồn tại');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const verificationToken = Math.random().toString(36).substring(2, 15);

    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        password: hashedPassword,
        username: dto.username || dto.email.split('@')[0],
        verificationToken,
      },
    });

    // TODO: Send verification email
    
    const { password, ...result } = user;
    return result;
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    if (!user.password) {
      throw new UnauthorizedException('Tài khoản này đăng nhập bằng Google/Github. Vui lòng dùng SSO.');
    }

    const isMatch = await bcrypt.compare(dto.password, user.password);
    if (!isMatch) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    const { password, ...result } = user;
    return result;
  }

  async firebaseLogin(idToken: string) {
    const decoded = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture, firebase: fb } = decoded;
    const provider = (fb.sign_in_provider as string).replace('.com', '');

    let user = await this.prisma.user.findFirst({
      where: { OR: [{ providerId: uid }, { email: email! }] },
    });

    if (!user) {
      user = await this.prisma.user.create({
        data: {
          email: email!,
          username: name || email!.split('@')[0],
          avatarUrl: picture,
          provider,
          providerId: uid,
          emailVerified: true,
        },
      });
      await this.prisma.wallet.create({ data: { userId: user.id } });
    } else if (!user.providerId) {
      user = await this.prisma.user.update({
        where: { id: user.id },
        data: { provider, providerId: uid, emailVerified: true },
      });
    }

    const { password, ...result } = user;
    return result;
  }

  async getUserById(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) return null;
    const { password, ...result } = user;
    return result;
  }
}

