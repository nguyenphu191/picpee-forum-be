import { Controller, Get, Param, Post, Body, UnauthorizedException, Query, UseGuards, Req } from '@nestjs/common';
import { ForumService } from './forum.service';
import { CreateThreadDto } from './dto/forum.dto';
import { CreatePostDto } from './dto/post.dto';
import { ToggleLikeDto } from './dto/like.dto';
import { CreateShareTaskDto } from './dto/share.dto';
import { JwtGuard, AdminGuard } from '../auth/jwt.guard';

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
  @UseGuards(JwtGuard)
  async createThread(@Body() dto: CreateThreadDto, @Req() req: any) {
    return this.forumService.createThread({ ...dto, authorId: req.user.id });
  }

  @Post('posts')
  @UseGuards(JwtGuard)
  async createPost(@Body() dto: CreatePostDto, @Req() req: any) {
    return this.forumService.createPost({ ...dto, authorId: req.user.id });
  }

  @Post('likes/toggle')
  @UseGuards(JwtGuard)
  async toggleLike(@Body() dto: ToggleLikeDto, @Req() req: any) {
    return this.forumService.toggleLike({ ...dto, userId: req.user.id });
  }

  @Post('share/submit')
  @UseGuards(JwtGuard)
  async submitShare(@Body() dto: CreateShareTaskDto, @Req() req: any) {
    return this.forumService.createShareTask({ ...dto, userId: req.user.id });
  }

  @Get('me/tasks')
  @UseGuards(JwtGuard)
  async getMyTasks(@Req() req: any) {
    return this.forumService.getUserShareTasks(req.user.id);
  }

  @Get('me/wallet')
  @UseGuards(JwtGuard)
  async getMyWallet(@Req() req: any) {
    return this.forumService.getUserWallet(req.user.id);
  }

  @Post('me/withdraw')
  @UseGuards(JwtGuard)
  async withdraw(@Body() body: { amount: number }, @Req() req: any) {
    try {
      return await this.forumService.requestWithdrawal(req.user.id, body.amount);
    } catch (err: any) {
      throw new UnauthorizedException(err.message);
    }
  }

  @Get('trending')
  async getTrending() {
    return this.forumService.getTrendingThreads();
  }

  @Get('admin/analytics')
  @UseGuards(AdminGuard)
  async getAdminAnalytics() {
    return this.forumService.getAnalyticsStats();
  }

  @Post('bookmarks/toggle')
  @UseGuards(JwtGuard)
  async toggleBookmark(@Body('threadId') threadId: string, @Req() req: any) {
    return this.forumService.toggleBookmark(threadId, req.user.id);
  }

  @Get('me/bookmarks')
  @UseGuards(JwtGuard)
  async getMyBookmarks(@Req() req: any) {
    return this.forumService.getUserBookmarks(req.user.id);
  }

  @Get('bookmarks/check/:threadId')
  async checkBookmark(@Param('threadId') threadId: string, @Req() req: any) {
    const authHeader = req.headers['authorization'];
    if (!authHeader) return { bookmarked: false };
    try {
      const jwt = require('jsonwebtoken');
      const payload = jwt.verify(authHeader.split(' ')[1], process.env.JWT_SECRET || 'picpee-jwt-secret') as any;
      return this.forumService.isBookmarked(threadId, payload.sub);
    } catch {
      return { bookmarked: false };
    }
  }

  @Get('me/threads')
  @UseGuards(JwtGuard)
  async getMyThreads(@Req() req: any) {
    return this.forumService.getUserThreads(req.user.id);
  }

  @Post('me/threads/:id/delete')
  @UseGuards(JwtGuard)
  async deleteThread(@Param('id') id: string, @Req() req: any) {
    return this.forumService.deleteThread(id, req.user.id);
  }

  @Post('me/threads/:id/update')
  @UseGuards(JwtGuard)
  async updateThread(@Param('id') id: string, @Body() dto: any, @Req() req: any) {
    return this.forumService.updateThread(id, req.user.id, dto);
  }
}
