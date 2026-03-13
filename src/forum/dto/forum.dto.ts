import { IsNotEmpty, IsString, MinLength, IsOptional, IsArray } from 'class-validator';

export class CreateThreadDto {
  @IsNotEmpty()
  @IsString()
  @MinLength(5)
  title: string;

  @IsNotEmpty()
  @IsString()
  @MinLength(10)
  content: string;

  @IsNotEmpty()
  @IsString()
  boardId: string;

  @IsOptional()
  @IsArray()
  tags?: string[];
}
