--
-- PostgreSQL database dump
--

\restrict 44swsDPU5S5oHZsHyJ4aVyahotcw8Gcbh8pLK8hes630YyIqH1NAIfqtokkLIRo

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: Role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'MODERATOR',
    'ADMIN'
);


ALTER TYPE public."Role" OWNER TO postgres;

--
-- Name: ShareTaskStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ShareTaskStatus" AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'PAID'
);


ALTER TYPE public."ShareTaskStatus" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Analytics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Analytics" (
    id text NOT NULL,
    "threadId" text NOT NULL,
    "eventType" text NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Analytics" OWNER TO postgres;

--
-- Name: Badge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Badge" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "iconUrl" text
);


ALTER TABLE public."Badge" OWNER TO postgres;

--
-- Name: Board; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Board" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    slug text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "categoryId" text NOT NULL,
    status text DEFAULT 'ACTIVE'::text NOT NULL
);


ALTER TABLE public."Board" OWNER TO postgres;

--
-- Name: Bookmark; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Bookmark" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "threadId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Bookmark" OWNER TO postgres;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    slug text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status text DEFAULT 'ACTIVE'::text NOT NULL
);


ALTER TABLE public."Category" OWNER TO postgres;

--
-- Name: Follow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Follow" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Follow" OWNER TO postgres;

--
-- Name: Like; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Like" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "threadId" text,
    "postId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Like" OWNER TO postgres;

--
-- Name: Notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Notification" (
    id text NOT NULL,
    "receiverId" text NOT NULL,
    "senderId" text,
    type text NOT NULL,
    content text NOT NULL,
    link text,
    metadata jsonb,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Notification" OWNER TO postgres;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Post" (
    id text NOT NULL,
    content text NOT NULL,
    "parentId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "threadId" text NOT NULL,
    "authorId" text NOT NULL
);


ALTER TABLE public."Post" OWNER TO postgres;

--
-- Name: Report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Report" (
    id text NOT NULL,
    "reporterId" text NOT NULL,
    "threadId" text,
    "postId" text,
    reason text NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Report" OWNER TO postgres;

--
-- Name: ShareTask; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ShareTask" (
    id text NOT NULL,
    "sharedUrl" text NOT NULL,
    status public."ShareTaskStatus" DEFAULT 'PENDING'::public."ShareTaskStatus" NOT NULL,
    "proofNote" text,
    "rewardAmount" numeric(20,2) NOT NULL,
    "approvedAt" timestamp(3) without time zone,
    "paymentDueAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "userId" text NOT NULL,
    "threadId" text NOT NULL
);


ALTER TABLE public."ShareTask" OWNER TO postgres;

--
-- Name: Tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tag" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Tag" OWNER TO postgres;

--
-- Name: Thread; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Thread" (
    id text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    slug text NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    "isPinned" boolean DEFAULT false NOT NULL,
    "isLocked" boolean DEFAULT false NOT NULL,
    "isFeatured" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "boardId" text NOT NULL,
    "authorId" text NOT NULL
);


ALTER TABLE public."Thread" OWNER TO postgres;

--
-- Name: Transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transaction" (
    id text NOT NULL,
    amount numeric(20,2) NOT NULL,
    type text NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "walletId" text NOT NULL
);


ALTER TABLE public."Transaction" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    "emailVerified" boolean DEFAULT false NOT NULL,
    "verificationToken" text,
    username text,
    "avatarUrl" text,
    signature text,
    role public."Role" DEFAULT 'USER'::public."Role" NOT NULL,
    reputation integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    password text NOT NULL,
    "phoneNumber" text,
    "bankName" text,
    "bankAccountNumber" text,
    "bankAccountName" text,
    status text DEFAULT 'ACTIVE'::text NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: UserBadge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserBadge" (
    "userId" text NOT NULL,
    "badgeId" text NOT NULL,
    "grantedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."UserBadge" OWNER TO postgres;

--
-- Name: Wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Wallet" (
    id text NOT NULL,
    balance numeric(20,2) DEFAULT 0 NOT NULL,
    "pendingBalance" numeric(20,2) DEFAULT 0 NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "userId" text NOT NULL
);


ALTER TABLE public."Wallet" OWNER TO postgres;

