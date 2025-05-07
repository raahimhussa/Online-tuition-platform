--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.3

-- Started on 2025-05-07 23:48:54 PKT

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
-- TOC entry 3543 (class 0 OID 0)
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
-- TOC entry 3544 (class 0 OID 0)
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
-- TOC entry 3545 (class 0 OID 0)
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
-- TOC entry 3546 (class 0 OID 0)
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
-- TOC entry 3547 (class 0 OID 0)
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
-- TOC entry 3548 (class 0 OID 0)
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
-- TOC entry 3549 (class 0 OID 0)
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
-- TOC entry 3550 (class 0 OID 0)
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
-- TOC entry 3551 (class 0 OID 0)
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
-- TOC entry 3552 (class 0 OID 0)
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
-- TOC entry 3553 (class 0 OID 0)
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
-- TOC entry 3554 (class 0 OID 0)
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
-- TOC entry 3555 (class 0 OID 0)
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
-- TOC entry 3556 (class 0 OID 0)
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
-- TOC entry 3557 (class 0 OID 0)
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


-- Completed on 2025-05-07 23:49:21 PKT

--
-- PostgreSQL database dump complete
--

