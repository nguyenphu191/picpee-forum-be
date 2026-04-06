import { Injectable, NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async getUserProfile(username: string) {
    const user = await this.prisma.user.findFirst({
      where: { username },
      include: {
        threads: {
          take: 10,
          orderBy: { createdAt: 'desc' },
          include: { 
            board: { select: { slug: true, name: true } },
            _count: { select: { posts: true, likes: true } }
          }
        },
        posts: {
          take: 10,
          orderBy: { createdAt: 'desc' },
          include: { 
            thread: { select: { slug: true, title: true } },
            _count: { select: { likes: true } }
          }
        },
        badges: {
          include: { badge: true }
        },
        _count: {
          select: { threads: true, posts: true, likes: true }
        }
      }
    });

    if (!user) throw new NotFoundException('Không tìm thấy người dùng');
    
    const { password, email, ...result } = user;
    return result;
  }

  async updateProfile(userId: string, data: {
    username?: string,
    avatarUrl?: string,
    signature?: string,
    password?: string,
    phoneNumber?: string,
    bankName?: string,
    bankAccountNumber?: string,
    bankAccountName?: string
  }) {
    const updateData: any = {};

    if (data.username !== undefined) {
      const trimmed = data.username.trim();
      if (trimmed.length < 3 || trimmed.length > 30) {
        throw new BadRequestException('Tên người dùng phải từ 3 đến 30 ký tự');
      }
      if (!/^[a-zA-Z0-9_]+$/.test(trimmed)) {
        throw new BadRequestException('Tên người dùng chỉ được chứa chữ cái, số và dấu gạch dưới');
      }
      const existing = await this.prisma.user.findFirst({
        where: { username: trimmed, NOT: { id: userId } }
      });
      if (existing) throw new ConflictException('Tên người dùng đã được sử dụng');
      updateData.username = trimmed;
    }

    if (data.avatarUrl) updateData.avatarUrl = data.avatarUrl;
    if (data.signature !== undefined) updateData.signature = data.signature;
    if (data.phoneNumber !== undefined) updateData.phoneNumber = data.phoneNumber;
    if (data.bankName !== undefined) updateData.bankName = data.bankName;
    if (data.bankAccountNumber !== undefined) updateData.bankAccountNumber = data.bankAccountNumber;
    if (data.bankAccountName !== undefined) updateData.bankAccountName = data.bankAccountName;
    
    if (data.password) {
      updateData.password = await bcrypt.hash(data.password, 10);
    }

    const updatedUser = await this.prisma.user.update({
      where: { id: userId },
      data: updateData
    });

    const { password: _, ...result } = updatedUser;
    return result;
  }
  async getLeaderboard() {
    return this.prisma.user.findMany({
      where: {
        role: { not: 'ADMIN' },
        status: 'ACTIVE'
      },
      orderBy: { reputation: 'desc' },
      take: 5,
      select: {
        id: true,
        username: true,
        avatarUrl: true,
        reputation: true,
      }
    });
  }
}
