import { Controller, Get, Param, Post, Body, Session, UnauthorizedException, Query } from '@nestjs/common';
import { ForumService } from './forum.service';
import { CreateThreadDto } from './dto/forum.dto';
import { CreatePostDto } from './dto/post.dto';
import { ToggleLikeDto } from './dto/like.dto';
import { CreateShareTaskDto } from './dto/share.dto';

@Controller('forum')
export class ForumController {
  constructor(private forumService: ForumService) {}

  @Get('categories')
  async getCategories() {
    return this.forumService.getCategories();
  }

  @Get('tags')
  async getTags() {
    return this.forumService.getAllTags();
  }

  @Get('tags/:slug')
  async getTag(@Param('slug') slug: string) {
    return this.forumService.getTagBySlug(slug);
  }

  @Get('boards/:slug')
  async getBoard(
    @Param('slug') slug: string,
    @Query('page') page: string,
    @Query('limit') limit: string
  ) {
    const pageNumber = parseInt(page) || 1;
    const limitNumber = parseInt(limit) || 10;
    return this.forumService.getBoard(slug, pageNumber, limitNumber);
  }

  @Get('threads/:slug')
  async getThread(@Param('slug') slug: string) {
    return this.forumService.getThreadBySlug(slug);
  }

  @Get('threads/:slug/related')
  async getRelatedThreads(@Param('slug') slug: string) {
    return this.forumService.getRelatedThreads(slug);
  }

  @Post('threads')
  async createThread(@Body() dto: CreateThreadDto, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn cần đăng nhập để tạo bài viết');
    }
    return this.forumService.createThread({ ...dto, authorId: session.userId });
  }

  @Post('posts')
  async createPost(@Body() dto: CreatePostDto, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn cần đăng nhập để bình luận');
    }
    return this.forumService.createPost({ ...dto, authorId: session.userId });
  }

  @Post('likes/toggle')
  async toggleLike(@Body() dto: ToggleLikeDto, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn cần đăng nhập để thả tim');
    }
    return this.forumService.toggleLike({ ...dto, userId: session.userId });
  }

  @Post('share/submit')
  async submitShare(@Body() dto: CreateShareTaskDto, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn cần đăng nhập để tham gia marketing');
    }
    return this.forumService.createShareTask({ ...dto, userId: session.userId });
  }

  @Get('me/tasks')
  async getMyTasks(@Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    return this.forumService.getUserShareTasks(session.userId);
  }

  @Get('me/wallet')
  async getMyWallet(@Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    return this.forumService.getUserWallet(session.userId);
  }

  @Post('me/withdraw')
  async withdraw(@Body() body: { amount: number }, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    try {
       return await this.forumService.requestWithdrawal(session.userId, body.amount);
    } catch (err: any) {
       throw new UnauthorizedException(err.message);
    }
  }

  @Get('trending')
  async getTrending() {
    return this.forumService.getTrendingThreads();
  }

  @Get('admin/analytics')
  async getAdminAnalytics(@Session() session: any) {
    // Basic role check
    if (!session.userId || session.role !== 'ADMIN') {
       throw new UnauthorizedException('Bạn không có quyền truy cập');
    }
    return this.forumService.getAnalyticsStats();
  }

  @Get('me/threads')
  async getMyThreads(@Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    return this.forumService.getUserThreads(session.userId);
  }

  @Post('me/threads/:id/delete')
  async deleteThread(@Param('id') id: string, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    return this.forumService.deleteThread(id, session.userId);
  }

  @Post('me/threads/:id/update')
  async updateThread(@Param('id') id: string, @Body() dto: any, @Session() session: any) {
    if (!session.userId) {
      throw new UnauthorizedException('Bạn chưa đăng nhập');
    }
    return this.forumService.updateThread(id, session.userId, dto);
  }
}
