import { IsNotEmpty, IsUrl, IsString, IsOptional } from 'class-validator';

export class CreateShareTaskDto {
  @IsNotEmpty()
  @IsUrl()
  sharedUrl: string;

  @IsNotEmpty()
  @IsString()
  threadId: string;

  @IsOptional()
  @IsString()
  proofNote?: string;
}