--
-- Name: _ThreadTags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_ThreadTags" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_ThreadTags" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Data for Name: Analytics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Analytics" (id, "threadId", "eventType", "ipAddress", "userAgent", "createdAt") FROM stdin;
9a7379f1-547b-4a5e-ae5c-d5ec7cfecc8b	a6f671c8-a1ef-4988-942d-64fbf2d78931	CLICK	\N	\N	2026-03-13 03:12:41.898
e05a0657-83e3-4f24-8227-ebb701c73767	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:13:31.274
f6389ead-769c-45c8-803f-f30a499b9f15	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:21:53.255
d803b787-dfb8-4ec1-af8f-c62096a2f863	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:21:53.754
897e1250-ef1d-4dcc-ae6f-132907285325	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:22:11.464
8b348f1e-8e88-4514-9a71-5747588643ef	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:31:46.006
7e67ee72-f2b3-4fc6-8eb4-89884cad2165	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:31:46.788
c72ac7ec-22a6-4fdf-a6bd-a56c9eb125d5	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:31:47.283
f614037f-578f-41df-ba69-ffef50de51fd	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:31:47.757
3ead6afc-fa8c-4c6d-a205-7ebf056fa841	bd97094a-f95b-47d3-89dd-c65ab0cac84d	CLICK	\N	\N	2026-03-13 03:31:48.311
e581a160-66b6-4a30-b6cf-616d3aa43884	f86a0872-4aa8-43e5-9c35-8224d8bb5c2a	CLICK	\N	\N	2026-03-13 03:38:23.41
307941f6-9afc-464b-be8d-5dab8b9b4627	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 05:29:02.253
4d406258-d06d-4121-b914-88f668538bfa	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 05:29:20.359
4911e3b0-56e4-405c-8f6a-d17a83c4f111	a6f671c8-a1ef-4988-942d-64fbf2d78931	CLICK	\N	\N	2026-03-13 05:42:55.452
1c77e941-4139-452c-8866-7fa5203c26c1	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 06:16:07.921
4d759586-2d03-4c3a-9fad-1328a162526b	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 06:16:36.634
ed2d8784-7a5d-4ed6-88f8-5918558c3d3e	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 06:16:46.003
5747f668-952a-4d5e-a933-875ff817ebe7	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 06:17:30.644
0ad359c7-2cf9-4093-a098-b617de63c526	f86a0872-4aa8-43e5-9c35-8224d8bb5c2a	CLICK	\N	\N	2026-03-13 06:47:37.401
d4296606-25e6-47d1-aa3c-77b5f9610549	a6f671c8-a1ef-4988-942d-64fbf2d78931	CLICK	\N	\N	2026-03-13 07:10:27.683
793e287d-5539-43b5-836a-93f2f7ef2444	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:05:16.035
5c6dbc2c-5ae3-44d3-acf2-3b6a73737ff0	707c7121-b56a-4848-a38c-370ea4e754ac	CLICK	\N	\N	2026-03-13 08:26:54.826
84c76295-7dda-43ee-856c-551839527631	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:27:55.688
04604198-83b3-4cd9-824a-f3477cdaabaf	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:28:54.886
90050774-cf54-4d18-ab14-4ccb038f69a4	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:32:28.654
ff2fc7cf-331a-4441-b185-203bef9b3698	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:32:44.106
69139700-52a6-4c10-9036-a9f877caa6e4	21dda81a-868f-414d-849f-0cc6c7fe743d	CLICK	\N	\N	2026-03-13 08:40:05.22
06a97d00-5a21-44aa-979d-dd2e10aa55a1	cca89eae-e11c-46d9-af38-326d875b7ddd	CLICK	\N	\N	2026-03-13 09:46:15.249
\.


--
-- Data for Name: Badge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Badge" (id, name, description, "iconUrl") FROM stdin;
\.


--
-- Data for Name: Board; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Board" (id, name, description, slug, "order", "createdAt", "categoryId", status) FROM stdin;
ea8708a3-22f7-4924-ad73-5310d5693c7d	Ra mß║»t th├ánh vi├¬n	Bß║ín mß╗¢i gia nhß║¡p? H├úy giß╗¢i thiß╗çu bß║ún th├ón tß║íi ─æ├óy!	ra-mat-thanh-vien	1	2026-03-13 02:56:40.521	69e6657d-4952-45e0-967a-8aed1e9ea429	ACTIVE
a1b8ede3-aa71-4b06-a37a-c4f653840aea	Mß║╣o Share & Earn	C├ích tß╗æi ╞░u h├│a thu nhß║¡p tß╗½ hß╗ç thß╗æng Share Task cß╗ºa Picpee.	share-earn-tips	1	2026-03-13 02:56:40.534	bd0ae490-26e9-44c1-8fc7-6bd0e6267c5a	ACTIVE
\.


--
-- Data for Name: Bookmark; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Bookmark" (id, "userId", "threadId", "createdAt") FROM stdin;
\.


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Category" (id, name, description, slug, "order", "createdAt", status) FROM stdin;
69e6657d-4952-45e0-967a-8aed1e9ea429	Thß║úo Luß║¡n Chung	N╞íi giao l╞░u, l├ám quen v├á t├ín gß║½u.	thao-luan-chung	1	2026-03-13 02:56:40.513	ACTIVE
bd0ae490-26e9-44c1-8fc7-6bd0e6267c5a	Kiß║┐m Tiß╗ün Online (MMO)	Chia sß║╗ c├íc k├¿o hot, task ngon v├á kinh nghiß╗çm kiß║┐m tiß╗ün.	kiem-tien-online	2	2026-03-13 02:56:40.53	ACTIVE
\.


--
-- Data for Name: Follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Follow" (id, "userId", "targetType", "targetId", "createdAt") FROM stdin;
\.


