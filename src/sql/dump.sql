--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.3

-- Started on 2025-05-07 23:46:16 PKT

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
-- TOC entry 2 (class 3079 OID 16406)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 883 (class 1247 OID 17092)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'teacher',
    'student',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 24597)
-- Name: notify_on_contract_creation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_contract_creation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO notifications (user_id, content, type, is_read, image)
    VALUES 
        -- Notification for the student
        (
            NEW.student_id,
            'A new contract has been created.', 
            'contract_update', 
            FALSE,
            (SELECT COALESCE(profile_picture, 'default_image_url') 
             FROM users 
             WHERE user_id = (SELECT user_id FROM teachers WHERE teacher_id = NEW.teacher_id))
        ),
        -- Notification for the teacher
        (
            NEW.teacher_id,
            'You have been hired for a new contract.', 
            'contract_update', 
            FALSE,
            (SELECT COALESCE(profile_picture, 'default_image_url') 
             FROM users 
             WHERE user_id = (SELECT user_id FROM students WHERE student_id = NEW.student_id))
        );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_contract_creation() OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 24598)
-- Name: notify_on_contract_status_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_on_contract_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO notifications (user_id, content, type, is_read, image)
    VALUES 
        -- Notification for the student
        (
            OLD.student_id, 
            CONCAT('Your contract status has been updated to: ', NEW.status), 
            'contract_update', 
            FALSE,
            (SELECT COALESCE(profile_picture, 'default_image_url') 
             FROM users 
             WHERE user_id = (SELECT user_id FROM teachers WHERE teacher_id = OLD.teacher_id))
        ),
        -- Notification for the teacher
        (
            OLD.teacher_id, 
            CONCAT('Your contract status has been updated to: ', NEW.status), 
            'contract_update', 
            FALSE,
            (SELECT COALESCE(profile_picture, 'default_image_url') 
             FROM users 
             WHERE user_id = (SELECT user_id FROM students WHERE student_id = OLD.student_id))
        );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_on_contract_status_change() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 17502)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    city_name character varying(255) NOT NULL,
    region character varying(255) NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17501)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cities_city_id_seq OWNER TO postgres;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 216
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;


--
-- TOC entry 244 (class 1259 OID 24580)
-- Name: contract_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_subjects (
    contract_subject_id integer NOT NULL,
    contract_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.contract_subjects OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 24579)
-- Name: contract_subjects_contract_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_subjects_contract_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_subjects_contract_subject_id_seq OWNER TO postgres;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 243
-- Name: contract_subjects_contract_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_subjects_contract_subject_id_seq OWNED BY public.contract_subjects.contract_subject_id;


--
-- TOC entry 219 (class 1259 OID 17511)
-- Name: grade_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grade_levels (
    grade_level_id integer NOT NULL,
    domain character varying(50) NOT NULL,
    sub_level character varying(50)
);


ALTER TABLE public.grade_levels OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17510)
-- Name: grade_levels_grade_level_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grade_levels_grade_level_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grade_levels_grade_level_id_seq OWNER TO postgres;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 218
-- Name: grade_levels_grade_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grade_levels_grade_level_id_seq OWNED BY public.grade_levels.grade_level_id;


--
-- TOC entry 236 (class 1259 OID 17656)
-- Name: hiring_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hiring_contracts (
    contract_id integer NOT NULL,
    student_id integer NOT NULL,
    teacher_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    mode character varying(20) NOT NULL,
    payment_terms character varying(255),
    status character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT hiring_contracts_mode_check CHECK (((mode)::text = ANY ((ARRAY['online'::character varying, 'physical'::character varying])::text[]))),
    CONSTRAINT hiring_contracts_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'active'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'accepted'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.hiring_contracts OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17655)
-- Name: hiring_contracts_contract_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hiring_contracts_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hiring_contracts_contract_id_seq OWNER TO postgres;

--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 235
-- Name: hiring_contracts_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hiring_contracts_contract_id_seq OWNED BY public.hiring_contracts.contract_id;


--
-- TOC entry 221 (class 1259 OID 17523)
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    language_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17522)
-- Name: languages_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.languages_language_id_seq OWNER TO postgres;

--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 220
-- Name: languages_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_language_id_seq OWNED BY public.languages.language_id;


--
-- TOC entry 246 (class 1259 OID 24602)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer NOT NULL,
    content text NOT NULL,
    type character varying(50),
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    image text,
    CONSTRAINT notifications_type_check CHECK (((type)::text = ANY ((ARRAY['contract_update'::character varying, 'review'::character varying, 'general'::character varying])::text[])))
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 24601)
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 245
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- TOC entry 240 (class 1259 OID 17725)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    contract_id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_status character varying(20),
    payment_method character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT payments_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['pending'::character varying, 'completed'::character varying, 'failed'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17724)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 239
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 238 (class 1259 OID 17682)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    contract_id integer NOT NULL,
    student_id integer NOT NULL,
    teacher_id integer NOT NULL,
    rating integer,
    review_text text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17681)
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_review_id_seq OWNER TO postgres;

--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 237
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- TOC entry 234 (class 1259 OID 17639)
-- Name: student_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_subjects (
    student_subject_id integer NOT NULL,
    student_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.student_subjects OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17638)
-- Name: student_subjects_student_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_subjects_student_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_subjects_student_subject_id_seq OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 233
-- Name: student_subjects_student_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_subjects_student_subject_id_seq OWNED BY public.student_subjects.student_subject_id;


--
-- TOC entry 229 (class 1259 OID 17588)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    user_id integer NOT NULL,
    grade_level_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    guardian_phone character varying(20),
    guardian_address character varying(255),
    guardian_name character varying(255)
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17587)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 228
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 225 (class 1259 OID 17549)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    subject_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17548)
-- Name: subjects_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subjects_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subjects_subject_id_seq OWNER TO postgres;

--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 224
-- Name: subjects_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subjects_subject_id_seq OWNED BY public.subjects.subject_id;


--
-- TOC entry 232 (class 1259 OID 17626)
-- Name: teacher_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_availability (
    availability_id integer NOT NULL,
    teacher_id integer NOT NULL,
    day character varying(10) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT teacher_availability_day_check CHECK (((day)::text = ANY ((ARRAY['Monday'::character varying, 'Tuesday'::character varying, 'Wednesday'::character varying, 'Thursday'::character varying, 'Friday'::character varying, 'Saturday'::character varying, 'Sunday'::character varying])::text[])))
);


ALTER TABLE public.teacher_availability OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17625)
-- Name: teacher_availability_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_availability_availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teacher_availability_availability_id_seq OWNER TO postgres;

--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 231
-- Name: teacher_availability_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_availability_availability_id_seq OWNED BY public.teacher_availability.availability_id;


--
-- TOC entry 242 (class 1259 OID 17759)
-- Name: teacher_grade_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_grade_levels (
    teacher_id integer NOT NULL,
    grade_level_id integer NOT NULL
);


ALTER TABLE public.teacher_grade_levels OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17744)
-- Name: teacher_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_languages (
    teacher_id integer NOT NULL,
    language_id integer NOT NULL
);


ALTER TABLE public.teacher_languages OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17609)
-- Name: teacher_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_subjects (
    teacher_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.teacher_subjects OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17558)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    teacher_id integer NOT NULL,
    user_id integer NOT NULL,
    teaching_mode character varying(20) NOT NULL,
    bio text,
    is_verified boolean DEFAULT false,
    experience_years integer,
    education character varying(255),
    rating numeric(3,2),
    hourly_rate numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    duration_per_session integer,
    CONSTRAINT teachers_teaching_mode_check CHECK (((teaching_mode)::text = ANY ((ARRAY['online'::character varying, 'physical'::character varying, 'both'::character varying])::text[])))
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17557)
-- Name: teachers_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 226
-- Name: teachers_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.teacher_id;


--
-- TOC entry 223 (class 1259 OID 17530)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    phone_number character varying(20),
    gender character varying(10),
    role character varying(20) NOT NULL,
    profile_picture character varying(255),
    city_id integer,
    area character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dob date,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['teacher'::character varying, 'student'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17529)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3296 (class 2604 OID 17505)
-- Name: cities city_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);


--
-- TOC entry 3319 (class 2604 OID 24583)
-- Name: contract_subjects contract_subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_subjects ALTER COLUMN contract_subject_id SET DEFAULT nextval('public.contract_subjects_contract_subject_id_seq'::regclass);


--
-- TOC entry 3297 (class 2604 OID 17514)
-- Name: grade_levels grade_level_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_levels ALTER COLUMN grade_level_id SET DEFAULT nextval('public.grade_levels_grade_level_id_seq'::regclass);


