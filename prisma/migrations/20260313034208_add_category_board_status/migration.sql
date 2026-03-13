-- AlterTable
ALTER TABLE "Board" ADD COLUMN     "status" TEXT NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE "Category" ADD COLUMN     "status" TEXT NOT NULL DEFAULT 'ACTIVE';
