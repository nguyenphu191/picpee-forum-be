import { IsNotEmpty, IsString, IsEnum, IsOptional } from 'class-validator';

export class ToggleLikeDto {
  @IsOptional()
  @IsString()
  threadId?: string;

  @IsOptional()
  @IsString()
  postId?: string;
}