--
-- TOC entry 3312 (class 2604 OID 17659)
-- Name: hiring_contracts contract_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hiring_contracts ALTER COLUMN contract_id SET DEFAULT nextval('public.hiring_contracts_contract_id_seq'::regclass);


--
-- TOC entry 3298 (class 2604 OID 17526)
-- Name: languages language_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN language_id SET DEFAULT nextval('public.languages_language_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 24605)
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- TOC entry 3317 (class 2604 OID 17728)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 17685)
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 17642)
-- Name: student_subjects student_subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subjects ALTER COLUMN student_subject_id SET DEFAULT nextval('public.student_subjects_student_subject_id_seq'::regclass);


--
-- TOC entry 3307 (class 2604 OID 17591)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 17552)
-- Name: subjects subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN subject_id SET DEFAULT nextval('public.subjects_subject_id_seq'::regclass);


--
-- TOC entry 3310 (class 2604 OID 17629)
-- Name: teacher_availability availability_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_availability ALTER COLUMN availability_id SET DEFAULT nextval('public.teacher_availability_availability_id_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 17561)
-- Name: teachers teacher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN teacher_id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 17533)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3539 (class 0 OID 17502)
-- Dependencies: 217
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (city_id, city_name, region) FROM stdin;
1	Karachi	Sindh
2	Lahore	Punjab
3	Islamabad	Capital Territory
4	Peshawar	Khyber Pakhtunkhwa
5	Quetta	Balochistan
\.


--
-- TOC entry 3566 (class 0 OID 24580)
-- Dependencies: 244
-- Data for Name: contract_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_subjects (contract_subject_id, contract_id, subject_id) FROM stdin;
69	65	5
70	66	6
73	68	5
80	72	2
81	73	2
82	74	5
83	75	5
31	37	1
32	38	2
36	42	5
46	47	6
47	48	4
52	51	6
55	53	3
56	54	3
57	55	3
58	56	3
61	58	4
62	59	6
63	60	6
64	61	6
65	62	10
66	63	6
\.


--
-- TOC entry 3541 (class 0 OID 17511)
-- Dependencies: 219
-- Data for Name: grade_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grade_levels (grade_level_id, domain, sub_level) FROM stdin;
1	O-level	O1
2	O-level	O2
3	O-level	O3
4	A-level	AS
5	A-level	A2
6	Intermediate	Part 1
7	Intermediate	Part 2
8	Matric	9th Grade
9	Matric	10th Grade
10	Entry Test	MCAT
11	Entry Test	ECAT
12	Entry Test	BCAT
13	Entry Test	SAT
14	Entry Test	IELTS
\.


--
-- TOC entry 3558 (class 0 OID 17656)
-- Dependencies: 236
-- Data for Name: hiring_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hiring_contracts (contract_id, student_id, teacher_id, start_date, end_date, mode, payment_terms, status, created_at, updated_at) FROM stdin;
42	24	4	2024-12-08	2024-12-30	online	\N	accepted	2024-12-09 05:45:49.634949	2024-12-09 05:48:54.258988
53	27	31	2024-12-08	2024-12-27	online	\N	pending	2024-12-09 06:11:50.505576	2024-12-09 06:11:50.505576
55	27	31	2024-12-08	2024-12-27	online	\N	pending	2024-12-09 06:11:56.989434	2024-12-09 06:11:56.989434
56	27	31	2024-12-08	2024-12-27	online	\N	pending	2024-12-09 06:11:57.848155	2024-12-09 06:11:57.848155
58	18	48	2024-07-18	2025-01-03	physical	\N	pending	2024-12-09 06:24:16.905688	2024-12-09 06:24:16.905688
47	24	48	2024-08-08	2024-12-27	physical	\N	rejected	2024-12-09 15:59:36	2024-12-09 06:25:15.960084
60	18	48	2024-12-03	2025-01-01	physical	\N	pending	2024-12-09 07:16:06.993997	2024-12-09 07:16:06.993997
59	24	48	2024-12-06	2024-12-16	physical	\N	accepted	2024-12-09 06:57:25.045782	2024-12-09 07:17:58.269198
48	18	32	2024-12-03	2024-12-18	online	\N	completed	2024-12-09 15:59:43	2024-12-09 15:59:43
51	18	48	2024-12-12	2025-01-09	physical	\N	completed	2024-12-09 16:03:08	2024-12-09 16:03:29
54	27	31	2024-12-08	2024-12-27	online	\N	completed	2024-12-09 11:11:54	2024-12-09 11:11:54
61	24	48	2024-12-09	2024-12-27	physical	\N	completed	2024-12-09 12:17:22	2024-12-09 12:17:22
62	24	6	2024-12-01	2025-01-08	online	\N	pending	2024-12-29 08:40:55.843034	2024-12-29 08:40:55.843034
63	24	4	2024-12-29	2024-12-30	online	\N	pending	2024-12-29 19:39:49.291314	2024-12-29 19:39:49.291314
65	24	4	2024-12-06	2025-02-28	physical	\N	pending	2024-12-30 17:29:21.391296	2024-12-30 17:29:21.391296
66	24	4	2025-01-03	2025-01-04	online	\N	pending	2025-01-02 10:55:09.272237	2025-01-02 10:55:09.272237
37	6	46	2024-12-21	2024-12-24	physical	\N	accepted	2024-12-07 18:23:18.480873	2024-12-07 18:23:56.213396
68	24	4	2025-01-08	2025-09-02	online	\N	pending	2025-01-09 08:00:39.066847	2025-01-09 08:00:39.066847
38	7	45	2024-12-07	2025-04-07	online	\N	accepted	2024-12-07 23:23:07.12805	2024-12-07 23:24:04.764168
72	24	27	2025-01-15	2025-01-21	online	\N	pending	2025-01-21 15:27:28.839323	2025-01-21 15:27:28.839323
73	24	27	2025-01-09	2025-01-30	online	\N	pending	2025-01-30 09:24:07.027624	2025-01-30 09:24:07.027624
74	24	33	2025-03-05	2025-03-09	online	\N	pending	2025-03-06 16:14:02.869513	2025-03-06 16:14:02.869513
75	24	50	2025-03-05	2025-03-18	online	\N	pending	2025-03-06 16:14:24.921006	2025-03-06 16:14:24.921006
\.


--
-- TOC entry 3543 (class 0 OID 17523)
-- Dependencies: 221
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.languages (language_id, name) FROM stdin;
1	English
2	Spanish
3	Mandarin
4	Hindi
5	Arabic
6	French
7	Russian
8	Portuguese
9	Bengali
10	German
11	Japanese
12	Korean
13	Italian
14	Turkish
15	Urdu
16	Vietnamese
\.


