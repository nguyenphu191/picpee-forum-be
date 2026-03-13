import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('--- Seeding Tags ---');

  // 1. Create all tags
  const tagDefs = [
    // Crypto / MMO
    { name: 'Crypto', slug: 'crypto' },
    { name: 'AirDrop', slug: 'airdrop' },
    { name: 'Kiếm Tiền Online', slug: 'kiem-tien-online' },
    { name: 'MMO', slug: 'mmo' },
    { name: 'DeFi', slug: 'defi' },
    { name: 'Blockchain', slug: 'blockchain' },
    // Marketing / KOC
    { name: 'Marketing', slug: 'marketing' },
    { name: 'KOC', slug: 'koc' },
    { name: 'Affiliate', slug: 'affiliate' },
    { name: 'TikTok', slug: 'tiktok' },
    { name: 'Review Sản phẩm', slug: 'review-san-pham' },
    { name: 'Picpee', slug: 'picpee' },
    // Freelance / Kỹ năng
    { name: 'Thiết kế', slug: 'thiet-ke' },
    { name: 'Figma', slug: 'figma' },
    { name: 'UI/UX', slug: 'ui-ux' },
    { name: 'SEO', slug: 'seo' },
    { name: 'Content', slug: 'content' },
    { name: 'Viết lách', slug: 'viet-lach' },
    { name: 'Freelance', slug: 'freelance' },
    // Thảo luận chung
    { name: 'Hỏi đáp', slug: 'hoi-dap' },
    { name: 'Chia sẻ', slug: 'chia-se' },
    { name: 'Kinh nghiệm', slug: 'kinh-nghiem' },
    { name: 'Hướng dẫn', slug: 'huong-dan' },
    { name: 'Thông báo', slug: 'thong-bao' },
  ];

  const tags: Record<string, { id: string }> = {};
  for (const td of tagDefs) {
    const tag = await prisma.tag.upsert({
      where: { slug: td.slug },
      update: {},
      create: { name: td.name, slug: td.slug }
    });
    tags[td.slug] = tag;
  }
  console.log(`Created ${Object.keys(tags).length} tags.`);

  // 2. Map tags to existing threads by slug
  const threadTagMap: Record<string, string[]> = {
    // --- From seed-demo.ts ---
    'keo-airdrop-50-do-cuc-uy-tin': ['crypto', 'airdrop', 'kiem-tien-online', 'mmo'],
    'bo-tai-lieu-hoc-ui-ux-free':   ['thiet-ke', 'figma', 'ui-ux', 'chia-se', 'huong-dan'],
    'dich-vu-content-seo-gia-re':   ['seo', 'content', 'viet-lach', 'freelance'],
    'quy-dinh-rut-tien-moi-nhat':   ['thong-bao', 'picpee', 'kiem-tien-online'],
    // --- From seed-initial or other boards ---
    'ra-mat-picpee-forum':          ['thong-bao', 'picpee', 'chia-se'],
    'chia-se-kinh-nghiem-airdrop':  ['crypto', 'airdrop', 'kinh-nghiem', 'mmo'],
    'huong-dan-tham-gia-koc-picpee':['koc', 'marketing', 'picpee', 'huong-dan', 'affiliate'],
    'review-tai-ngan-hang-so-mb':   ['review-san-pham', 'chia-se', 'kinh-nghiem'],
    'hoi-dap-rut-tien':             ['hoi-dap', 'kiem-tien-online', 'picpee'],
  };

  let connected = 0;
  for (const [threadSlug, tagSlugs] of Object.entries(threadTagMap)) {
    const thread = await prisma.thread.findUnique({ where: { slug: threadSlug } });
    if (!thread) {
      console.log(`  ⚠️  Thread not found: ${threadSlug}, skipping.`);
      continue;
    }
    const tagIds = tagSlugs.map(s => tags[s]).filter(Boolean).map(t => ({ id: t.id }));
    await prisma.thread.update({
      where: { id: thread.id },
      data: { tags: { set: tagIds } }
    });
    connected++;
    console.log(`  ✅ Tagged "${threadSlug}" with [${tagSlugs.join(', ')}]`);
  }

  // 3. Also add tags to ALL remaining threads based on their board slug (auto-tag)
  const boardTagMap: Record<string, string[]> = {
    'share-earn-tips':     ['kiem-tien-online', 'affiliate', 'mmo'],
    'thiet-ke-do-hoa':    ['thiet-ke', 'freelance', 'ui-ux'],
    'viet-lach-content':  ['content', 'seo', 'viet-lach', 'freelance'],
    'ra-mat-thanh-vien':  ['thong-bao', 'picpee'],
    'koc-review':         ['koc', 'marketing', 'review-san-pham', 'tiktok'],
    'thao-luan-chung':    ['hoi-dap', 'chia-se'],
  };

  const allThreads = await prisma.thread.findMany({ include: { board: true, tags: true } });
  for (const thread of allThreads) {
    // Only auto-tag threads with no tags yet
    if (thread.tags.length === 0) {
      const boardAutoTags: string[] = boardTagMap[thread.board.slug] || ['chia-se'];
      const tagIds = boardAutoTags.map((s: string) => tags[s]).filter(Boolean).map((t: { id: string }) => ({ id: t.id }));
      if (tagIds.length > 0) {
        await prisma.thread.update({
          where: { id: thread.id },
          data: { tags: { connect: tagIds } }
        });
        console.log(`  🏷  Auto-tagged "${thread.slug}"`);
      }
    }
  }

  console.log(`\n--- Tag Seeding Done! ${connected} threads explicitly tagged. ---`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