--
-- Data for Name: Like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Like" (id, "userId", "threadId", "postId", "createdAt") FROM stdin;
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Notification" (id, "receiverId", "senderId", type, content, link, metadata, "isRead", "createdAt") FROM stdin;
98de9217-304e-4fe4-b49a-8cb140757aae	76641def-ec09-4870-8f0d-39ae10c1b258	d24b8a9e-3caf-4370-a716-e9f63009f604	LIKE	─æ├ú th├¡ch b├ái viß║┐t cß╗ºa bß║ín: H╞░ß╗¢ng dß║½n kiß║┐m 500k mß╗ùi ng├áy tß╗½ Picpee Share Task	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	f	2026-03-13 02:58:17.077
7021dca4-d2dd-4f95-bcce-ff19a577ce89	76641def-ec09-4870-8f0d-39ae10c1b258	afcfc997-af60-4bbc-bdcf-807f56866992	REPLY	─æ├ú trß║ú lß╗¥i mß╗Öt thß║úo luß║¡n bß║ín ─æang theo d├╡i	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	f	2026-03-13 02:58:17.077
d496a6a1-34b3-4fb4-b3de-9935dcf4d38f	76641def-ec09-4870-8f0d-39ae10c1b258	\N	SYSTEM	V├¡ cß╗ºa bß║ín vß╗½a ─æ╞░ß╗úc cß╗Öng 50.000─æ tß╗½ sß╗▒ kiß╗çn ch├áo mß╗½ng!	/wallet	\N	f	2026-03-13 02:58:17.077
a61eff2f-d4db-4635-a7f1-e41609bf6496	76641def-ec09-4870-8f0d-39ae10c1b258	d24b8a9e-3caf-4370-a716-e9f63009f604	MENTION	─æ├ú nhß║»c ─æß║┐n bß║ín trong mß╗Öt b├¼nh luß║¡n	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	f	2026-03-13 02:58:17.077
92e306a5-d4ac-4bc1-84c8-5e999cb5fd89	76641def-ec09-4870-8f0d-39ae10c1b258	d24b8a9e-3caf-4370-a716-e9f63009f604	LIKE	─æ├ú th├¡ch b├ái viß║┐t cß╗ºa bß║ín: H╞░ß╗¢ng dß║½n kiß║┐m 500k mß╗ùi ng├áy tß╗½ Picpee Share Task	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	f	2026-03-13 03:19:24.22
3e834178-d9cc-45c7-af3f-75dd557c45b4	76641def-ec09-4870-8f0d-39ae10c1b258	afcfc997-af60-4bbc-bdcf-807f56866992	REPLY	─æ├ú trß║ú lß╗¥i mß╗Öt thß║úo luß║¡n bß║ín ─æang theo d├╡i	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	f	2026-03-13 03:19:24.22
a22e2d36-0059-4894-85d7-14ebd4acdb4f	76641def-ec09-4870-8f0d-39ae10c1b258	d24b8a9e-3caf-4370-a716-e9f63009f604	MENTION	─æ├ú nhß║»c ─æß║┐n bß║ín trong mß╗Öt b├¼nh luß║¡n	/thread/huong-dan-kiem-500k-moi-ngay-tu-picpee	\N	t	2026-03-13 03:19:24.22
1ead6768-d109-4147-832f-0816777425c7	76641def-ec09-4870-8f0d-39ae10c1b258	\N	SYSTEM	V├¡ cß╗ºa bß║ín vß╗½a ─æ╞░ß╗úc cß╗Öng 50.000─æ tß╗½ sß╗▒ kiß╗çn ch├áo mß╗½ng!	/wallet	\N	t	2026-03-13 03:19:24.22
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Post" (id, content, "parentId", "createdAt", "updatedAt", "threadId", "authorId") FROM stdin;
3adc548b-ff67-4441-81bb-fd0087841106	B├ái viß║┐t hß╗»u ├¡ch qu├í bß║ín ╞íi, m├¼nh vß╗½a thß╗¡ v├á ─æ├ú c├│ Task ─æß║ºu ti├¬n ─æ╞░ß╗úc duyß╗çt!	\N	2026-03-13 02:56:40.556	2026-03-13 02:56:40.556	a6f671c8-a1ef-4988-942d-64fbf2d78931	afcfc997-af60-4bbc-bdcf-807f56866992
331bd2f9-a294-4747-83af-ddfa6bfaecd7	B├ái viß║┐t hß╗»u ├¡ch qu├í bß║ín ╞íi, m├¼nh vß╗½a thß╗¡ v├á ─æ├ú c├│ Task ─æß║ºu ti├¬n ─æ╞░ß╗úc duyß╗çt!	\N	2026-03-13 02:58:17.061	2026-03-13 02:58:17.061	a6f671c8-a1ef-4988-942d-64fbf2d78931	afcfc997-af60-4bbc-bdcf-807f56866992
c141e72a-de1c-4682-a88c-2e0011e1d0f2	B├ái viß║┐t hß╗»u ├¡ch qu├í bß║ín ╞íi, m├¼nh vß╗½a thß╗¡ v├á ─æ├ú c├│ Task ─æß║ºu ti├¬n ─æ╞░ß╗úc duyß╗çt!	\N	2026-03-13 03:19:24.178	2026-03-13 03:19:24.178	a6f671c8-a1ef-4988-942d-64fbf2d78931	afcfc997-af60-4bbc-bdcf-807f56866992
bf9e25cd-4433-4104-9b34-981c63256a0b	B├¼nh luß║¡n thß╗⌐ 1 tß╗½ Member_1_929. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.135	2026-03-13 05:01:19.135	cca89eae-e11c-46d9-af38-326d875b7ddd	cfcac9f3-76cf-464f-bc1a-775296128ef5
32c29e6f-b6a9-4462-8492-38a299e45e72	B├¼nh luß║¡n thß╗⌐ 1 tß╗½ Member_1_929. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.144	2026-03-13 05:01:19.144	fce88b3f-41f1-4b9f-a15d-d3dba311d773	cfcac9f3-76cf-464f-bc1a-775296128ef5
55da1c52-8e45-4a28-aaac-12c44b875e33	B├¼nh luß║¡n thß╗⌐ 2 tß╗½ Member_4_655. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.147	2026-03-13 05:01:19.147	fce88b3f-41f1-4b9f-a15d-d3dba311d773	23266cbf-f0a3-4826-954b-79d6fe886a12
200d27ca-44f3-4455-b32b-2a82d80b8b92	B├¼nh luß║¡n thß╗⌐ 3 tß╗½ Member_3_71. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.15	2026-03-13 05:01:19.15	fce88b3f-41f1-4b9f-a15d-d3dba311d773	80f84e07-aeb2-40ef-94a6-dd132048acc7
cada5329-f0ec-4061-a73e-4d3eddbbc61d	B├¼nh luß║¡n thß╗⌐ 1 tß╗½ Member_4_655. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.157	2026-03-13 05:01:19.157	9c55616e-afb6-440c-a864-4def81fe6041	23266cbf-f0a3-4826-954b-79d6fe886a12
93e231af-6f43-4cf0-a836-6ba3167884ce	B├¼nh luß║¡n thß╗⌐ 1 tß╗½ Member_2_717. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.166	2026-03-13 05:01:19.166	479ebdc7-7817-422d-a306-58e88948beda	49f7d4de-5e27-4297-be62-f7b7ebf18c3c
c3eadb18-702e-4ca2-8e34-d3685eedf0a7	B├¼nh luß║¡n thß╗⌐ 2 tß╗½ Member_2_717. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.169	2026-03-13 05:01:19.169	479ebdc7-7817-422d-a306-58e88948beda	49f7d4de-5e27-4297-be62-f7b7ebf18c3c
bb698425-c726-4444-a350-ef42deeba02c	B├¼nh luß║¡n thß╗⌐ 1 tß╗½ Member_2_717. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.175	2026-03-13 05:01:19.175	707c7121-b56a-4848-a38c-370ea4e754ac	49f7d4de-5e27-4297-be62-f7b7ebf18c3c
74e15f1d-bec9-49f2-a2db-1d0cca20a5fa	B├¼nh luß║¡n thß╗⌐ 2 tß╗½ Member_5_55. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.177	2026-03-13 05:01:19.177	707c7121-b56a-4848-a38c-370ea4e754ac	d35b0a3b-12f1-43e3-8639-5a47c23ff369
68bbd5dc-9fff-4d34-8c0a-65dd429bd4bd	B├¼nh luß║¡n thß╗⌐ 3 tß╗½ Member_4_655. B├ái viß║┐t rß║Ñt hß╗»u ├¡ch!	\N	2026-03-13 05:01:19.179	2026-03-13 05:01:19.179	707c7121-b56a-4848-a38c-370ea4e754ac	23266cbf-f0a3-4826-954b-79d6fe886a12
\.