--
-- TOC entry 3568 (class 0 OID 24602)
-- Dependencies: 246
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, user_id, content, type, is_read, created_at, image) FROM stdin;
65	7	A new contract has been created.	contract_update	f	2024-12-07 23:23:07.12805	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733593525/qjfjoyofhkcoquprprof.jpg
2	31	You have been hired for a new contract.	contract_update	f	2024-12-05 15:30:19.825702	blob:http://localhost:3035/35c6f448-47f8-421f-8c2c-2ebd94e330e4
66	45	You have been hired for a new contract.	contract_update	f	2024-12-07 23:23:07.12805	blob:https://tutorlypk.vercel.app/bdee267b-d934-4876-a337-6fdd5752dd78
6	31	Your contract status has been updated to: rejected	contract_update	f	2024-12-05 16:58:47.169185	blob:http://localhost:3035/35c6f448-47f8-421f-8c2c-2ebd94e330e4
8	32	You have been hired for a new contract.	contract_update	f	2024-12-05 17:05:30.233555	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg
10	32	Your contract status has been updated to: cancelled	contract_update	f	2024-12-05 17:05:48.481252	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg
173	24	A new contract has been created.	contract_update	f	2025-03-06 16:14:02.869513	blob:https://tutorlypk.vercel.app/79ef4f0f-06b7-40a6-bf39-f425fbfdb2de
22	33	You have been hired for a new contract.	contract_update	f	2024-12-05 21:24:48.175254	blob:https://tutorlypk.vercel.app/79ef4f0f-06b7-40a6-bf39-f425fbfdb2de
174	33	You have been hired for a new contract.	contract_update	f	2025-03-06 16:14:02.869513	blob:https://tutorlypk.vercel.app/ca773a68-b8a6-4aa0-9e8e-94dca77fcb07
26	28	You have been hired for a new contract.	contract_update	f	2024-12-06 00:12:35.961081	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732025564/evw18cqdu4ulrokprzjg.jpg
71	5	A new contract has been created.	contract_update	t	2024-12-08 13:21:56.127845	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
34	26	You have been hired for a new contract.	contract_update	f	2024-12-06 00:55:25.909811	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
41	5	Your contract status has been updated to: accepted	contract_update	t	2024-12-06 10:39:14.153136	blob:https://tutorlypk.vercel.app/79ef4f0f-06b7-40a6-bf39-f425fbfdb2de
36	26	Your contract status has been updated to: rejected	contract_update	f	2024-12-06 01:05:46.34403	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
43	5	A new contract has been created.	contract_update	t	2024-12-07 09:35:02.424031	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
45	5	A new contract has been created.	contract_update	t	2024-12-07 09:35:03.423705	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
47	5	A new contract has been created.	contract_update	t	2024-12-07 09:35:09.556624	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
42	33	Your contract status has been updated to: accepted	contract_update	f	2024-12-06 10:39:14.153136	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
4	4	Your contract status has been updated to: active	contract_update	t	2024-12-05 16:54:13.506906	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
16	4	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:39:53.579562	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
18	4	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:39:57.60279	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
20	4	Your contract status has been updated to: active	contract_update	t	2024-12-05 18:40:03.525635	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
24	4	Your contract status has been updated to: accepted	contract_update	t	2024-12-05 23:50:12.022325	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
30	4	Your contract status has been updated to: pending	contract_update	t	2024-12-06 00:16:41.521911	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
32	4	Your contract status has been updated to: accepted	contract_update	t	2024-12-06 00:50:52.853402	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
80	4	You have been hired for a new contract.	contract_update	f	2024-12-09 05:45:49.634949	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
96	48	Your contract status has been updated to: accepted	contract_update	f	2024-12-09 06:00:24.906122	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
101	18	A new contract has been created.	contract_update	f	2024-12-09 06:03:08.60859	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733723418/mvm4wd5rnff4v1zvhsqd.jpg
102	48	You have been hired for a new contract.	contract_update	f	2024-12-09 06:03:08.60859	default_image_url
107	18	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:05:08.40374	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
108	48	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:05:08.40374	default_image_url
72	27	You have been hired for a new contract.	contract_update	t	2024-12-08 13:21:56.127845	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
12	27	You have been hired for a new contract.	contract_update	t	2024-12-05 18:03:33.693557	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
79	24	A new contract has been created.	contract_update	t	2024-12-09 05:45:49.634949	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733680884/f03doyiwnckkestjb1nq.jpg
95	24	Your contract status has been updated to: accepted	contract_update	t	2024-12-09 06:00:24.906122	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733723418/mvm4wd5rnff4v1zvhsqd.jpg
67	7	Your contract status has been updated to: accepted	contract_update	f	2024-12-07 23:24:04.764168	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733593525/qjfjoyofhkcoquprprof.jpg
68	45	Your contract status has been updated to: accepted	contract_update	f	2024-12-07 23:24:04.764168	blob:https://tutorlypk.vercel.app/bdee267b-d934-4876-a337-6fdd5752dd78
56	46	You have been hired for a new contract.	contract_update	t	2024-12-07 18:23:18.480873	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733591248/kauammm40neimi9iuatv.jpg
58	46	Your contract status has been updated to: accepted	contract_update	t	2024-12-07 18:23:56.213396	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733591248/kauammm40neimi9iuatv.jpg
54	28	Your contract status has been updated to: accepted	contract_update	f	2024-12-07 14:05:51.073307	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
55	6	A new contract has been created.	contract_update	f	2024-12-07 18:23:18.480873	blob:https://tutorlypk.vercel.app/17dc8072-3151-4658-9e91-35d6b27928f8
57	6	Your contract status has been updated to: accepted	contract_update	f	2024-12-07 18:23:56.213396	blob:https://tutorlypk.vercel.app/17dc8072-3151-4658-9e91-35d6b27928f8
82	4	Your contract status has been updated to: accepted	contract_update	f	2024-12-09 05:48:54.258988	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
169	24	A new contract has been created.	contract_update	f	2025-01-21 15:27:28.839323	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
170	27	You have been hired for a new contract.	contract_update	f	2025-01-21 15:27:28.839323	blob:https://tutorlypk.vercel.app/ca773a68-b8a6-4aa0-9e8e-94dca77fcb07
175	24	A new contract has been created.	contract_update	f	2025-03-06 16:14:24.921006	https://res.cloudinary.com/dl6g2mzft/image/upload/v1737803786/jxqdytuy7jra4fq2kvro.png
176	50	You have been hired for a new contract.	contract_update	f	2025-03-06 16:14:24.921006	blob:https://tutorlypk.vercel.app/ca773a68-b8a6-4aa0-9e8e-94dca77fcb07
103	18	Your contract status has been updated to: accepted	contract_update	f	2024-12-09 06:03:29.277622	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733723418/mvm4wd5rnff4v1zvhsqd.jpg
104	48	Your contract status has been updated to: accepted	contract_update	f	2024-12-09 06:03:29.277622	default_image_url
73	5	A new contract has been created.	contract_update	t	2024-12-08 16:34:01.122688	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
1	5	A new contract has been created.	contract_update	t	2024-12-05 15:30:19.825702	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
3	5	Your contract status has been updated to: active	contract_update	t	2024-12-05 16:54:13.506906	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
5	5	Your contract status has been updated to: rejected	contract_update	t	2024-12-05 16:58:47.169185	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
7	5	A new contract has been created.	contract_update	t	2024-12-05 17:05:30.233555	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
9	5	Your contract status has been updated to: cancelled	contract_update	t	2024-12-05 17:05:48.481252	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
11	5	A new contract has been created.	contract_update	t	2024-12-05 18:03:33.693557	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
13	5	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:04:07.453798	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
109	18	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:05:10.34225	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
44	4	You have been hired for a new contract.	contract_update	t	2024-12-07 09:35:02.424031	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
46	4	You have been hired for a new contract.	contract_update	t	2024-12-07 09:35:03.423705	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
48	4	You have been hired for a new contract.	contract_update	t	2024-12-07 09:35:09.556624	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
52	4	Your contract status has been updated to: active	contract_update	t	2024-12-07 13:23:09.059992	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
60	4	Your contract status has been updated to: cancelled	contract_update	t	2024-12-07 22:08:39.91419	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
110	48	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:05:10.34225	default_image_url
116	31	You have been hired for a new contract.	contract_update	f	2024-12-09 06:11:50.505576	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317
118	31	You have been hired for a new contract.	contract_update	f	2024-12-09 06:11:54.986069	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317
120	31	You have been hired for a new contract.	contract_update	f	2024-12-09 06:11:56.989434	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317
122	31	You have been hired for a new contract.	contract_update	f	2024-12-09 06:11:57.848155	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317
40	27	You have been hired for a new contract.	contract_update	t	2024-12-06 10:22:07.818118	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
74	27	You have been hired for a new contract.	contract_update	t	2024-12-08 16:34:01.122688	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
78	27	You have been hired for a new contract.	contract_update	t	2024-12-08 18:22:51.331288	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
81	24	Your contract status has been updated to: accepted	contract_update	t	2024-12-09 05:48:54.258988	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733680884/f03doyiwnckkestjb1nq.jpg
171	24	A new contract has been created.	contract_update	f	2025-01-30 09:24:07.027624	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
172	27	You have been hired for a new contract.	contract_update	f	2025-01-30 09:24:07.027624	blob:https://tutorlypk.vercel.app/ca773a68-b8a6-4aa0-9e8e-94dca77fcb07
62	4	Your contract status has been updated to: rejected	contract_update	t	2024-12-07 22:58:20.356105	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
64	4	Your contract status has been updated to: accepted	contract_update	t	2024-12-07 22:58:50.066274	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
51	5	Your contract status has been updated to: active	contract_update	t	2024-12-07 13:23:09.059992	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
53	5	Your contract status has been updated to: accepted	contract_update	t	2024-12-07 14:05:51.073307	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732025564/evw18cqdu4ulrokprzjg.jpg
59	5	Your contract status has been updated to: cancelled	contract_update	t	2024-12-07 22:08:39.91419	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
61	5	Your contract status has been updated to: rejected	contract_update	t	2024-12-07 22:58:20.356105	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
63	5	Your contract status has been updated to: accepted	contract_update	t	2024-12-07 22:58:50.066274	https://res.cloudinary.com/dl6g2mzft/image/upload/v1729970538/samples/smile.jpg
70	4	Your contract status has been updated to: rejected	contract_update	f	2024-12-08 04:41:25.811857	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
76	4	Your contract status has been updated to: cancelled	contract_update	f	2024-12-08 16:52:18.157005	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733575536/iszzlltuhkpvogpume2n.jpg
92	48	You have been hired for a new contract.	contract_update	f	2024-12-09 05:59:36.337272	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
93	18	A new contract has been created.	contract_update	f	2024-12-09 05:59:43.032633	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg
94	32	You have been hired for a new contract.	contract_update	f	2024-12-09 05:59:43.032633	default_image_url
105	18	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:04:41.588622	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg
106	32	Your contract status has been updated to: active	contract_update	f	2024-12-09 06:04:41.588622	default_image_url
69	5	Your contract status has been updated to: rejected	contract_update	t	2024-12-08 04:41:25.811857	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733612400/gjdxefxkusxpwjfltqjr.jpg
75	5	Your contract status has been updated to: cancelled	contract_update	t	2024-12-08 16:52:18.157005	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733612400/gjdxefxkusxpwjfltqjr.jpg
77	5	A new contract has been created.	contract_update	t	2024-12-08 18:22:51.331288	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
15	5	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:39:53.579562	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
17	5	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:39:57.60279	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
19	5	Your contract status has been updated to: active	contract_update	t	2024-12-05 18:40:03.525635	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
21	5	A new contract has been created.	contract_update	t	2024-12-05 21:24:48.175254	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
23	5	Your contract status has been updated to: accepted	contract_update	t	2024-12-05 23:50:12.022325	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
25	5	A new contract has been created.	contract_update	t	2024-12-06 00:12:35.961081	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
27	5	A new contract has been created.	contract_update	t	2024-12-06 00:13:36.115636	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
29	5	Your contract status has been updated to: pending	contract_update	t	2024-12-06 00:16:41.521911	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
31	5	Your contract status has been updated to: accepted	contract_update	t	2024-12-06 00:50:52.853402	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733390980/smazxj4bqlpmo5wjdjjc.png
33	5	A new contract has been created.	contract_update	t	2024-12-06 00:55:25.909811	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
35	5	Your contract status has been updated to: rejected	contract_update	t	2024-12-06 01:05:46.34403	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
37	5	A new contract has been created.	contract_update	t	2024-12-06 10:22:04.25164	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
39	5	A new contract has been created.	contract_update	t	2024-12-06 10:22:07.818118	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
112	48	Your contract status has been updated to: completed	contract_update	f	2024-12-09 06:05:26.654597	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
14	27	Your contract status has been updated to: completed	contract_update	t	2024-12-05 18:04:07.453798	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
28	27	You have been hired for a new contract.	contract_update	t	2024-12-06 00:13:36.115636	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg
38	27	You have been hired for a new contract.	contract_update	t	2024-12-06 10:22:04.25164	blob:https://tutorlypk.vercel.app/d1aaf85a-01be-40a3-a9e7-a7c6d57c20f3
115	27	A new contract has been created.	contract_update	t	2024-12-09 06:11:50.505576	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
117	27	A new contract has been created.	contract_update	t	2024-12-09 06:11:54.986069	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
119	27	A new contract has been created.	contract_update	t	2024-12-09 06:11:56.989434	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
121	27	A new contract has been created.	contract_update	t	2024-12-09 06:11:57.848155	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
126	48	Your contract status has been updated to: pending	contract_update	f	2024-12-09 06:20:52.404826	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
128	48	Your contract status has been updated to: pending	contract_update	f	2024-12-09 06:22:00.945686	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
129	18	A new contract has been created.	contract_update	f	2024-12-09 06:24:16.905688	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
130	48	You have been hired for a new contract.	contract_update	f	2024-12-09 06:24:16.905688	default_image_url
132	48	Your contract status has been updated to: rejected	contract_update	f	2024-12-09 06:25:15.960084	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
134	48	You have been hired for a new contract.	contract_update	f	2024-12-09 06:57:25.045782	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
135	18	A new contract has been created.	contract_update	f	2024-12-09 07:16:06.993997	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
136	48	You have been hired for a new contract.	contract_update	f	2024-12-09 07:16:06.993997	default_image_url
138	48	You have been hired for a new contract.	contract_update	f	2024-12-09 07:17:22.722152	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
140	48	Your contract status has been updated to: accepted	contract_update	f	2024-12-09 07:17:58.269198	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733681630/pmmvshtxmyoqrejnhye6.jpg
141	18	Your contract status has been updated to: completed	contract_update	f	2024-12-09 07:22:58.103709	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg
142	32	Your contract status has been updated to: completed	contract_update	f	2024-12-09 07:22:58.103709	default_image_url
143	18	Your contract status has been updated to: completed	contract_update	f	2024-12-09 07:23:38.935527	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
144	48	Your contract status has been updated to: completed	contract_update	f	2024-12-09 07:23:38.935527	default_image_url
145	27	Your contract status has been updated to: completed	contract_update	f	2024-12-27 18:19:45.300999	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg
146	31	Your contract status has been updated to: completed	contract_update	f	2024-12-27 18:19:45.300999	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317
148	48	Your contract status has been updated to: completed	contract_update	f	2024-12-27 18:20:35.958122	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735321789/sqaevpw7qwwqgsnllusn.jpg
150	6	You have been hired for a new contract.	contract_update	f	2024-12-29 08:40:55.843034	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325048/yi2lomgrrjx3gn3irmbg.jpg
91	24	A new contract has been created.	contract_update	t	2024-12-09 05:59:36.337272	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733723418/mvm4wd5rnff4v1zvhsqd.jpg
111	24	Your contract status has been updated to: completed	contract_update	t	2024-12-09 06:05:26.654597	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
125	24	Your contract status has been updated to: pending	contract_update	t	2024-12-09 06:20:52.404826	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
127	24	Your contract status has been updated to: pending	contract_update	t	2024-12-09 06:22:00.945686	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
131	24	Your contract status has been updated to: rejected	contract_update	t	2024-12-09 06:25:15.960084	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
133	24	A new contract has been created.	contract_update	t	2024-12-09 06:57:25.045782	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
137	24	A new contract has been created.	contract_update	t	2024-12-09 07:17:22.722152	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
139	24	Your contract status has been updated to: accepted	contract_update	t	2024-12-09 07:17:58.269198	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
147	24	Your contract status has been updated to: completed	contract_update	t	2024-12-27 18:20:35.958122	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg
152	4	You have been hired for a new contract.	contract_update	f	2024-12-29 19:39:49.291314	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735461893/cnmngmoi17crpiqd0tg5.jpg
156	4	You have been hired for a new contract.	contract_update	f	2024-12-30 17:29:21.391296	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735461893/cnmngmoi17crpiqd0tg5.jpg
158	4	You have been hired for a new contract.	contract_update	f	2025-01-02 10:55:09.272237	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735582424/rzldphn3dce8uj6xfya0.png
162	4	You have been hired for a new contract.	contract_update	f	2025-01-09 08:00:39.066847	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735582424/rzldphn3dce8uj6xfya0.png
149	24	A new contract has been created.	contract_update	t	2024-12-29 08:40:55.843034	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325645/portrait-of-young-indian-businesswoman-or-school-teacher-pose-indoors_ibloiq.jpg
151	24	A new contract has been created.	contract_update	t	2024-12-29 19:39:49.291314	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325616/headshot-portrait-african-30s-man-smile-look-at-camera_vmbdrv.jpg
155	24	A new contract has been created.	contract_update	t	2024-12-30 17:29:21.391296	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325616/headshot-portrait-african-30s-man-smile-look-at-camera_vmbdrv.jpg
157	24	A new contract has been created.	contract_update	t	2025-01-02 10:55:09.272237	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325616/headshot-portrait-african-30s-man-smile-look-at-camera_vmbdrv.jpg
161	24	A new contract has been created.	contract_update	t	2025-01-09 08:00:39.066847	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325616/headshot-portrait-african-30s-man-smile-look-at-camera_vmbdrv.jpg
\.


--
-- TOC entry 3562 (class 0 OID 17725)
-- Dependencies: 240
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, contract_id, student_id, amount, payment_status, payment_method, created_at) FROM stdin;
\.


--
-- TOC entry 3560 (class 0 OID 17682)
-- Dependencies: 238
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (review_id, contract_id, student_id, teacher_id, rating, review_text, created_at) FROM stdin;
31	48	18	32	5	best	2024-12-09 07:26:36.749171
32	51	18	48	5	Had a great time studying with her.	2024-12-09 07:51:59.826516
\.


--
-- TOC entry 3556 (class 0 OID 17639)
-- Dependencies: 234
-- Data for Name: student_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_subjects (student_subject_id, student_id, subject_id) FROM stdin;
7	6	1
8	7	3
13	24	4
14	24	6
15	26	5
16	26	4
17	27	4
18	28	3
\.


--
-- TOC entry 3551 (class 0 OID 17588)
-- Dependencies: 229
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, user_id, grade_level_id, created_at, updated_at, guardian_phone, guardian_address, guardian_name) FROM stdin;
6	59	4	2024-12-07 18:22:55.603339	2024-12-07 18:22:55.603339	3049055492	123-paradise	Abdul Basit
7	62	7	2024-12-07 23:22:14.129497	2024-12-07 23:22:14.129497	1234567890	 usa california st2	ahmed shahzad
18	67	\N	2024-12-09 04:42:18.365092	2024-12-09 04:42:18.365092	\N	\N	\N
24	18	5	2024-12-09 05:35:02.111188	2024-12-09 05:35:02.111188	1234567890	springfield	abdul basit
26	68	4	2024-12-09 06:06:49.402943	2024-12-09 06:06:49.402943	1234567890	punjab	fiza farooq
27	69	10	2024-12-09 06:11:03.799147	2024-12-09 06:11:03.799147	0334123123	.....	.....
28	72	6	2024-12-10 18:49:25.853324	2024-12-10 18:49:25.853324	3352626889	Block 1 Apt 3A Sector J Askari 5 Malir Cantt	Shan Ul Haq
\.