--
-- Data for Name: Report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Report" (id, "reporterId", "threadId", "postId", reason, status, "createdAt") FROM stdin;
\.


--
-- Data for Name: ShareTask; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ShareTask" (id, "sharedUrl", status, "proofNote", "rewardAmount", "approvedAt", "paymentDueAt", "createdAt", "updatedAt", "userId", "threadId") FROM stdin;
706fafd3-6dbc-48c3-8f49-a5011596125d	https://kenphotos.com/services/virtual-renovation	PAID	zfsasfasasf	5.00	2026-03-13 06:17:54.633	2026-03-20 06:17:54.633	2026-03-13 06:16:40.232	2026-03-13 06:18:00.271	76641def-ec09-4870-8f0d-39ae10c1b258	707c7121-b56a-4848-a38c-370ea4e754ac
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Tag" (id, name, slug, "createdAt") FROM stdin;
7559eab2-64ad-4459-9b2a-7a390877318d	Kiß║┐m Tiß╗ün	kiem-tien	2026-03-13 03:19:24.125
e7cabf8c-8a81-464c-ba4f-40ab17325431	Chia Sß║╗	chia-se	2026-03-13 03:19:24.136
34a6ceb4-c0b6-42bc-beb9-9066805e7e99	H╞░ß╗¢ng Dß║½n	huong-dan	2026-03-13 03:19:24.141
47ed9039-53dd-4cb3-b64b-6a4d6a180ea2	T├ín Gß║½u	tan-gau	2026-03-13 03:19:24.146
\.