--
-- TOC entry 3547 (class 0 OID 17549)
-- Dependencies: 225
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (subject_id, name, description) FROM stdin;
1	Mathematics	Study of numbers, shapes, and patterns
2	Physics	Study of matter, energy, and their interactions
3	Chemistry	Study of substances and their properties and reactions
4	Biology	Study of living organisms and their functions
5	English	Study of the English language and literature
6	Computer Science	Study of computers and computational systems
7	Economics	Study of production, consumption, and transfer of wealth
8	History	Study of past events and societies
9	Geography	Study of the Earth and its features
10	Political Science	Study of politics, political systems, and government
\.


--
-- TOC entry 3554 (class 0 OID 17626)
-- Dependencies: 232
-- Data for Name: teacher_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_availability (availability_id, teacher_id, day, start_time, end_time) FROM stdin;
76	27	Monday	09:00:00	10:00:00
77	27	Wednesday	11:30:00	12:00:00
78	27	Sunday	15:00:00	16:00:00
79	27	Wednesday	13:00:00	14:00:00
83	32	Monday	09:00:00	17:00:00
84	32	Sunday	09:00:00	17:00:00
85	32	Wednesday	09:00:00	17:00:00
86	33	Monday	09:00:00	17:00:00
87	33	Friday	09:00:00	17:00:00
88	33	Tuesday	09:00:00	17:00:00
89	33	Sunday	09:00:00	17:00:00
90	33	Thursday	09:00:00	17:00:00
91	33	Saturday	09:00:00	17:00:00
92	33	Wednesday	09:00:00	17:00:00
93	34	Friday	09:00:00	17:00:00
94	34	Sunday	09:00:00	17:00:00
95	35	Monday	09:00:00	17:00:00
97	35	Monday	09:00:00	17:00:00
96	35	Tuesday	09:00:00	17:00:00
98	35	Tuesday	09:00:00	17:00:00
99	36	Monday	09:00:00	17:00:00
100	36	Tuesday	09:00:00	17:00:00
101	36	Friday	09:00:00	17:00:00
102	36	Wednesday	09:00:00	17:00:00
103	36	Thursday	09:00:00	17:00:00
104	36	Monday	09:00:00	17:00:00
131	31	Monday	09:00:00	17:00:00
132	31	Friday	09:00:00	17:00:00
133	31	Saturday	09:00:00	17:00:00
134	31	Saturday	09:00:00	17:00:00
135	31	Friday	09:00:00	17:00:00
136	31	Tuesday	09:00:00	17:00:00
137	31	Monday	09:00:00	17:00:00
138	31	Wednesday	09:00:00	17:00:00
139	31	Tuesday	09:00:00	17:00:00
140	31	Monday	09:00:00	17:00:00
141	31	Wednesday	09:00:00	17:00:00
142	31	Thursday	09:00:00	17:00:00
143	31	Thursday	09:00:00	17:00:00
159	4	Monday	11:30:00	12:00:00
160	4	Sunday	18:00:00	19:00:00
161	4	Sunday	15:30:00	16:00:00
162	4	Wednesday	16:00:00	17:00:00
163	4	Wednesday	12:30:00	13:00:00
164	45	Monday	09:00:00	10:00:00
165	45	Sunday	15:30:00	16:30:00
166	45	Wednesday	13:00:00	14:00:00
167	46	Monday	09:00:00	17:00:00
168	46	Tuesday	09:00:00	17:00:00
169	46	Saturday	09:00:00	17:00:00
170	46	Sunday	09:00:00	17:00:00
171	47	Monday	09:00:00	17:00:00
172	47	Friday	09:00:00	13:30:00
173	47	Saturday	09:00:00	19:30:00
174	47	Sunday	12:00:00	19:00:00
175	48	Monday	14:00:00	15:30:00
176	48	Friday	10:30:00	12:00:00
177	48	Wednesday	17:00:00	18:00:00
178	49	Monday	09:00:00	20:00:00
179	49	Wednesday	09:00:00	20:00:00
180	49	Friday	09:00:00	20:00:00
181	49	Tuesday	09:00:00	20:00:00
182	49	Saturday	09:00:00	20:00:00
183	49	Thursday	09:00:00	20:00:00
184	50	Monday	15:00:00	18:00:00
185	50	Thursday	15:00:00	18:00:00
186	50	Wednesday	15:00:00	18:00:00
187	50	Friday	15:00:00	18:00:00
188	50	Tuesday	15:00:00	18:00:00
189	50	Saturday	15:00:00	18:00:00
\.


--
-- TOC entry 3564 (class 0 OID 17759)
-- Dependencies: 242
-- Data for Name: teacher_grade_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_grade_levels (teacher_id, grade_level_id) FROM stdin;
26	2
26	14
27	8
27	6
28	5
28	4
6	12
6	4
31	7
32	4
32	8
32	9
32	5
33	5
33	4
35	2
36	1
36	2
36	5
46	1
46	5
46	2
46	4
46	3
45	2
45	3
47	5
47	4
47	10
48	4
48	5
48	2
4	4
4	3
49	1
49	3
49	2
50	8
50	9
\.


--
-- TOC entry 3563 (class 0 OID 17744)
-- Dependencies: 241
-- Data for Name: teacher_languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_languages (teacher_id, language_id) FROM stdin;
49	1
49	15
50	15
28	1
28	6
28	15
31	15
31	1
31	10
31	13
26	1
26	2
27	1
27	15
6	12
6	10
32	12
32	1
32	6
33	1
33	15
34	11
35	9
35	7
35	8
35	4
36	1
36	15
4	1
4	2
45	5
45	6
45	7
46	5
46	1
46	15
47	1
48	1
48	10
48	13
\.


--
-- TOC entry 3552 (class 0 OID 17609)
-- Dependencies: 230
-- Data for Name: teacher_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_subjects (teacher_id, subject_id) FROM stdin;
26	10
26	8
27	2
27	4
28	3
28	4
6	8
6	10
31	3
31	4
32	3
32	4
32	2
33	5
35	5
36	6
46	1
45	3
45	1
45	2
47	4
48	4
48	6
48	2
4	5
4	6
49	3
49	8
49	1
49	2
49	9
50	5
\.


--
-- TOC entry 3549 (class 0 OID 17558)
-- Dependencies: 227
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (teacher_id, user_id, teaching_mode, bio, is_verified, experience_years, education, rating, hourly_rate, created_at, updated_at, duration_per_session) FROM stdin;
48	66	online	Passionate and experienced educator dedicated to inspiring students and helping them achieve their academic goals. Specializes in creating engaging learning environments tailored to individual needs, with a proven track record of success in Bio,Computer Science and Physics. Committed to fostering curiosity, critical thinking, and a love for learning 	f	8	masters	\N	\N	2024-12-09 09:35:45	2024-12-27 18:01:01.000167	\N
6	10	online	Experienced educator with 12 years of expertise in teaching History and Political Science, fostering critical thinking and a deep understanding of historical events and political systems.	f	12	masters	\N	12.00	2024-10-27 11:28:40	2024-10-27 11:28:40	40
27	16	physical	backend developer	f	20	bscs	\N	20.00	2024-11-19 23:39:16	2024-11-23 14:30:57	30
28	19	online	react  and next expert 	f	20	masters in bachodi	\N	23.00	2024-11-19 19:13:38	2024-11-23 09:33:59.097441	60
31	12	online	Biology and Chemistry Expert	f	5	jknj	\N	32.00	2024-11-22 00:39:56	2024-11-25 03:43:14	60
33	46	online	Currently pursuing Master's in Professional eepycar	f	3	BS-EEPY	\N	50.00	2024-11-25 08:25:09.684498	2024-11-25 08:26:35.184043	90
49	74	online	Hi	f	3	O/A level,completing my computer science degree from fast university 	\N	\N	2025-01-02 10:07:35.674677	2025-01-02 10:12:29.102413	\N
35	49	online	🙏	f	2	Ksksks	\N	200.00	2024-11-25 13:22:30.001049	2024-11-25 13:24:11.108746	60
50	75	online	I have performed my duty as English Teacher in private sector from 2009 to 2015, and now, I have been serving as English Language Teacher since 2015 till to date.	f	14	M.A English & M.Phil Education	\N	10000.00	2025-01-25 11:19:08.488423	2025-01-25 11:22:34.634153	60
36	50	online	None	f	2	Bscs	\N	50.00	2024-11-25 15:46:27.196753	2024-11-25 15:50:07.944519	60
26	17	physical	Hi there!	f	3	mphil	\N	23.00	2024-11-19 23:26:42	2024-11-23 12:32:02	30
34	45	physical	\N	f	30	phd in rizzology	\N	\N	2024-11-25 13:25:47	2024-11-25 13:25:47	\N
32	44	online	\N	f	3	phd in laiba khan	\N	6900.00	2024-11-25 13:13:07	2024-11-25 13:16:28	120
46	58	physical	Math Tutor	f	20	PhD Mathematics	\N	10000.00	2024-12-07 18:21:35.283897	2024-12-07 18:22:17.483331	60
45	61	online	hhpowwadasd	f	12	MSc in Physics	\N	30.00	2024-12-07 18:01:38.858097	2024-12-07 22:56:39.966112	30
47	63	physical	Biology is my passion. Recently moved from Manchester, i got my degree from Birmingham	f	12	PHD Biology	\N	12000.00	2024-12-08 17:59:05.378548	2024-12-08 18:00:05.217399	60
4	4	online	i do part time tutoring here	f	7	MSc in Mathematics	\N	20.00	2024-10-23 22:43:28	2024-12-09 05:50:52.426256	30
\.