--
-- Data for Name: Thread; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Thread" (id, title, content, slug, views, "isPinned", "isLocked", "isFeatured", "createdAt", "updatedAt", "boardId", "authorId") FROM stdin;
f86a0872-4aa8-43e5-9c35-8224d8bb5c2a	Top c├íc nß╗ün tß║úng MMO uy t├¡n 2026	B├ái viß║┐t tß╗òng hß╗úp c├íc network v├á nß╗ün tß║úng tß╗æt nhß║Ñt ─æß╗â anh em c├áy cuß╗æc trong n─âm nay.	top-cac-nen-tang-mmo-uy-tin-2026	892	f	f	f	2026-03-13 03:19:24.165	2026-03-13 06:47:37.395	a1b8ede3-aa71-4b06-a37a-c4f653840aea	76641def-ec09-4870-8f0d-39ae10c1b258
479ebdc7-7817-422d-a306-58e88948beda	Review c├íc c├┤ng cß╗Ñ hß╗ù trß╗ú l├ám viß╗çc tß╗½ xa tß╗æt nhß║Ñt	Ch├áo mß╗ìi ng╞░ß╗¥i, m├¼nh l├á Member_4_655. ─É├óy l├á nß╗Öi dung b├ái viß║┐t thß╗⌐ 4 vß╗ü chß╗º ─æß╗ü "Review c├íc c├┤ng cß╗Ñ hß╗ù trß╗ú l├ám viß╗çc tß╗½ xa tß╗æt nhß║Ñt". Hy vß╗ìng nhß║¡n ─æ╞░ß╗úc nhiß╗üu chia sß║╗ tß╗½ anh em!	bai-viet-mau-1773378079160-3	17	f	f	f	2026-03-13 05:01:19.161	2026-03-13 05:01:19.161	ea8708a3-22f7-4924-ad73-5310d5693c7d	23266cbf-f0a3-4826-954b-79d6fe886a12
a6f671c8-a1ef-4988-942d-64fbf2d78931	H╞░ß╗¢ng dß║½n kiß║┐m 500k mß╗ùi ng├áy tß╗½ Picpee Share Task	Ch├áo anh em, m├¼nh ─æ├ú tham gia Picpee ─æ╞░ß╗úc 1 th├íng v├á r├║t ─æ╞░ß╗úc h╞ín 10 triß╗çu. B├¡ quyß║┐t nß║▒m ß╗ƒ viß╗çc chß╗ìn lß╗ìc thread c├│ Share Task cao v├á chia sß║╗ l├¬n ─æ├║ng c├íc group Facebook c├│ tß╗çp user ph├╣ hß╗úp.\n      \n      B╞░ß╗¢c 1: T├¼m b├ái viß║┐t c├│ n├║t "Share & Earn".\n      B╞░ß╗¢c 2: Copy link giß╗¢i thiß╗çu c├í nh├ón.\n      B╞░ß╗¢c 3: Viß║┐t caption thu h├║t v├á ─æ─âng l├¬n MXH.\n      \n      Ch├║c anh em th├ánh c├┤ng!	huong-dan-kiem-500k-moi-ngay-tu-picpee	1253	f	f	t	2026-03-13 02:56:40.54	2026-03-13 07:10:27.678	a1b8ede3-aa71-4b06-a37a-c4f653840aea	d24b8a9e-3caf-4370-a716-e9f63009f604
707c7121-b56a-4848-a38c-370ea4e754ac	Kß╗â vß╗ü lß║ºn ─æß║ºu ti├¬n bß║ín kiß║┐m ─æ╞░ß╗úc tiß╗ün tr├¬n mß║íng	Ch├áo mß╗ìi ng╞░ß╗¥i, m├¼nh l├á Member_5_55. ─É├óy l├á nß╗Öi dung b├ái viß║┐t thß╗⌐ 5 vß╗ü chß╗º ─æß╗ü "Kß╗â vß╗ü lß║ºn ─æß║ºu ti├¬n bß║ín kiß║┐m ─æ╞░ß╗úc tiß╗ün tr├¬n mß║íng". Hy vß╗ìng nhß║¡n ─æ╞░ß╗úc nhiß╗üu chia sß║╗ tß╗½ anh em!	bai-viet-mau-1773378079170-4	17	f	f	f	2026-03-13 05:01:19.172	2026-03-13 08:26:54.818	ea8708a3-22f7-4924-ad73-5310d5693c7d	d35b0a3b-12f1-43e3-8639-5a47c23ff369
bd97094a-f95b-47d3-89dd-c65ab0cac84d	Xin ch├áo, m├¼nh l├á th├ánh vi├¬n mß╗¢i ─æß║┐n tß╗½ H├á Nß╗Öi	Rß║Ñt vui ─æ╞░ß╗úc l├ám quen vß╗¢i mß╗ìi ng╞░ß╗¥i. M├¼nh hy vß╗ìng sß║╜ hß╗ìc hß╗Åi ─æ╞░ß╗úc nhiß╗üu kinh nghiß╗çm MMO tß║íi ─æ├óy.	xin-chao-minh-la-thanh-vien-moi	54	f	f	f	2026-03-13 02:56:40.549	2026-03-13 03:31:48.307	ea8708a3-22f7-4924-ad73-5310d5693c7d	afcfc997-af60-4bbc-bdcf-807f56866992
fce88b3f-41f1-4b9f-a15d-d3dba311d773	Chia sß║╗ kinh nghiß╗çm kiß║┐m tiß╗ün tß╗½ Affiliate Marketing	Ch├áo mß╗ìi ng╞░ß╗¥i, m├¼nh l├á Member_2_717. ─É├óy l├á nß╗Öi dung b├ái viß║┐t thß╗⌐ 2 vß╗ü chß╗º ─æß╗ü "Chia sß║╗ kinh nghiß╗çm kiß║┐m tiß╗ün tß╗½ Affiliate Marketing". Hy vß╗ìng nhß║¡n ─æ╞░ß╗úc nhiß╗üu chia sß║╗ tß╗½ anh em!	bai-viet-mau-1773378079140-1	99	f	f	f	2026-03-13 05:01:19.141	2026-03-13 05:01:19.141	ea8708a3-22f7-4924-ad73-5310d5693c7d	49f7d4de-5e27-4297-be62-f7b7ebf18c3c
9c55616e-afb6-440c-a864-4def81fe6041	T├¼m ─æß╗ông ─æß╗Öi l├ám dß╗▒ ├ín khß╗ƒi nghiß╗çp c├┤ng nghß╗ç	Ch├áo mß╗ìi ng╞░ß╗¥i, m├¼nh l├á Member_3_71. ─É├óy l├á nß╗Öi dung b├ái viß║┐t thß╗⌐ 3 vß╗ü chß╗º ─æß╗ü "T├¼m ─æß╗ông ─æß╗Öi l├ám dß╗▒ ├ín khß╗ƒi nghiß╗çp c├┤ng nghß╗ç". Hy vß╗ìng nhß║¡n ─æ╞░ß╗úc nhiß╗üu chia sß║╗ tß╗½ anh em!	bai-viet-mau-1773378079152-2	33	f	f	f	2026-03-13 05:01:19.153	2026-03-13 05:01:19.153	ea8708a3-22f7-4924-ad73-5310d5693c7d	80f84e07-aeb2-40ef-94a6-dd132048acc7
21dda81a-868f-414d-849f-0cc6c7fe743d	xzzxczxcz	<p>zxvzx</p><p></p>	xzzxczxcz-ghjee	6	f	f	f	2026-03-13 08:01:16.471	2026-03-13 08:40:05.214	ea8708a3-22f7-4924-ad73-5310d5693c7d	76641def-ec09-4870-8f0d-39ae10c1b258
cca89eae-e11c-46d9-af38-326d875b7ddd	L├ám thß║┐ n├áo ─æß╗â bß║»t ─æß║ºu vß╗¢i Freelance n─âm 2024?	Ch├áo mß╗ìi ng╞░ß╗¥i, m├¼nh l├á Member_1_929. ─É├óy l├á nß╗Öi dung b├ái viß║┐t thß╗⌐ 1 vß╗ü chß╗º ─æß╗ü "L├ám thß║┐ n├áo ─æß╗â bß║»t ─æß║ºu vß╗¢i Freelance n─âm 2024?". Hy vß╗ìng nhß║¡n ─æ╞░ß╗úc nhiß╗üu chia sß║╗ tß╗½ anh em!	bai-viet-mau-1773378079128-0	45	f	f	f	2026-03-13 05:01:19.13	2026-03-13 09:46:15.231	ea8708a3-22f7-4924-ad73-5310d5693c7d	cfcac9f3-76cf-464f-bc1a-775296128ef5
\.