--
-- TOC entry 3545 (class 0 OID 17530)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, password_hash, name, phone_number, gender, role, profile_picture, city_id, area, created_at, updated_at, dob) FROM stdin;
11	kainatfaisal50@gamil.com	$2a$10$UOmj.TvOp8LoGw3aTA6z0em.iVEVnjcpXkynsIcJZoNyUc.s47MqK	kaisjnkas sanandaj	093923	Female	student	\N	1	akams	2024-10-25 08:58:50.640702	2024-10-25 08:58:50.640702	2008-10-28
53	walhar@gmail.com	$2a$10$5zi6iHM/J/hGWljS7yLV..VZr.5Odb8Yzn3HHFyYwMCziYuCTLNJ6	wal har	03072779602	Male	student	\N	1	askari	2024-12-04 09:20:44.938446	2024-12-04 09:20:44.938446	2002-08-20
54	exampletest@gmail.com	$2a$10$uBLxRfQAyRQX0yawALvtReibVu7dd/vuVNRgV9IUmnYvR/L/YPkgu	hashir1 khann	34632478623	Male	teacher	\N	1	jgjhg	2024-12-04 10:15:06.36532	2024-12-04 10:15:06.36532	2024-12-03
56	hashirahmedkhan123@gmail.com	$2a$10$SK3fIKHh.hNA/NqhudToV.szMwvMLF2oHxLLHAdcXcxvoQF.fWZ8u	Hashir Ahmed Khan	03473621522	Male	student	\N	2	Gulzar e Hijri	2024-12-07 14:22:36.728463	2024-12-07 14:22:36.728463	2024-12-06
25	alimurtazaathar@gmail.com	$2a$10$UZ0zk28Fm3Yh8djhCElEKed7oLmNM.eoAW5AmnYQoq/ba28RFZCga	ali murtaza	03132670981	Male	student	\N	1	Goth	2024-11-20 13:29:00.072642	2024-11-20 13:29:00.072642	2004-02-01
18	student@example.com	$2a$10$L/htsDtQIwrCwuLLxYHO9O0bTq.bUjx6/LuwLccoW6UnMPRMwzJVG	Epstein  Siddqiue	123456789	Female	student	blob:https://tutorlypk.vercel.app/979fa6d1-c331-4913-9d9f-b7a2b69c180e	4	gulshan town	2024-11-19 18:41:27	2025-03-22 19:25:33.674971	2000-12-06
28	qwerty@gmail.com	$2a$10$Lnym4M99EdY9J4XPA0KPtufhtXmaLuE5aZAz1SgQXPAz6OEEWilQi	testiiing 213	03049088492	Male	student	\N	1	paradise	2024-11-21 07:36:11.297373	2024-11-21 07:36:11.297373	2024-11-20
39	hehe@gmail.com	$2a$10$iKQqc5gwj67ygD8p9hPI/u1dSgEBjjfjxzAXNWzRhR1EmF1W9A0EC	auahah dhajd	43435435	Male	student	\N	3	algo	2024-11-21 14:07:30.317339	2024-11-21 14:07:30.317339	2024-11-20
45	laiba@gmail.com	$2a$10$8a472kzo9FtozTGTeWmvmOB3d6O.X4MkCGn5kp/ZYsnbl6RmyJa12	Laiba Khan	03352036450	Female	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522957/eefezdt7zutnrgaw7pmr.jpg	1	Bhains Colony	2024-11-25 08:21:54.721635	2024-11-25 08:22:54.747377	1990-06-22
41	testtutor@yopmail.com	$2a$10$jGHAok3OGHulSTIQEldX6uRB1ndP3BUKV/WldyZ.2X5Ezp6X0JSxO	Test Tutor	123456	Male	teacher	\N	1	Gulshan	2024-11-23 08:14:12.26788	2024-11-23 08:14:12.26788	1991-08-31
40	final@example.com	$2a$10$br3CBqY0wNvSCsCVTYnAyOVH3H3BL129d7mgcdlstmBfaK1YGc2OW	hdsjad djzdjsa	34632478623	Male	student	\N	5	dsa	2024-11-21 14:21:04.403571	2024-11-21 14:21:04.403571	2024-11-20
19	aawaiz123@gmail.com	$2a$10$K3XCnXrBBHNRYwnkNrDe1OukWzpTrl.5iv48lz0Nm3x3UcJGYXGva	aawaiz ali	73527423	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732025564/evw18cqdu4ulrokprzjg.jpg	3	ned a6	2024-11-19 19:08:46	2024-11-19 19:12:47	2024-11-16
21	Raain1420@gmail.com	$2a$10$lrU5pj9nAPATi08sxjg89e4hlx1TrAztKD9/ggV7vedbvq0sysSdu	Raahim Siddiqui	334399325	Female	student	\N	2	rregion	2024-11-19 18:25:13.1269	2024-11-19 18:25:13.1269	1932-03-22
46	k224585@nu.edu.pk	$2a$10$pIuughnqY0u4uK0ElEyL.OJPYbEHwKhLWl0eYbuhT863BjMJ6pZ0e	Samra Shahid	03433052638	Female	teacher	blob:https://tutorlypk.vercel.app/79ef4f0f-06b7-40a6-bf39-f425fbfdb2de	1	Quaidabad	2024-11-25 08:22:08.397533	2024-11-25 08:23:17.42141	2005-01-10
52	maliksaqib0011@gmail.com	$2a$10$GEGGdbLNuVTr8QVPHZPHIuZzE2YSr62Wp0nVd8VZMmaLSN8rp9RrO	saqib ghafoor	03472811569	Male	teacher	\N	1	shah faisal	2024-11-27 09:40:43.703786	2024-11-27 09:40:43.703786	2005-05-13
42	fizafarooq033@gmail.com	$2a$10$xyNkhTQgto7a.riKV.MTEuc8PQuZzdIhOPL5aBLiu2aYdVxhgjNR6	Fiza Farooq	03014997152	Female	student	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732521412/drcw56ctm6qxwikr0x6q.jpg	1	Airport	2024-11-25 07:55:29.254663	2024-11-25 07:56:55.491744	2003-12-06
12	Raahimhussain1420@gmail.com	$2a$10$e2GhdKK21XbYg998s79k3eo71v2rnreAAVLL2eRx8JaYs.gzHJWTC	Emilia Jones	334399325	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325698/images_pnpzzv.jpg	1	gulzar e hijri	2024-11-15 11:30:28	2024-11-27 21:57:13	2003-05-28
57	muneebkhan2484@gmail.com	$2a$10$cM/.GNMhE579vTh2ydqvseOfJUuArFPjDQXiZEWT7lDO0fF1QP.W2	Muneeb Maqsood Khan	03322144484	Male	teacher	\N	1	F	2024-12-07 16:12:52.997339	2024-12-07 16:12:52.997339	2004-08-23
49	muhammadmubashirak329@gmail.com	$2a$10$a6nXHL0j9YHBRrQTqZm7k.TI/7wiGip8PEeEN8WnyrFluP6pRwMx.	Mubashir Khan	03172580893	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732540901/jelqzaheb9taxajpt9rf.png	1	Zjzj	2024-11-25 13:21:10.666922	2024-11-25 13:21:46.343581	2003-11-26
44	kainatfaisal50@gmail.com	$2a$10$PcUun9uNdCSGp79CIz/3V.Utur6tUZeud6mCiRblK7Ar/mqj0f44y	kainat faisal	03342641976	Female	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732522272/j6qliludd9gcwdjyk5is.jpg	1	nn	2024-11-25 08:03:48.380104	2024-11-25 08:11:28.277366	2003-09-23
50	fatik.khan.200@gmail.com	$2a$10$aB5lWYSk0D/Uyr328P57MuC8zio332z4rlUoe5NFu0Ci3l1JMxb5y	Fatik Khan	03480263143	Male	teacher	\N	1	Gulshq	2024-11-25 15:43:55.641373	2024-11-25 15:43:55.641373	2000-06-11
51	k224297@nu.edu.pk	$2a$10$jQV0tO3ziKyS5jhlQcN3m.VmeSDgvlBQdtUuXqwmmRNe.dPLtt8Zq	Ali Murtuza	03162211320	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732590189/wkvnnowrdvip9chkk4wc.jpg	1	kachi abadi	2024-11-26 03:02:24.486289	2024-11-26 03:03:15.603402	2003-02-26
17	gado@gmail.com	$2a$10$8A9oPlwX8opkXie3nHojpuzBVu25CnBUdg.bsu1VYlCqvv5GunPd2	Ali Murtuza	7467834	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735327420/detiw0gmlly6jmtx5jwb.jpg	4	Korangi, Karachi, Pakistan	2024-11-20 14:10:03	2024-11-20 15:07:08	2024-11-14
58	i222127@nu.edu.pk	$2a$10$mqCqTS/R4C6aXJa2SWAlTOJcheHaf/11aWgTlNyHaQ0rwyPaV3TQa	Abdul Qadir Tareen	03049088492	Male	teacher	blob:https://tutorlypk.vercel.app/17dc8072-3151-4658-9e91-35d6b27928f8	1	Gulshan	2024-12-07 16:55:27.73652	2024-12-08 04:08:58.264323	2003-11-29
10	hash1khn@gmail.com	$2a$10$dGe82gkMvtxEfTwZ3agK.eTVSgDyX.NWVDqsJN9AAJK3EqJj3Nete	aliyah khan	34632478623	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325645/portrait-of-young-indian-businesswoman-or-school-teacher-pose-indoors_ibloiq.jpg	3	dsa	2024-10-25 01:55:56	2024-10-27 16:08:03	2016-01-19
55	fk@gmail.com	$2a$10$DL/AhIv/nv3xs4tErZPiF.Y/HgnjG4A3sM5aKjkVYpNFwFOFbUBuy	fffff kkk	003341234	Male	teacher	\N	1	grrr	2024-12-05 16:05:27.01268	2024-12-05 16:06:11.507255	2024-11-29
16	hashir@gmail.com	$2a$10$DgTczN.xYTUzEl44eOIHE.hCCoEUYSN95F.qv/hzRbksSSoVZSES6	zai	43435435	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1732354116/newqtysbgkgjuuzwipai.jpg	1	korangi	2024-11-19 18:04:22	2024-11-23 14:29:23	2024-11-14
4	user1@example.com	$2a$10$HIAP91GxwONl9Rb7Wdy49eOlaRaJML6VF8X8koXF5RSFjz81Bcy5G	Hamza Siddique	1234567890	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1735325616/headshot-portrait-african-30s-man-smile-look-at-camera_vmbdrv.jpg	2	landhi	2024-10-25 03:57:57	2024-12-08 14:00:02	2024-10-22
71	irtiza.s2918@gmail.com	$2a$10$rzT0fKUecEad..R/jOp9Luqnt14gSk46b1mwCs6SB0m/2GbTr7qAm	Syed Muhammad Irtiza	03181122703	Male	teacher	\N	1	malir	2024-12-10 18:45:42.539169	2024-12-10 18:45:42.539169	2024-05-09
61	pk.tutorly@gmail.com	$2a$10$329rpMfNuYigNMgZXfSLreK3oQleb.l3/67RfaKy1G3r0me98dj/a	teacher testing	03323158782	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733593525/qjfjoyofhkcoquprprof.jpg	1	Gulzar e Hijri	2024-12-07 17:29:49.147209	2024-12-07 17:45:36.796686	2024-12-03
59	aqtareen50@gmail.com	$2a$10$xGF0Se.EMVVLGVcd/o93S.kS3/nUE/vxLvlhHiELBap53Bq2WK.Q.	dfsasdasd Student	03049088492	Male	student	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733591248/kauammm40neimi9iuatv.jpg	1	1234	2024-12-07 17:04:50.099648	2024-12-07 18:22:34.151635	2004-11-28
62	smshuja.16@gmail.com	$2a$10$LF5K/EmWHku31Yhc/jkUv.6SIwiYXkKD1zmm3eGisoIPyGTu7471O	shuja ahmed	03472621522	Male	student	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733617962/fsdbhanqrhalskamre02.jpg	4	paradise bakery	2024-12-07 23:16:49.949145	2024-12-08 00:32:44.575032	2003-12-05
63	JGrealish123@gmail.com	$2a$10$PItD/A7VJcry.9BPGceWrOou84lwvHQvaq0Ylt9VgbIPNUGkUcVfu	Jack Grealish	03019046491	Male	teacher	blob:https://tutorlypk.vercel.app/bc7a266b-fa65-4e0f-994e-701c21083fab	2	OLD TOWN	2024-12-08 17:56:22.648306	2024-12-08 17:58:26.395437	1981-12-10
65	BSanders123@gmail.com	$2a$10$T5Jk1k1HSuWpKj.UOqoxxuaYuMUGE2ACa.i7NUI54q05V3oIG11lO	Bernie Sanders	03014188412	Male	teacher	blob:https://tutorlypk.vercel.app/b72ae130-fa35-4d80-983f-05a530b12b99	3	F=9	2024-12-08 18:00:54.721319	2024-12-08 18:01:24.831144	1961-09-02
72	muhammadahmedhaque@gmail.com	$2a$10$ua3z7s2B774HWaHnUFTVteXq4kC3eQUjl2n7OmUF0VHqh5Ba5ieSG	Muhammad Ahmed  Haque	03352626889	Male	student	\N	1	Askari 5 	2024-12-10 18:47:58.961993	2024-12-10 18:48:34.143144	2005-01-10
73	k224638@nu.edu.pk	$2a$10$GpnirGYiGWpnyz9gLQLSa.wjiuRve73x1kiLsUdHjlSTSo0jd9yR2	M. irtiza	03181122703	Male	student	\N	2	saddar	2024-12-10 18:54:01.839479	2024-12-10 18:56:53.210379	2024-01-08
67	k224546@nu.edu.pk	$2a$10$p6AA71WRmmVOysVgvRs.xOszzFcHYm9TXk4JevONrPB8ocEXR8/jG	fiza farooq	65432	Female	student	\N	1	mbhmb	2024-12-09 04:40:48.788716	2024-12-09 04:44:17.741651	2003-03-08
74	daniyal.hemani.31@gmail.com	$2a$10$r.fACD3/6jlHfqS9jGKPeejhvH3Vi8ur7824rAqj/BLaiKfW9qv/6	Daniyal  Hemani	03327916997	Male	teacher	\N	1	Garden East 	2025-01-02 10:05:05.235804	2025-01-02 10:05:16.986081	2005-01-29
68	k224610@nu.edu.pk	$2a$10$Qmllf2a2FT6OQC8PmQsa6eVVk66MePZ8SxEuZb63aMclJX6sQm3XK	lala khan	03352036450	Male	student	\N	4	lalukhait	2024-12-09 06:05:36.775287	2024-12-09 06:05:55.751503	2024-09-11
75	junaidcss516@gmail.com	$2a$10$71DfHjNHcJDhZar5fFFnUuAOAVhrFNjENJQoTpiYlV67vbEN7jbQm	Juma Khan	03467991052	Male	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1737803786/jxqdytuy7jra4fq2kvro.png	5	Loralai	2025-01-25 11:15:55.837717	2025-01-25 11:16:40.050085	1987-04-04
66	k224405@nu.edu.pk	$2a$10$HGUjXu9QYR2Dkh7WacP8d.d8dwMeODa6goR83ZOgbfQ8tga8E8OZ2	kainat faisal	03342641976	Female	teacher	https://res.cloudinary.com/dl6g2mzft/image/upload/v1733724224/xrku9zrxllh6zgmpxtlc.jpg	3	ijnsfi	2024-12-09 04:34:39.455877	2024-12-09 06:38:45.726414	2003-06-03
70	rubab.jaffar@nu.edu.pk	$2a$10$yOQvPe5wbUAq.1ly31K1c.otAto2G7By8sRXGhpb3oziko0aLPDMK	kainat faisal	1912939	Female	teacher	\N	1	nn	2024-12-09 07:27:30.572401	2024-12-09 07:27:30.572401	2023-10-16
69	malinoorani1402@gmail.com	$2a$10$vbQ2IqVOrlkqt2rSmCeT9OzPcD7Ut7o0im7vKAkv0UPuBSjh2ED6G	Ali Noorani	03009209994	Male	student	blob:https://tutorlypk.vercel.app/60e97910-8f3e-4f59-94a7-47b3ddc20317	1	sindh	2024-12-09 06:08:50.307996	2024-12-10 05:59:21.354701	2003-02-13
\.


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 216
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 5, true);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 243
-- Name: contract_subjects_contract_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_subjects_contract_subject_id_seq', 83, true);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 218
-- Name: grade_levels_grade_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grade_levels_grade_level_id_seq', 14, true);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 235
-- Name: hiring_contracts_contract_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hiring_contracts_contract_id_seq', 75, true);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 220
-- Name: languages_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.languages_language_id_seq', 16, true);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 245
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 176, true);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 239
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 237
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 32, true);


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 233
-- Name: student_subjects_student_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_subjects_student_subject_id_seq', 18, true);


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 228
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 32, true);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 224
-- Name: subjects_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subjects_subject_id_seq', 10, true);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 231
-- Name: teacher_availability_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_availability_availability_id_seq', 189, true);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 226
-- Name: teachers_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 50, true);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 75, true);


--
-- TOC entry 3332 (class 2606 OID 17509)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 3368 (class 2606 OID 24585)
-- Name: contract_subjects contract_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_subjects
    ADD CONSTRAINT contract_subjects_pkey PRIMARY KEY (contract_subject_id);


--
-- TOC entry 3334 (class 2606 OID 17516)
-- Name: grade_levels grade_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_levels
    ADD CONSTRAINT grade_levels_pkey PRIMARY KEY (grade_level_id);


--
-- TOC entry 3358 (class 2606 OID 17665)
-- Name: hiring_contracts hiring_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hiring_contracts
    ADD CONSTRAINT hiring_contracts_pkey PRIMARY KEY (contract_id);


--
-- TOC entry 3336 (class 2606 OID 17528)
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (language_id);


--
-- TOC entry 3370 (class 2606 OID 24612)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- TOC entry 3362 (class 2606 OID 17732)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 3360 (class 2606 OID 17691)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 3356 (class 2606 OID 17644)
-- Name: student_subjects student_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subjects
    ADD CONSTRAINT student_subjects_pkey PRIMARY KEY (student_subject_id);


--
-- TOC entry 3348 (class 2606 OID 17595)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 3350 (class 2606 OID 17597)
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- TOC entry 3342 (class 2606 OID 17556)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (subject_id);


--
-- TOC entry 3354 (class 2606 OID 17632)
-- Name: teacher_availability teacher_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_availability
    ADD CONSTRAINT teacher_availability_pkey PRIMARY KEY (availability_id);


--
-- TOC entry 3366 (class 2606 OID 17763)
-- Name: teacher_grade_levels teacher_grade_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_grade_levels
    ADD CONSTRAINT teacher_grade_levels_pkey PRIMARY KEY (teacher_id, grade_level_id);


--
-- TOC entry 3364 (class 2606 OID 17748)
-- Name: teacher_languages teacher_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_languages
    ADD CONSTRAINT teacher_languages_pkey PRIMARY KEY (teacher_id, language_id);


--
-- TOC entry 3352 (class 2606 OID 17775)
-- Name: teacher_subjects teacher_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_pkey PRIMARY KEY (teacher_id, subject_id);


--
-- TOC entry 3344 (class 2606 OID 17569)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (teacher_id);


--
-- TOC entry 3346 (class 2606 OID 17571)
-- Name: teachers teachers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_key UNIQUE (user_id);


--
-- TOC entry 3338 (class 2606 OID 17542)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3340 (class 2606 OID 17540)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3393 (class 2620 OID 24599)
-- Name: hiring_contracts after_contract_creation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_contract_creation AFTER INSERT ON public.hiring_contracts FOR EACH ROW EXECUTE FUNCTION public.notify_on_contract_creation();


--
-- TOC entry 3394 (class 2620 OID 24600)
-- Name: hiring_contracts after_contract_status_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_contract_status_change AFTER UPDATE OF status ON public.hiring_contracts FOR EACH ROW EXECUTE FUNCTION public.notify_on_contract_status_change();


--
-- TOC entry 3391 (class 2606 OID 24586)
-- Name: contract_subjects contract_subjects_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_subjects
    ADD CONSTRAINT contract_subjects_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.hiring_contracts(contract_id) ON DELETE CASCADE;


--
-- TOC entry 3392 (class 2606 OID 24591)
-- Name: contract_subjects contract_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_subjects
    ADD CONSTRAINT contract_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id) ON DELETE CASCADE;


--
-- TOC entry 3380 (class 2606 OID 17666)
-- Name: hiring_contracts hiring_contracts_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hiring_contracts
    ADD CONSTRAINT hiring_contracts_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- TOC entry 3381 (class 2606 OID 17671)
-- Name: hiring_contracts hiring_contracts_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hiring_contracts
    ADD CONSTRAINT hiring_contracts_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3385 (class 2606 OID 17733)
-- Name: payments payments_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.hiring_contracts(contract_id) ON DELETE CASCADE;


--
-- TOC entry 3386 (class 2606 OID 17738)
-- Name: payments payments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- TOC entry 3382 (class 2606 OID 17692)
-- Name: reviews reviews_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.hiring_contracts(contract_id) ON DELETE CASCADE;


--
-- TOC entry 3383 (class 2606 OID 17697)
-- Name: reviews reviews_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- TOC entry 3384 (class 2606 OID 17702)
-- Name: reviews reviews_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3378 (class 2606 OID 17645)
-- Name: student_subjects student_subjects_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subjects
    ADD CONSTRAINT student_subjects_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- TOC entry 3379 (class 2606 OID 17650)
-- Name: student_subjects student_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subjects
    ADD CONSTRAINT student_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id) ON DELETE CASCADE;


--
-- TOC entry 3373 (class 2606 OID 17603)
-- Name: students students_grade_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_grade_level_id_fkey FOREIGN KEY (grade_level_id) REFERENCES public.grade_levels(grade_level_id) ON DELETE SET NULL;


--
-- TOC entry 3374 (class 2606 OID 17598)
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3377 (class 2606 OID 17633)
-- Name: teacher_availability teacher_availability_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_availability
    ADD CONSTRAINT teacher_availability_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3389 (class 2606 OID 17769)
-- Name: teacher_grade_levels teacher_grade_levels_grade_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_grade_levels
    ADD CONSTRAINT teacher_grade_levels_grade_level_id_fkey FOREIGN KEY (grade_level_id) REFERENCES public.grade_levels(grade_level_id) ON DELETE CASCADE;


--
-- TOC entry 3390 (class 2606 OID 17764)
-- Name: teacher_grade_levels teacher_grade_levels_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_grade_levels
    ADD CONSTRAINT teacher_grade_levels_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3387 (class 2606 OID 17754)
-- Name: teacher_languages teacher_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_languages
    ADD CONSTRAINT teacher_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(language_id) ON DELETE CASCADE;


--
-- TOC entry 3388 (class 2606 OID 17749)
-- Name: teacher_languages teacher_languages_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_languages
    ADD CONSTRAINT teacher_languages_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3375 (class 2606 OID 17620)
-- Name: teacher_subjects teacher_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id) ON DELETE CASCADE;


--
-- TOC entry 3376 (class 2606 OID 17615)
-- Name: teacher_subjects teacher_subjects_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON DELETE CASCADE;


--
-- TOC entry 3372 (class 2606 OID 17572)
-- Name: teachers teachers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3371 (class 2606 OID 17543)
-- Name: users users_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON DELETE SET NULL;


-- Completed on 2025-05-07 23:46:54 PKT

--
-- PostgreSQL database dump complete
--