--
-- Data for Name: Transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transaction" (id, amount, type, status, description, "createdAt", "walletId") FROM stdin;
0e25c04b-0bd3-4dfd-b01b-f469e514d622	5.00	REWARD	COMPLETED	Thanh to├ín nhiß╗çm vß╗Ñ: Kß╗â vß╗ü lß║ºn ─æß║ºu ti├¬n bß║ín kiß║┐m ─æ╞░ß╗úc tiß╗ün tr├¬n mß║íng	2026-03-13 06:18:00.266	26073c28-29fd-449e-b6be-4e7f391320db
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, email, "emailVerified", "verificationToken", username, "avatarUrl", signature, role, reputation, "createdAt", "updatedAt", password, "phoneNumber", "bankName", "bankAccountNumber", "bankAccountName", status) FROM stdin;
d24b8a9e-3caf-4370-a716-e9f63009f604	hoang_tuan@example.com	f	\N	HoangTuan_Dev	https://api.dicebear.com/7.x/avataaars/svg?seed=Hoang	Code is life | Fullstack Developer	USER	150	2026-03-13 02:56:40.496	2026-03-13 02:56:40.496	$2b$10$aeBVZpRFROQK3LKdnuRFAezBDviZxo6r3cc9kITFiLAxkhzqfvRDS	\N	\N	\N	\N	ACTIVE
afcfc997-af60-4bbc-bdcf-807f56866992	linh_marketing@example.com	f	\N	LinhMKT	https://api.dicebear.com/7.x/avataaars/svg?seed=Linh	Sß║╗ chia c╞í hß╗Öi - C├╣ng nhau kiß║┐m tiß╗ün ≡ƒÆ╕	USER	85	2026-03-13 02:56:40.509	2026-03-13 02:56:40.509	$2b$10$aeBVZpRFROQK3LKdnuRFAezBDviZxo6r3cc9kITFiLAxkhzqfvRDS	\N	\N	\N	\N	ACTIVE
78bf245a-e21a-4f98-98cd-26aec81b01a6	admin.pp.forum@gmail.com	f	\N	AdminPP	https://api.dicebear.com/7.x/avataaars/svg?seed=AdminPP	Picpee Senior Admin	ADMIN	999	2026-03-13 04:58:19.18	2026-03-13 04:58:19.18	$2b$10$siCRSXl69K07pLoEVeQYSe2cXl8VyQnTeUlS3sOc2Dr/RQY6Talym	\N	\N	\N	\N	ACTIVE
cfcac9f3-76cf-464f-bc1a-775296128ef5	user17733780791101@example.com	f	\N	Member_1_929	https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_1_929	\N	USER	10	2026-03-13 05:01:19.111	2026-03-13 05:01:19.111	$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma	\N	\N	\N	\N	ACTIVE
49f7d4de-5e27-4297-be62-f7b7ebf18c3c	user17733780791162@example.com	f	\N	Member_2_717	https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_2_717	\N	USER	10	2026-03-13 05:01:19.117	2026-03-13 05:01:19.117	$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma	\N	\N	\N	\N	ACTIVE
80f84e07-aeb2-40ef-94a6-dd132048acc7	user17733780791193@example.com	f	\N	Member_3_71	https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_3_71	\N	USER	10	2026-03-13 05:01:19.121	2026-03-13 05:01:19.121	$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma	\N	\N	\N	\N	ACTIVE
23266cbf-f0a3-4826-954b-79d6fe886a12	user17733780791224@example.com	f	\N	Member_4_655	https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_4_655	\N	USER	10	2026-03-13 05:01:19.123	2026-03-13 05:01:19.123	$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma	\N	\N	\N	\N	ACTIVE
d35b0a3b-12f1-43e3-8639-5a47c23ff369	user17733780791255@example.com	f	\N	Member_5_55	https://api.dicebear.com/7.x/pixel-art/svg?seed=Member_5_55	\N	USER	10	2026-03-13 05:01:19.126	2026-03-13 05:01:19.126	$2b$10$j/I2r2XX4JImpnDnb/m6J.DnGPn84Objnx.InbiNhb9q40enNWNma	\N	\N	\N	\N	ACTIVE
76641def-ec09-4870-8f0d-39ae10c1b258	minhnzz1202@gmail.com	f	\N	MinhNzz	https://api.dicebear.com/7.x/avataaars/svg?seed=Minh	Picpee Lead Developer	USER	1014	2026-03-13 02:58:17.027	2026-03-13 08:01:16.48	$2b$10$XOcUDD4Pwb7tLkTGi5JPC.c9bjYBwHhtx34JSfTlMC1VY4rpmcKr6	\N	\N	\N	\N	ACTIVE
\.


--
-- Data for Name: UserBadge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserBadge" ("userId", "badgeId", "grantedAt") FROM stdin;
\.


--
-- Data for Name: Wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Wallet" (id, balance, "pendingBalance", "updatedAt", "userId") FROM stdin;
8d6b3813-c192-402f-ad1f-a9672df8d13b	1500000.00	200000.00	2026-03-13 02:56:40.564	d24b8a9e-3caf-4370-a716-e9f63009f604
df24a486-cd3b-47ae-b370-67d8d31b1643	50000.00	15000.00	2026-03-13 02:56:40.575	afcfc997-af60-4bbc-bdcf-807f56866992
308a196f-3efc-46ff-b8be-39c236547a69	0.00	0.00	2026-03-13 05:00:14.714	78bf245a-e21a-4f98-98cd-26aec81b01a6
26073c28-29fd-449e-b6be-4e7f391320db	5.00	0.00	2026-03-13 06:18:00.26	76641def-ec09-4870-8f0d-39ae10c1b258
\.


--
-- Data for Name: _ThreadTags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_ThreadTags" ("A", "B") FROM stdin;
7559eab2-64ad-4459-9b2a-7a390877318d	f86a0872-4aa8-43e5-9c35-8224d8bb5c2a
e7cabf8c-8a81-464c-ba4f-40ab17325431	f86a0872-4aa8-43e5-9c35-8224d8bb5c2a
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
89281576-c28d-47e8-a7ba-17976c65a779	55c0576d6a222d85d69300a93936ec92a20fed392d846782d03999d7572e23ed	2026-03-13 02:56:37.697284+00	20260313025637_add_notification_metadata	\N	\N	2026-03-13 02:56:37.478032+00	1
eef7e395-eca9-49e9-8ee6-ab85a6aa348b	65cba14d86396a42a090de283f88a54d89a3fe09742332acee3c006d7ea0c6a5	2026-03-13 03:42:08.916352+00	20260313034208_add_category_board_status	\N	\N	2026-03-13 03:42:08.901175+00	1
e3676712-4cbc-4d29-a573-982200d344e3	24450c961a5683ef14adf84dd4fcefa6534e410f77361206c94bfdf67c492853	2026-03-13 06:34:26.330107+00	20260313063426_add_user_status	\N	\N	2026-03-13 06:34:26.32141+00	1
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (sid, sess, expire) FROM stdin;
mxzsX_gtwK6MGqp_Ze1QndMV6SLpeeGK	{"cookie":{"originalMaxAge":2592000000,"expires":"2026-04-12T08:46:48.708Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"userId":"76641def-ec09-4870-8f0d-39ae10c1b258","role":"USER"}	2026-04-12 09:52:50
\.


--
-- Name: Analytics Analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Analytics"
    ADD CONSTRAINT "Analytics_pkey" PRIMARY KEY (id);


--
-- Name: Badge Badge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Badge"
    ADD CONSTRAINT "Badge_pkey" PRIMARY KEY (id);


--
-- Name: Board Board_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Board"
    ADD CONSTRAINT "Board_pkey" PRIMARY KEY (id);


--
-- Name: Bookmark Bookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookmark"
    ADD CONSTRAINT "Bookmark_pkey" PRIMARY KEY (id);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Follow Follow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Follow"
    ADD CONSTRAINT "Follow_pkey" PRIMARY KEY (id);


--
-- Name: Like Like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_pkey" PRIMARY KEY (id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: Report Report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_pkey" PRIMARY KEY (id);


--
-- Name: ShareTask ShareTask_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ShareTask"
    ADD CONSTRAINT "ShareTask_pkey" PRIMARY KEY (id);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: Thread Thread_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Thread"
    ADD CONSTRAINT "Thread_pkey" PRIMARY KEY (id);


--
-- Name: Transaction Transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_pkey" PRIMARY KEY (id);


--
-- Name: UserBadge UserBadge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserBadge"
    ADD CONSTRAINT "UserBadge_pkey" PRIMARY KEY ("userId", "badgeId");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Wallet Wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wallet"
    ADD CONSTRAINT "Wallet_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: Badge_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Badge_name_key" ON public."Badge" USING btree (name);


--
-- Name: Board_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Board_slug_key" ON public."Board" USING btree (slug);


--
-- Name: Bookmark_userId_threadId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Bookmark_userId_threadId_key" ON public."Bookmark" USING btree ("userId", "threadId");


--
-- Name: Category_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Category_slug_key" ON public."Category" USING btree (slug);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: Like_userId_postId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Like_userId_postId_key" ON public."Like" USING btree ("userId", "postId");


--
-- Name: Like_userId_threadId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Like_userId_threadId_key" ON public."Like" USING btree ("userId", "threadId");


--
-- Name: Tag_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Tag_name_key" ON public."Tag" USING btree (name);


--
-- Name: Tag_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Tag_slug_key" ON public."Tag" USING btree (slug);


--
-- Name: Thread_slug_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Thread_slug_key" ON public."Thread" USING btree (slug);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Wallet_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Wallet_userId_key" ON public."Wallet" USING btree ("userId");


--
-- Name: _ThreadTags_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_ThreadTags_AB_unique" ON public."_ThreadTags" USING btree ("A", "B");


--
-- Name: _ThreadTags_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_ThreadTags_B_index" ON public."_ThreadTags" USING btree ("B");


--
-- Name: Analytics Analytics_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Analytics"
    ADD CONSTRAINT "Analytics_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Board Board_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Board"
    ADD CONSTRAINT "Board_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Bookmark Bookmark_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookmark"
    ADD CONSTRAINT "Bookmark_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Bookmark Bookmark_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookmark"
    ADD CONSTRAINT "Bookmark_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Follow Follow_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Follow"
    ADD CONSTRAINT "Follow_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Like Like_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Like Like_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Like Like_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Notification Notification_receiverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Notification Notification_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Post Post_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Post Post_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Report Report_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Report Report_reporterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Report Report_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ShareTask ShareTask_threadId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ShareTask"
    ADD CONSTRAINT "ShareTask_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ShareTask ShareTask_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ShareTask"
    ADD CONSTRAINT "ShareTask_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Thread Thread_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Thread"
    ADD CONSTRAINT "Thread_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Thread Thread_boardId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Thread"
    ADD CONSTRAINT "Thread_boardId_fkey" FOREIGN KEY ("boardId") REFERENCES public."Board"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Transaction Transaction_walletId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES public."Wallet"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: UserBadge UserBadge_badgeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserBadge"
    ADD CONSTRAINT "UserBadge_badgeId_fkey" FOREIGN KEY ("badgeId") REFERENCES public."Badge"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: UserBadge UserBadge_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserBadge"
    ADD CONSTRAINT "UserBadge_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Wallet Wallet_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wallet"
    ADD CONSTRAINT "Wallet_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: _ThreadTags _ThreadTags_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ThreadTags"
    ADD CONSTRAINT "_ThreadTags_A_fkey" FOREIGN KEY ("A") REFERENCES public."Tag"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ThreadTags _ThreadTags_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ThreadTags"
    ADD CONSTRAINT "_ThreadTags_B_fkey" FOREIGN KEY ("B") REFERENCES public."Thread"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict 44swsDPU5S5oHZsHyJ4aVyahotcw8Gcbh8pLK8hes630YyIqH1NAIfqtokkLIRo

