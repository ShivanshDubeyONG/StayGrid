--
-- PostgreSQL database dump
--

\restrict OLhsZlQQyJvfNbBBYXcmV2ebSdokAws3UfCdZByYX5NewYvdkv1Byv28De5TwMG

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.vendors_vendorprofile DROP CONSTRAINT IF EXISTS vendors_vendorprofile_user_id_3929a54a_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.users_customerprofile DROP CONSTRAINT IF EXISTS users_customerprofile_user_id_c320f1e5_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.hotels_room DROP CONSTRAINT IF EXISTS hotels_room_hotel_id_0ee74c95_fk_hotels_hotel_id;
ALTER TABLE IF EXISTS ONLY public.hotels_review DROP CONSTRAINT IF EXISTS hotels_review_user_id_ebd052ef_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.hotels_review DROP CONSTRAINT IF EXISTS hotels_review_hotel_id_96e56aaa_fk_hotels_hotel_id;
ALTER TABLE IF EXISTS ONLY public.hotels_hotelimage DROP CONSTRAINT IF EXISTS hotels_hotelimage_hotel_id_ff6c0c35_fk_hotels_hotel_id;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel DROP CONSTRAINT IF EXISTS hotels_hotel_owner_id_dae0ba86_fk_vendors_vendorprofile_id;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel_amenities DROP CONSTRAINT IF EXISTS hotels_hotel_amenities_hotel_id_fcca9371_fk_hotels_hotel_id;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel_amenities DROP CONSTRAINT IF EXISTS hotels_hotel_amenities_amenity_id_bf0b2c3e_fk_hotels_amenity_id;
ALTER TABLE IF EXISTS ONLY public.hotels_booking DROP CONSTRAINT IF EXISTS hotels_booking_user_id_91e9bb9d_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.hotels_booking DROP CONSTRAINT IF EXISTS hotels_booking_room_id_a36c4fd7_fk_hotels_room_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
DROP INDEX IF EXISTS public.users_customerprofile_phone_number_912ceb26_like;
DROP INDEX IF EXISTS public.hotels_room_hotel_id_0ee74c95;
DROP INDEX IF EXISTS public.hotels_review_user_id_ebd052ef;
DROP INDEX IF EXISTS public.hotels_review_hotel_id_96e56aaa;
DROP INDEX IF EXISTS public.hotels_hotelimage_hotel_id_ff6c0c35;
DROP INDEX IF EXISTS public.hotels_hotel_owner_id_dae0ba86;
DROP INDEX IF EXISTS public.hotels_hotel_amenities_hotel_id_fcca9371;
DROP INDEX IF EXISTS public.hotels_hotel_amenities_amenity_id_bf0b2c3e;
DROP INDEX IF EXISTS public.hotels_booking_user_id_91e9bb9d;
DROP INDEX IF EXISTS public.hotels_booking_room_id_a36c4fd7;
DROP INDEX IF EXISTS public.hotels_amenity_name_adf4f6a4_like;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
ALTER TABLE IF EXISTS ONLY public.vendors_vendorprofile DROP CONSTRAINT IF EXISTS vendors_vendorprofile_user_id_key;
ALTER TABLE IF EXISTS ONLY public.vendors_vendorprofile DROP CONSTRAINT IF EXISTS vendors_vendorprofile_pkey;
ALTER TABLE IF EXISTS ONLY public.users_customerprofile DROP CONSTRAINT IF EXISTS users_customerprofile_user_id_key;
ALTER TABLE IF EXISTS ONLY public.users_customerprofile DROP CONSTRAINT IF EXISTS users_customerprofile_pkey;
ALTER TABLE IF EXISTS ONLY public.users_customerprofile DROP CONSTRAINT IF EXISTS users_customerprofile_phone_number_key;
ALTER TABLE IF EXISTS ONLY public.hotels_room DROP CONSTRAINT IF EXISTS unique_room_number_per_hotel;
ALTER TABLE IF EXISTS ONLY public.hotels_review DROP CONSTRAINT IF EXISTS one_review_per_user_per_hotel;
ALTER TABLE IF EXISTS ONLY public.hotels_room DROP CONSTRAINT IF EXISTS hotels_room_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_review DROP CONSTRAINT IF EXISTS hotels_review_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_hotelimage DROP CONSTRAINT IF EXISTS hotels_hotelimage_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel DROP CONSTRAINT IF EXISTS hotels_hotel_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel_amenities DROP CONSTRAINT IF EXISTS hotels_hotel_amenities_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_hotel_amenities DROP CONSTRAINT IF EXISTS hotels_hotel_amenities_hotel_id_amenity_id_11a02791_uniq;
ALTER TABLE IF EXISTS ONLY public.hotels_booking DROP CONSTRAINT IF EXISTS hotels_booking_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_amenity DROP CONSTRAINT IF EXISTS hotels_amenity_pkey;
ALTER TABLE IF EXISTS ONLY public.hotels_amenity DROP CONSTRAINT IF EXISTS hotels_amenity_name_key;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
DROP TABLE IF EXISTS public.vendors_vendorprofile;
DROP TABLE IF EXISTS public.users_customerprofile;
DROP TABLE IF EXISTS public.hotels_room;
DROP TABLE IF EXISTS public.hotels_review;
DROP TABLE IF EXISTS public.hotels_hotelimage;
DROP TABLE IF EXISTS public.hotels_hotel_amenities;
DROP TABLE IF EXISTS public.hotels_hotel;
DROP TABLE IF EXISTS public.hotels_booking;
DROP TABLE IF EXISTS public.hotels_amenity;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: hotels_amenity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_amenity (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: hotels_amenity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_amenity ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_amenity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_booking; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_booking (
    id bigint NOT NULL,
    check_in date NOT NULL,
    check_out date NOT NULL,
    total_price numeric(10,2) NOT NULL,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    room_id bigint NOT NULL,
    guests integer NOT NULL,
    CONSTRAINT checkout_after_checkin CHECK ((check_out > check_in)),
    CONSTRAINT hotels_booking_guests_check CHECK ((guests >= 0))
);


--
-- Name: hotels_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_booking ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_hotel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_hotel (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    location character varying(200) NOT NULL,
    original_price numeric(10,2) NOT NULL,
    offer_price numeric(10,2) NOT NULL,
    star_rating integer NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    owner_id bigint NOT NULL,
    CONSTRAINT hotels_hotel_star_rating_check CHECK ((star_rating >= 0))
);


--
-- Name: hotels_hotel_amenities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_hotel_amenities (
    id bigint NOT NULL,
    hotel_id bigint NOT NULL,
    amenity_id bigint NOT NULL
);


--
-- Name: hotels_hotel_amenities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_hotel_amenities ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_hotel_amenities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_hotel ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_hotelimage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_hotelimage (
    id bigint NOT NULL,
    image character varying(100) NOT NULL,
    hotel_id bigint NOT NULL
);


--
-- Name: hotels_hotelimage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_hotelimage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_hotelimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_review (
    id bigint NOT NULL,
    rating integer NOT NULL,
    comment text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    hotel_id bigint NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT hotels_review_rating_check CHECK ((rating >= 0))
);


--
-- Name: hotels_review_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_review ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hotels_room; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels_room (
    id bigint NOT NULL,
    room_number character varying(20) NOT NULL,
    room_type character varying(20) NOT NULL,
    capacity integer NOT NULL,
    price_per_night numeric(10,2) NOT NULL,
    is_active boolean NOT NULL,
    hotel_id bigint NOT NULL,
    CONSTRAINT hotels_room_capacity_check CHECK ((capacity >= 0)),
    CONSTRAINT room_capacity_must_be_positive CHECK ((capacity > 0))
);


--
-- Name: hotels_room_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.hotels_room ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.hotels_room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_customerprofile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_customerprofile (
    id bigint NOT NULL,
    phone_number character varying(15) NOT NULL,
    is_verified boolean NOT NULL,
    profile_picture character varying(100),
    user_id integer NOT NULL
);


--
-- Name: users_customerprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users_customerprofile ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_customerprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vendors_vendorprofile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors_vendorprofile (
    id bigint NOT NULL,
    business_name character varying(150) NOT NULL,
    phone_number character varying(15) NOT NULL,
    is_verified boolean NOT NULL,
    profile_picture character varying(100),
    user_id integer NOT NULL
);


--
-- Name: vendors_vendorprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.vendors_vendorprofile ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.vendors_vendorprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add customer profile	7	add_customerprofile
26	Can change customer profile	7	change_customerprofile
27	Can delete customer profile	7	delete_customerprofile
28	Can view customer profile	7	view_customerprofile
29	Can add amenity	8	add_amenity
30	Can change amenity	8	change_amenity
31	Can delete amenity	8	delete_amenity
32	Can view amenity	8	view_amenity
33	Can add hotel	9	add_hotel
34	Can change hotel	9	change_hotel
35	Can delete hotel	9	delete_hotel
36	Can view hotel	9	view_hotel
37	Can add hotel image	10	add_hotelimage
38	Can change hotel image	10	change_hotelimage
39	Can delete hotel image	10	delete_hotelimage
40	Can view hotel image	10	view_hotelimage
41	Can add room	11	add_room
42	Can change room	11	change_room
43	Can delete room	11	delete_room
44	Can view room	11	view_room
45	Can add booking	12	add_booking
46	Can change booking	12	change_booking
47	Can delete booking	12	delete_booking
48	Can view booking	12	view_booking
49	Can add review	13	add_review
50	Can change review	13	change_review
51	Can delete review	13	delete_review
52	Can view review	13	view_review
53	Can add vendor profile	14	add_vendorprofile
54	Can change vendor profile	14	change_vendorprofile
55	Can delete vendor profile	14	delete_vendorprofile
56	Can view vendor profile	14	view_vendorprofile
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$1000000$kbK5XxMThzC57shdzgKKyj$GdAtmIc8equos5JldKoVAvMTAfKdGY7ojgl8PvJIANQ=	\N	t	shivansh				t	t	2026-08-30 14:36:31.642287+05:30
5	pbkdf2_sha256$1000000$HRe8w5ggJxpdlTn4DYLNl1$iVDFeokuSLLYjgdYEuNAUiF+WWryXnyJ3kgnkbZHZ/o=	\N	f	staygrid_vendor	StayGrid	Hotels	vendor@staygrid.com	f	t	2026-08-31 13:44:06.049216+05:30
3	pbkdf2_sha256$1000000$U2O0N5feJ6yY7basonASQV$/s06e+APgZJHPn8at7CPi2A8gvMAU/koP9yw43pLEX4=	2026-09-02 13:46:58.270005+05:30	f	shailesh	Shailesh	Dubey	shaileshdubeyd381970@gmail.com	f	t	2026-08-30 15:30:55.844273+05:30
4	pbkdf2_sha256$1000000$rGqlRhVLikKVn9ChUBheA4$wg9RrV44MUORkZIje5Gf7CzvXfCmSYS5eXKe5oLZzxk=	2026-09-02 13:47:04.227385+05:30	t	superuser			superuser@gmail.com	t	t	2026-08-30 16:14:17.367062+05:30
2	pbkdf2_sha256$1000000$BKqTCRiwj8K1TF4EjHyOwM$h4FR/C2roSWFUXhp+lBvOAD/zSJil80mhThS8dCXLxg=	2026-09-02 13:47:17.589728+05:30	f	shivanshdubeyfr	Shivansh	Dubey	shivanshdhardubey@gmail.com	f	t	2026-08-30 15:04:20.601644+05:30
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	users	customerprofile
8	hotels	amenity
9	hotels	hotel
10	hotels	hotelimage
11	hotels	room
12	hotels	booking
13	hotels	review
14	vendors	vendorprofile
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-08-30 12:50:36.393638+05:30
2	auth	0001_initial	2026-08-30 12:50:36.447985+05:30
3	admin	0001_initial	2026-08-30 12:50:36.466716+05:30
4	admin	0002_logentry_remove_auto_add	2026-08-30 12:50:36.472722+05:30
5	admin	0003_logentry_add_action_flag_choices	2026-08-30 12:50:36.47874+05:30
6	contenttypes	0002_remove_content_type_name	2026-08-30 12:50:36.491587+05:30
7	auth	0002_alter_permission_name_max_length	2026-08-30 12:50:36.496662+05:30
8	auth	0003_alter_user_email_max_length	2026-08-30 12:50:36.503401+05:30
9	auth	0004_alter_user_username_opts	2026-08-30 12:50:36.509612+05:30
10	auth	0005_alter_user_last_login_null	2026-08-30 12:50:36.514433+05:30
11	auth	0006_require_contenttypes_0002	2026-08-30 12:50:36.516591+05:30
12	auth	0007_alter_validators_add_error_messages	2026-08-30 12:50:36.522448+05:30
13	auth	0008_alter_user_username_max_length	2026-08-30 12:50:36.531401+05:30
14	auth	0009_alter_user_last_name_max_length	2026-08-30 12:50:36.541165+05:30
15	auth	0010_alter_group_name_max_length	2026-08-30 12:50:36.548323+05:30
16	auth	0011_update_proxy_permissions	2026-08-30 12:50:36.554146+05:30
17	auth	0012_alter_user_first_name_max_length	2026-08-30 12:50:36.560133+05:30
18	sessions	0001_initial	2026-08-30 12:50:36.568343+05:30
19	vendors	0001_initial	2026-08-30 14:34:53.209914+05:30
20	hotels	0001_initial	2026-08-30 14:34:53.283433+05:30
21	hotels	0002_remove_room_unique_room_per_hotel_and_more	2026-08-30 14:34:53.377913+05:30
22	users	0001_initial	2026-08-30 14:34:53.395591+05:30
23	hotels	0003_booking_guests	2026-09-02 11:58:11.649012+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
ml0br9dlf1rrkbybw83sik5p9vx1husn	.eJxVjDEOgzAQBP_iOrJs7jB2yvS8wbLvjpgkAglDFeXvAYkiabbYmd23imlbS9yqLHFkdVWoLr9dTvSU6QD8SNN91jRP6zJmfSj6pFX3M8vrdrp_ByXVsq99y0HQcrZIYsSBRwgDu8G0KNR0aJsAIGQduD2ZAgQG7IKlJMYb9fkC3Cc3fQ:1x0d26:G4gAxruSaw8FNy6h7NB_lwLWQ5LgCOBTHeFHv8k5w68	2026-09-13 16:15:02.366321+05:30
4hem8iqg6tnh28a0erh4bp8sf74vhghn	.eJxVjMsOwiAQRf-FtSHDU3Dpvt9ABgakaiAp7cr479qkC93ec859sYDbWsM28hJmYhcm2el3i5geue2A7thunafe1mWOfFf4QQefOuXn9XD_DiqO-q0hFeW0VsJ4sD4WcEoVipTp7LOSUAxg1mTBJkTniyGtRYoiUlLSIrD3B99LOCI:1x1JNS:HEs5SdouqrpRfMHaGfQORhTncHqDr3mfY_CTR7Ggef8	2026-09-15 13:27:54.780611+05:30
jdwmvxcuze59c8yo3wgk89psqt71xx9b	.eJxVjMsOwiAQRf-FtSHDU3Dpvt9ABgakaiAp7cr479qkC93ec859sYDbWsM28hJmYhcm2el3i5geue2A7thunafe1mWOfFf4QQefOuXn9XD_DiqO-q0hFeW0VsJ4sD4WcEoVipTp7LOSUAxg1mTBJkTniyGtRYoiUlLSIrD3B99LOCI:1x1g9l:e5PVv0n4K0qSOQFcRVtx0Wou11LfxUr7JqzrFbAF1Rc	2026-09-16 13:47:17.592275+05:30
\.


--
-- Data for Name: hotels_amenity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_amenity (id, name) FROM stdin;
\.


--
-- Data for Name: hotels_booking; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_booking (id, check_in, check_out, total_price, status, created_at, user_id, room_id, guests) FROM stdin;
2	2026-09-05	2026-09-13	16232.00	CANCELLED	2026-09-01 14:37:17.288363+05:30	2	166	1
1	2026-09-10	2026-09-12	3498.00	CANCELLED	2026-09-01 14:08:44.209597+05:30	2	1	1
3	2026-09-04	2026-09-06	8598.00	CANCELLED	2026-09-02 13:37:02.085085+05:30	2	127	2
\.


--
-- Data for Name: hotels_hotel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_hotel (id, name, description, location, original_price, offer_price, star_rating, is_active, created_at, updated_at, owner_id) FROM stdin;
10	Mumbai Harbour View	A premium urban stay near South Mumbai's iconic landmarks, restaurants and waterfront.	Colaba, Mumbai	8123.00	6499.00	5	t	2026-08-31 13:47:53.759605+05:30	2026-08-31 13:47:53.759605+05:30	2
11	Marine Drive Residency	A comfortable city hotel offering quick access to Marine Drive and central Mumbai.	Marine Drive, Mumbai	6623.00	5299.00	4	t	2026-08-31 13:47:53.761619+05:30	2026-08-31 13:47:53.761619+05:30	2
12	The Bombay House	A modern lifestyle hotel surrounded by entertainment, dining and Mumbai's vibrant nightlife.	Bandra West, Mumbai	5498.00	4399.00	4	t	2026-08-31 13:47:53.763618+05:30	2026-08-31 13:47:53.763618+05:30	2
13	Palm Beach Suites	A spacious business-friendly hotel ideal for travellers visiting Navi Mumbai.	Navi Mumbai	4123.00	3299.00	4	t	2026-08-31 13:47:53.765618+05:30	2026-08-31 13:47:53.765618+05:30	2
14	Gateway Grand	A premium business hotel with excellent airport connectivity and modern facilities.	Andheri East, Mumbai	6248.00	4999.00	5	t	2026-08-31 13:47:53.76674+05:30	2026-08-31 13:47:53.76674+05:30	2
15	Capital Heights	A sophisticated city hotel located near Delhi's major commercial and cultural attractions.	Connaught Place, Delhi	7248.00	5799.00	5	t	2026-08-31 13:47:53.768778+05:30	2026-08-31 13:47:53.768778+05:30	2
16	Delhi Heritage Inn	An affordable central stay for travellers exploring the historic heart of Delhi.	Paharganj, Delhi	2748.00	2199.00	3	t	2026-08-31 13:47:53.770183+05:30	2026-08-31 13:47:53.770183+05:30	2
17	The Imperial Residency	A polished business and leisure hotel close to premium shopping and entertainment destinations.	Saket, Delhi	4873.00	3899.00	4	t	2026-08-31 13:47:53.77118+05:30	2026-08-31 13:47:53.77118+05:30	2
18	Aerocity Grand	A modern airport-side hotel designed for business travellers and short city stays.	Aerocity, Delhi	6498.00	5199.00	5	t	2026-08-31 13:47:53.773219+05:30	2026-08-31 13:47:53.773219+05:30	2
19	Green Park Suites	A quiet urban property with convenient access to South Delhi's business and residential districts.	Green Park, Delhi	4373.00	3499.00	4	t	2026-08-31 13:47:53.774189+05:30	2026-08-31 13:47:53.774189+05:30	2
20	Hyderabad Pearl Palace	A premium Hyderabad property combining elegant rooms with easy access to restaurants and business districts.	Banjara Hills, Hyderabad	5873.00	4699.00	5	t	2026-08-31 13:47:53.776418+05:30	2026-08-31 13:47:53.776418+05:30	2
21	Charminar Comforts	A comfortable budget-friendly stay near Hyderabad's historic attractions.	Old City, Hyderabad	2498.00	1999.00	3	t	2026-08-31 13:47:53.777449+05:30	2026-08-31 13:47:53.777449+05:30	2
22	Hitech City Heights	A business-focused hotel located near Hyderabad's technology and corporate hubs.	HITEC City, Hyderabad	4498.00	3599.00	4	t	2026-08-31 13:47:53.779109+05:30	2026-08-31 13:47:53.779109+05:30	2
40	Mumbai City Palace	A premium StayGrid property in Dadar, Mumbai, offering comfortable rooms, modern facilities and convenient access to the city.	Dadar, Mumbai	4873.00	3899.00	4	t	2026-08-31 13:50:34.08385+05:30	2026-08-31 13:50:34.08385+05:30	2
23	Lakeview Residency	A relaxed city stay offering convenient access to Hyderabad's major attractions.	Hussain Sagar, Hyderabad	4123.00	3299.00	4	t	2026-08-31 13:47:53.780627+05:30	2026-08-31 13:47:53.780627+05:30	2
24	Deccan Royale	An upscale lifestyle hotel surrounded by premium restaurants, shopping and entertainment.	Jubilee Hills, Hyderabad	6248.00	4999.00	5	t	2026-08-31 13:47:53.781626+05:30	2026-08-31 13:47:53.781626+05:30	2
25	Pune Central Suites	A centrally located Pune hotel suited for business travellers and city explorers.	Shivajinagar, Pune	3998.00	3199.00	4	t	2026-08-31 13:47:53.783626+05:30	2026-08-31 13:47:53.783626+05:30	2
2	The Urban Nest	A stylish boutique stay designed for travellers who want modern rooms, great connectivity and the best of Bengaluru right outside.	Indiranagar, Bengaluru	4500.00	3199.00	4	t	2026-08-31 13:44:06.400857+05:30	2026-08-31 13:44:06.400857+05:30	2
38	Bengaluru Palace Hotel	A premium StayGrid property in Yeshwanthpur, Bengaluru, offering comfortable rooms, modern facilities and convenient access to the city.	Yeshwanthpur, Bengaluru	5998.00	4799.00	5	t	2026-08-31 13:50:34.079734+05:30	2026-08-31 13:50:34.079734+05:30	2
26	Tech Park Residency	A practical modern stay near Pune's major technology parks and corporate offices.	Hinjewadi, Pune	3623.00	2899.00	4	t	2026-08-31 13:47:53.784627+05:30	2026-08-31 13:47:53.784627+05:30	2
27	Koregaon Park House	A stylish lifestyle property surrounded by cafés, restaurants and nightlife.	Koregaon Park, Pune	5373.00	4299.00	5	t	2026-08-31 13:47:53.78613+05:30	2026-08-31 13:47:53.78613+05:30	2
28	Chennai Marina Grand	A premium coastal city hotel near Chennai's famous Marina Beach.	Marina Beach, Chennai	5998.00	4799.00	5	t	2026-08-31 13:47:53.787905+05:30	2026-08-31 13:47:53.787905+05:30	2
29	T Nagar Residency	A convenient urban stay near shopping districts and Chennai's commercial centre.	T Nagar, Chennai	3748.00	2999.00	4	t	2026-08-31 13:47:53.788909+05:30	2026-08-31 13:47:53.789915+05:30	2
30	OMR Business Hotel	A modern business hotel serving travellers visiting Chennai's technology corridor.	OMR, Chennai	3998.00	3199.00	4	t	2026-08-31 13:47:53.790863+05:30	2026-08-31 13:47:53.790863+05:30	2
31	Goa Palm Resort	A tropical resort close to Goa's beaches, nightlife and popular restaurants.	Calangute, Goa	6998.00	5599.00	5	t	2026-08-31 13:47:53.791337+05:30	2026-08-31 13:47:53.791337+05:30	2
32	Mandrem Beach House	A relaxed beachside property designed for travellers looking for a quieter Goa experience.	Mandrem, Goa	5623.00	4499.00	4	t	2026-08-31 13:47:53.793338+05:30	2026-08-31 13:47:53.793338+05:30	2
33	Jaipur Royal Haveli	A luxurious Jaipur stay blending modern comfort with Rajasthan-inspired architecture.	C-Scheme, Jaipur	5248.00	4199.00	5	t	2026-08-31 13:47:53.794242+05:30	2026-08-31 13:47:53.794242+05:30	2
34	Pink City Residency	A comfortable city hotel offering easy access to Jaipur's historic attractions.	Bani Park, Jaipur	3498.00	2799.00	4	t	2026-08-31 13:47:53.79547+05:30	2026-08-31 13:47:53.79547+05:30	2
3	The Royal Orchid	An upscale business-friendly hotel in the heart of Bengaluru, ideal for corporate travellers and weekend city breaks.	MG Road, Bengaluru	7000.00	5499.00	5	t	2026-08-31 13:44:06.40713+05:30	2026-08-31 13:44:06.40713+05:30	2
41	Coastal Crown Mumbai	A premium StayGrid property in Juhu, Mumbai, offering comfortable rooms, modern facilities and convenient access to the city.	Juhu, Mumbai	7248.00	5799.00	5	t	2026-08-31 13:50:34.08485+05:30	2026-08-31 13:50:34.08485+05:30	2
42	Western Express Hotel	A premium StayGrid property in Goregaon, Mumbai, offering comfortable rooms, modern facilities and convenient access to the city.	Goregaon, Mumbai	4248.00	3399.00	4	t	2026-08-31 13:50:34.08585+05:30	2026-08-31 13:50:34.08585+05:30	2
43	South Mumbai Suites	A premium StayGrid property in Fort, Mumbai, offering comfortable rooms, modern facilities and convenient access to the city.	Fort, Mumbai	7748.00	6199.00	5	t	2026-08-31 13:50:34.087851+05:30	2026-08-31 13:50:34.087851+05:30	2
44	Bandra Skyline	A premium StayGrid property in Bandra East, Mumbai, offering comfortable rooms, modern facilities and convenient access to the city.	Bandra East, Mumbai	5248.00	4199.00	4	t	2026-08-31 13:50:34.088851+05:30	2026-08-31 13:50:34.088851+05:30	2
45	Delhi Central Residency	A premium StayGrid property in Karol Bagh, Delhi, offering comfortable rooms, modern facilities and convenient access to the city.	Karol Bagh, Delhi	3623.00	2899.00	4	t	2026-08-31 13:50:34.090254+05:30	2026-08-31 13:50:34.090254+05:30	2
46	India Gate Suites	A premium StayGrid property in Pragati Maidan, Delhi, offering comfortable rooms, modern facilities and convenient access to the city.	Pragati Maidan, Delhi	6623.00	5299.00	5	t	2026-08-31 13:50:34.092066+05:30	2026-08-31 13:50:34.092066+05:30	2
47	Delhi Metro Heights	A premium StayGrid property in Dwarka, Delhi, offering comfortable rooms, modern facilities and convenient access to the city.	Dwarka, Delhi	3998.00	3199.00	4	t	2026-08-31 13:50:34.094519+05:30	2026-08-31 13:50:34.094519+05:30	2
48	Hauz Khas House	A premium StayGrid property in Hauz Khas, Delhi, offering comfortable rooms, modern facilities and convenient access to the city.	Hauz Khas, Delhi	4748.00	3799.00	4	t	2026-08-31 13:50:34.095668+05:30	2026-08-31 13:50:34.095668+05:30	2
49	Rohini Grand	A premium StayGrid property in Rohini, Delhi, offering comfortable rooms, modern facilities and convenient access to the city.	Rohini, Delhi	2873.00	2299.00	3	t	2026-08-31 13:50:34.097524+05:30	2026-08-31 13:50:34.097524+05:30	2
50	Hyderabad Central Palace	A premium StayGrid property in Begumpet, Hyderabad, offering comfortable rooms, modern facilities and convenient access to the city.	Begumpet, Hyderabad	4123.00	3299.00	4	t	2026-08-31 13:50:34.099029+05:30	2026-08-31 13:50:34.099029+05:30	2
51	Cyber Towers Hotel	A premium StayGrid property in Madhapur, Hyderabad, offering comfortable rooms, modern facilities and convenient access to the city.	Madhapur, Hyderabad	5623.00	4499.00	5	t	2026-08-31 13:50:34.099544+05:30	2026-08-31 13:50:34.099544+05:30	2
52	Charminar Grand Stay	A premium StayGrid property in Charminar, Hyderabad, offering comfortable rooms, modern facilities and convenient access to the city.	Charminar, Hyderabad	2498.00	1999.00	3	t	2026-08-31 13:50:34.101551+05:30	2026-08-31 13:50:34.101551+05:30	2
53	Banjara Luxury Suites	A premium StayGrid property in Banjara Hills, Hyderabad, offering comfortable rooms, modern facilities and convenient access to the city.	Banjara Hills, Hyderabad	6623.00	5299.00	5	t	2026-08-31 13:50:34.10255+05:30	2026-08-31 13:50:34.10255+05:30	2
54	Pune Grand Central	A premium StayGrid property in Kalyani Nagar, Pune, offering comfortable rooms, modern facilities and convenient access to the city.	Kalyani Nagar, Pune	5748.00	4599.00	5	t	2026-08-31 13:50:34.10455+05:30	2026-08-31 13:50:34.10455+05:30	2
55	Pune City Residency	A premium StayGrid property in Viman Nagar, Pune, offering comfortable rooms, modern facilities and convenient access to the city.	Viman Nagar, Pune	3748.00	2999.00	4	t	2026-08-31 13:50:34.105565+05:30	2026-08-31 13:50:34.105565+05:30	2
56	Deccan Heights	A premium StayGrid property in Deccan, Pune, offering comfortable rooms, modern facilities and convenient access to the city.	Deccan, Pune	3998.00	3199.00	4	t	2026-08-31 13:50:34.106572+05:30	2026-08-31 13:50:34.106572+05:30	2
57	Baner Business Suites	A premium StayGrid property in Baner, Pune, offering comfortable rooms, modern facilities and convenient access to the city.	Baner, Pune	4373.00	3499.00	4	t	2026-08-31 13:50:34.107571+05:30	2026-08-31 13:50:34.107571+05:30	2
58	Chennai Coastal Palace	A premium StayGrid property in Besant Nagar, Chennai, offering comfortable rooms, modern facilities and convenient access to the city.	Besant Nagar, Chennai	6248.00	4999.00	5	t	2026-08-31 13:50:34.109076+05:30	2026-08-31 13:50:34.109076+05:30	2
59	Chennai Central Stay	A premium StayGrid property in Egmore, Chennai, offering comfortable rooms, modern facilities and convenient access to the city.	Egmore, Chennai	3748.00	2999.00	4	t	2026-08-31 13:50:34.110723+05:30	2026-08-31 13:50:34.110723+05:30	2
60	Adyar Garden Hotel	A premium StayGrid property in Adyar, Chennai, offering comfortable rooms, modern facilities and convenient access to the city.	Adyar, Chennai	4123.00	3299.00	4	t	2026-08-31 13:50:34.111852+05:30	2026-08-31 13:50:34.111852+05:30	2
61	Goa Sunset Resort	A premium StayGrid property in Baga, Goa, offering comfortable rooms, modern facilities and convenient access to the city.	Baga, Goa	7248.00	5799.00	5	t	2026-08-31 13:50:34.112928+05:30	2026-08-31 13:50:34.112928+05:30	2
62	Goa Beachside Suites	A premium StayGrid property in Candolim, Goa, offering comfortable rooms, modern facilities and convenient access to the city.	Candolim, Goa	7873.00	6299.00	5	t	2026-08-31 13:50:34.113933+05:30	2026-08-31 13:50:34.113933+05:30	2
63	Coconut Grove Goa	A premium StayGrid property in Anjuna, Goa, offering comfortable rooms, modern facilities and convenient access to the city.	Anjuna, Goa	5373.00	4299.00	4	t	2026-08-31 13:50:34.115932+05:30	2026-08-31 13:50:34.115932+05:30	2
64	Blue Lagoon Resort	A premium StayGrid property in Vagator, Goa, offering comfortable rooms, modern facilities and convenient access to the city.	Vagator, Goa	5748.00	4599.00	4	t	2026-08-31 13:50:34.116932+05:30	2026-08-31 13:50:34.116932+05:30	2
65	Jaipur Palace Residency	A premium StayGrid property in MI Road, Jaipur, offering comfortable rooms, modern facilities and convenient access to the city.	MI Road, Jaipur	5623.00	4499.00	5	t	2026-08-31 13:50:34.117933+05:30	2026-08-31 13:50:34.117933+05:30	2
66	Amber View Hotel	A premium StayGrid property in Amer, Jaipur, offering comfortable rooms, modern facilities and convenient access to the city.	Amer, Jaipur	4498.00	3599.00	4	t	2026-08-31 13:50:34.118932+05:30	2026-08-31 13:50:34.118932+05:30	2
67	Hawa Mahal Suites	A premium StayGrid property in Pink City, Jaipur, offering comfortable rooms, modern facilities and convenient access to the city.	Pink City, Jaipur	4123.00	3299.00	4	t	2026-08-31 13:50:34.12103+05:30	2026-08-31 13:50:34.12103+05:30	2
68	Kochi Waterfront Hotel	A premium StayGrid property in Marine Drive, Kochi, offering comfortable rooms, modern facilities and convenient access to the city.	Marine Drive, Kochi	5248.00	4199.00	5	t	2026-08-31 13:50:34.122029+05:30	2026-08-31 13:50:34.122029+05:30	2
69	Kerala Palm Residency	A premium StayGrid property in Kakkanad, Kochi, offering comfortable rooms, modern facilities and convenient access to the city.	Kakkanad, Kochi	3748.00	2999.00	4	t	2026-08-31 13:50:34.123031+05:30	2026-08-31 13:50:34.123031+05:30	2
39	Oakwood Business Stay	A premium StayGrid property in Bellandur, Bengaluru, offering comfortable rooms, modern facilities and convenient access to the city.	Bellandur, Bengaluru	4498.00	3599.00	4	t	2026-08-31 13:50:34.081851+05:30	2026-08-31 13:50:34.081851+05:30	2
70	Mysore Royal Stay	A premium StayGrid property in Mysore, Karnataka, offering comfortable rooms, modern facilities and convenient access to the city.	Mysore, Karnataka	3498.00	2799.00	4	t	2026-08-31 13:50:34.12503+05:30	2026-08-31 13:50:34.12503+05:30	2
71	Udaipur Lake Palace Stay	A premium StayGrid property in Lake Pichola, Udaipur, offering comfortable rooms, modern facilities and convenient access to the city.	Lake Pichola, Udaipur	6998.00	5599.00	5	t	2026-08-31 13:50:34.125658+05:30	2026-08-31 13:50:34.125658+05:30	2
72	Ahmedabad Business Suites	A premium StayGrid property in SG Highway, Ahmedabad, offering comfortable rooms, modern facilities and convenient access to the city.	SG Highway, Ahmedabad	3748.00	2999.00	4	t	2026-08-31 13:50:34.127034+05:30	2026-08-31 13:50:34.127034+05:30	2
73	Lucknow Heritage Hotel	A premium StayGrid property in Hazratganj, Lucknow, offering comfortable rooms, modern facilities and convenient access to the city.	Hazratganj, Lucknow	4873.00	3899.00	5	t	2026-08-31 13:50:34.128041+05:30	2026-08-31 13:50:34.128041+05:30	2
74	Kolkata Riverside Residency	A premium StayGrid property in Park Street, Kolkata, offering comfortable rooms, modern facilities and convenient access to the city.	Park Street, Kolkata	4123.00	3299.00	4	t	2026-08-31 13:50:34.129546+05:30	2026-08-31 13:50:34.129546+05:30	2
4	Palm Grove Retreat	A peaceful premium property near Whitefield offering spacious rooms for business and leisure travellers.	Whitefield, Bengaluru	4800.00	3499.00	4	t	2026-08-31 13:44:06.408859+05:30	2026-08-31 13:44:06.408859+05:30	2
5	Skyline Suites	Contemporary serviced accommodation with spacious suites, comfortable interiors and excellent access to major business hubs.	HSR Layout, Bengaluru	6200.00	4599.00	5	t	2026-08-31 13:44:06.409864+05:30	2026-08-31 13:44:06.409864+05:30	2
6	Metro Heights	A comfortable city stay combining affordable pricing with premium rooms and convenient access to shopping and restaurants.	Jayanagar, Bengaluru	3900.00	2799.00	3	t	2026-08-31 13:44:06.411289+05:30	2026-08-31 13:44:06.411289+05:30	2
7	The Velvet Palm	A business-oriented property close to Bengaluru's major technology campuses, built for comfortable long and short stays.	Electronic City, Bengaluru	4300.00	2999.00	4	t	2026-08-31 13:44:06.412289+05:30	2026-08-31 13:44:06.412289+05:30	2
8	Lakeside Haven	A premium lakeside-inspired retreat offering elegant rooms and a relaxed atmosphere away from the busiest parts of the city.	Hebbal, Bengaluru	5800.00	4199.00	5	t	2026-08-31 13:44:06.413288+05:30	2026-08-31 13:44:06.413288+05:30	2
9	Royal Orchid Central	An upscale business hotel offering premium rooms and excellent connectivity across central Bengaluru.	MG Road, Bengaluru	6873.00	5499.00	5	t	2026-08-31 13:47:53.753299+05:30	2026-08-31 13:47:53.753299+05:30	2
35	Bengaluru Central Suites	A premium StayGrid property in Malleshwaram, Bengaluru, offering comfortable rooms, modern facilities and convenient access to the city.	Malleshwaram, Bengaluru	3623.00	2899.00	4	t	2026-08-31 13:50:34.072142+05:30	2026-08-31 13:50:34.072142+05:30	2
36	Garden City Residency	A premium StayGrid property in Rajajinagar, Bengaluru, offering comfortable rooms, modern facilities and convenient access to the city.	Rajajinagar, Bengaluru	2748.00	2199.00	3	t	2026-08-31 13:50:34.077224+05:30	2026-08-31 13:50:34.077224+05:30	2
37	Silicon Valley Stay	A premium StayGrid property in Marathahalli, Bengaluru, offering comfortable rooms, modern facilities and convenient access to the city.	Marathahalli, Bengaluru	4123.00	3299.00	4	t	2026-08-31 13:50:34.078728+05:30	2026-08-31 13:50:34.078728+05:30	2
1	StayGrid Grand Bengaluru	A modern city hotel located in central Bengaluru.	Koramangala, Bengaluru	3500.00	2499.00	4	t	2026-08-30 15:59:46.481514+05:30	2026-08-30 15:59:46.481514+05:30	1
\.


--
-- Data for Name: hotels_hotel_amenities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_hotel_amenities (id, hotel_id, amenity_id) FROM stdin;
\.


--
-- Data for Name: hotels_hotelimage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_hotelimage (id, image, hotel_id) FROM stdin;
1	hotels/hotel1.jpg	1
2	hotels/hotel2.jpg	2
3	hotels/hotel3.jpg	3
4	hotels/hotel4.jpg	4
5	hotels/hotel5.jpg	5
6	hotels/hotel6.jpg	6
7	hotels/hotel7.jpg	7
8	hotels/hotel8.jpg	8
9	hotels/hotel9.jpeg	9
10	hotels/hotel10.webp	10
11	hotels/hotel1.jpg	11
12	hotels/hotel2.jpg	12
13	hotels/hotel3.jpg	13
14	hotels/hotel4.jpg	14
15	hotels/hotel5.jpg	15
16	hotels/hotel6.jpg	16
17	hotels/hotel7.jpg	17
18	hotels/hotel8.jpg	18
19	hotels/hotel9.jpeg	19
20	hotels/hotel10.webp	20
21	hotels/hotel1.jpg	21
22	hotels/hotel2.jpg	22
23	hotels/hotel3.jpg	23
24	hotels/hotel4.jpg	24
25	hotels/hotel5.jpg	25
26	hotels/hotel6.jpg	26
27	hotels/hotel7.jpg	27
28	hotels/hotel8.jpg	28
29	hotels/hotel9.jpeg	29
30	hotels/hotel10.webp	30
31	hotels/hotel1.jpg	31
32	hotels/hotel2.jpg	32
33	hotels/hotel3.jpg	33
34	hotels/hotel4.jpg	34
35	hotels/hotel5.jpg	35
36	hotels/hotel6.jpg	36
37	hotels/hotel7.jpg	37
38	hotels/hotel8.jpg	38
39	hotels/hotel9.jpeg	39
40	hotels/hotel10.webp	40
41	hotels/hotel1.jpg	41
42	hotels/hotel2.jpg	42
43	hotels/hotel3.jpg	43
44	hotels/hotel4.jpg	44
45	hotels/hotel5.jpg	45
46	hotels/hotel6.jpg	46
47	hotels/hotel7.jpg	47
48	hotels/hotel8.jpg	48
49	hotels/hotel9.jpeg	49
50	hotels/hotel10.webp	50
51	hotels/hotel1.jpg	51
52	hotels/hotel2.jpg	52
53	hotels/hotel3.jpg	53
54	hotels/hotel4.jpg	54
55	hotels/hotel5.jpg	55
56	hotels/hotel6.jpg	56
57	hotels/hotel7.jpg	57
58	hotels/hotel8.jpg	58
59	hotels/hotel9.jpeg	59
60	hotels/hotel10.webp	60
61	hotels/hotel1.jpg	61
62	hotels/hotel2.jpg	62
63	hotels/hotel3.jpg	63
64	hotels/hotel4.jpg	64
65	hotels/hotel5.jpg	65
66	hotels/hotel6.jpg	66
67	hotels/hotel7.jpg	67
68	hotels/hotel8.jpg	68
69	hotels/hotel9.jpeg	69
70	hotels/hotel10.webp	70
71	hotels/hotel1.jpg	71
72	hotels/hotel2.jpg	72
73	hotels/hotel3.jpg	73
74	hotels/hotel4.jpg	74
\.


--
-- Data for Name: hotels_review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_review (id, rating, comment, created_at, hotel_id, user_id) FROM stdin;
\.


--
-- Data for Name: hotels_room; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hotels_room (id, room_number, room_type, capacity, price_per_night, is_active, hotel_id) FROM stdin;
1	1-1	STANDARD	2	1749.00	t	1
2	1-2	DELUXE	2	2499.00	t	1
3	1-3	SUITE	3	2873.00	t	1
4	1-4	STANDARD	4	3373.00	t	1
5	1-5	DELUXE	4	3748.00	t	1
6	3-1	STANDARD	2	3849.00	t	3
7	3-2	DELUXE	2	5499.00	t	3
8	3-3	SUITE	3	6323.00	t	3
9	3-4	STANDARD	4	7423.00	t	3
10	3-5	DELUXE	4	8248.00	t	3
11	4-1	STANDARD	2	2449.00	t	4
12	4-2	DELUXE	2	3499.00	t	4
13	4-3	SUITE	3	4023.00	t	4
14	4-4	STANDARD	4	4723.00	t	4
15	4-5	DELUXE	4	5248.00	t	4
16	5-1	STANDARD	2	3219.00	t	5
17	5-2	DELUXE	2	4599.00	t	5
18	5-3	SUITE	3	5288.00	t	5
19	5-4	STANDARD	4	6208.00	t	5
20	5-5	DELUXE	4	6898.00	t	5
21	6-1	STANDARD	2	1959.00	t	6
22	6-2	DELUXE	2	2799.00	t	6
23	6-3	SUITE	3	3218.00	t	6
24	6-4	STANDARD	4	3778.00	t	6
25	6-5	DELUXE	4	4198.00	t	6
26	7-1	STANDARD	2	2099.00	t	7
27	7-2	DELUXE	2	2999.00	t	7
28	7-3	SUITE	3	3448.00	t	7
29	7-4	STANDARD	4	4048.00	t	7
30	7-5	DELUXE	4	4498.00	t	7
31	8-1	STANDARD	2	2939.00	t	8
32	8-2	DELUXE	2	4199.00	t	8
33	8-3	SUITE	3	4828.00	t	8
34	8-4	STANDARD	4	5668.00	t	8
35	8-5	DELUXE	4	6298.00	t	8
36	9-1	STANDARD	2	3849.00	t	9
37	9-2	DELUXE	2	5499.00	t	9
38	9-3	SUITE	3	6323.00	t	9
39	9-4	STANDARD	4	7423.00	t	9
40	9-5	DELUXE	4	8248.00	t	9
41	10-1	STANDARD	2	4549.00	t	10
42	10-2	DELUXE	2	6499.00	t	10
43	10-3	SUITE	3	7473.00	t	10
44	10-4	STANDARD	4	8773.00	t	10
45	10-5	DELUXE	4	9748.00	t	10
46	11-1	STANDARD	2	3709.00	t	11
47	11-2	DELUXE	2	5299.00	t	11
48	11-3	SUITE	3	6093.00	t	11
49	11-4	STANDARD	4	7153.00	t	11
50	11-5	DELUXE	4	7948.00	t	11
51	12-1	STANDARD	2	3079.00	t	12
52	12-2	DELUXE	2	4399.00	t	12
53	12-3	SUITE	3	5058.00	t	12
54	12-4	STANDARD	4	5938.00	t	12
55	12-5	DELUXE	4	6598.00	t	12
56	13-1	STANDARD	2	2309.00	t	13
57	13-2	DELUXE	2	3299.00	t	13
58	13-3	SUITE	3	3793.00	t	13
59	13-4	STANDARD	4	4453.00	t	13
60	13-5	DELUXE	4	4948.00	t	13
61	14-1	STANDARD	2	3499.00	t	14
62	14-2	DELUXE	2	4999.00	t	14
63	14-3	SUITE	3	5748.00	t	14
64	14-4	STANDARD	4	6748.00	t	14
65	14-5	DELUXE	4	7498.00	t	14
66	15-1	STANDARD	2	4059.00	t	15
67	15-2	DELUXE	2	5799.00	t	15
68	15-3	SUITE	3	6668.00	t	15
69	15-4	STANDARD	4	7828.00	t	15
70	15-5	DELUXE	4	8698.00	t	15
71	16-1	STANDARD	2	1539.00	t	16
72	16-2	DELUXE	2	2199.00	t	16
73	16-3	SUITE	3	2528.00	t	16
74	16-4	STANDARD	4	2968.00	t	16
75	16-5	DELUXE	4	3298.00	t	16
76	17-1	STANDARD	2	2729.00	t	17
77	17-2	DELUXE	2	3899.00	t	17
78	17-3	SUITE	3	4483.00	t	17
79	17-4	STANDARD	4	5263.00	t	17
80	17-5	DELUXE	4	5848.00	t	17
81	18-1	STANDARD	2	3639.00	t	18
82	18-2	DELUXE	2	5199.00	t	18
83	18-3	SUITE	3	5978.00	t	18
84	18-4	STANDARD	4	7018.00	t	18
85	18-5	DELUXE	4	7798.00	t	18
86	19-1	STANDARD	2	2449.00	t	19
87	19-2	DELUXE	2	3499.00	t	19
88	19-3	SUITE	3	4023.00	t	19
89	19-4	STANDARD	4	4723.00	t	19
90	19-5	DELUXE	4	5248.00	t	19
91	20-1	STANDARD	2	3289.00	t	20
92	20-2	DELUXE	2	4699.00	t	20
93	20-3	SUITE	3	5403.00	t	20
94	20-4	STANDARD	4	6343.00	t	20
95	20-5	DELUXE	4	7048.00	t	20
96	21-1	STANDARD	2	1399.00	t	21
97	21-2	DELUXE	2	1999.00	t	21
98	21-3	SUITE	3	2298.00	t	21
99	21-4	STANDARD	4	2698.00	t	21
100	21-5	DELUXE	4	2998.00	t	21
101	22-1	STANDARD	2	2519.00	t	22
102	22-2	DELUXE	2	3599.00	t	22
103	22-3	SUITE	3	4138.00	t	22
104	22-4	STANDARD	4	4858.00	t	22
105	22-5	DELUXE	4	5398.00	t	22
106	23-1	STANDARD	2	2309.00	t	23
107	23-2	DELUXE	2	3299.00	t	23
108	23-3	SUITE	3	3793.00	t	23
109	23-4	STANDARD	4	4453.00	t	23
110	23-5	DELUXE	4	4948.00	t	23
111	24-1	STANDARD	2	3499.00	t	24
112	24-2	DELUXE	2	4999.00	t	24
113	24-3	SUITE	3	5748.00	t	24
114	24-4	STANDARD	4	6748.00	t	24
115	24-5	DELUXE	4	7498.00	t	24
116	25-1	STANDARD	2	2239.00	t	25
117	25-2	DELUXE	2	3199.00	t	25
118	25-3	SUITE	3	3678.00	t	25
119	25-4	STANDARD	4	4318.00	t	25
120	25-5	DELUXE	4	4798.00	t	25
121	26-1	STANDARD	2	2029.00	t	26
122	26-2	DELUXE	2	2899.00	t	26
123	26-3	SUITE	3	3333.00	t	26
124	26-4	STANDARD	4	3913.00	t	26
125	26-5	DELUXE	4	4348.00	t	26
126	27-1	STANDARD	2	3009.00	t	27
127	27-2	DELUXE	2	4299.00	t	27
128	27-3	SUITE	3	4943.00	t	27
129	27-4	STANDARD	4	5803.00	t	27
130	27-5	DELUXE	4	6448.00	t	27
131	28-1	STANDARD	2	3359.00	t	28
132	28-2	DELUXE	2	4799.00	t	28
133	28-3	SUITE	3	5518.00	t	28
134	28-4	STANDARD	4	6478.00	t	28
135	28-5	DELUXE	4	7198.00	t	28
136	29-1	STANDARD	2	2099.00	t	29
137	29-2	DELUXE	2	2999.00	t	29
138	29-3	SUITE	3	3448.00	t	29
139	29-4	STANDARD	4	4048.00	t	29
140	29-5	DELUXE	4	4498.00	t	29
141	30-1	STANDARD	2	2239.00	t	30
142	30-2	DELUXE	2	3199.00	t	30
143	30-3	SUITE	3	3678.00	t	30
144	30-4	STANDARD	4	4318.00	t	30
145	30-5	DELUXE	4	4798.00	t	30
146	31-1	STANDARD	2	3919.00	t	31
147	31-2	DELUXE	2	5599.00	t	31
148	31-3	SUITE	3	6438.00	t	31
149	31-4	STANDARD	4	7558.00	t	31
150	31-5	DELUXE	4	8398.00	t	31
151	32-1	STANDARD	2	3149.00	t	32
152	32-2	DELUXE	2	4499.00	t	32
153	32-3	SUITE	3	5173.00	t	32
154	32-4	STANDARD	4	6073.00	t	32
155	32-5	DELUXE	4	6748.00	t	32
156	33-1	STANDARD	2	2939.00	t	33
157	33-2	DELUXE	2	4199.00	t	33
158	33-3	SUITE	3	4828.00	t	33
159	33-4	STANDARD	4	5668.00	t	33
160	33-5	DELUXE	4	6298.00	t	33
161	34-1	STANDARD	2	1959.00	t	34
162	34-2	DELUXE	2	2799.00	t	34
163	34-3	SUITE	3	3218.00	t	34
164	34-4	STANDARD	4	3778.00	t	34
165	34-5	DELUXE	4	4198.00	t	34
166	35-1	STANDARD	2	2029.00	t	35
167	35-2	DELUXE	2	2899.00	t	35
168	35-3	SUITE	3	3333.00	t	35
169	35-4	STANDARD	4	3913.00	t	35
170	35-5	DELUXE	4	4348.00	t	35
171	36-1	STANDARD	2	1539.00	t	36
172	36-2	DELUXE	2	2199.00	t	36
173	36-3	SUITE	3	2528.00	t	36
174	36-4	STANDARD	4	2968.00	t	36
175	36-5	DELUXE	4	3298.00	t	36
176	37-1	STANDARD	2	2309.00	t	37
177	37-2	DELUXE	2	3299.00	t	37
178	37-3	SUITE	3	3793.00	t	37
179	37-4	STANDARD	4	4453.00	t	37
180	37-5	DELUXE	4	4948.00	t	37
181	39-1	STANDARD	2	2519.00	t	39
182	39-2	DELUXE	2	3599.00	t	39
183	39-3	SUITE	3	4138.00	t	39
184	39-4	STANDARD	4	4858.00	t	39
185	39-5	DELUXE	4	5398.00	t	39
186	40-1	STANDARD	2	2729.00	t	40
187	40-2	DELUXE	2	3899.00	t	40
188	40-3	SUITE	3	4483.00	t	40
189	40-4	STANDARD	4	5263.00	t	40
190	40-5	DELUXE	4	5848.00	t	40
191	41-1	STANDARD	2	4059.00	t	41
192	41-2	DELUXE	2	5799.00	t	41
193	41-3	SUITE	3	6668.00	t	41
194	41-4	STANDARD	4	7828.00	t	41
195	41-5	DELUXE	4	8698.00	t	41
196	42-1	STANDARD	2	2379.00	t	42
197	42-2	DELUXE	2	3399.00	t	42
198	42-3	SUITE	3	3908.00	t	42
199	42-4	STANDARD	4	4588.00	t	42
200	42-5	DELUXE	4	5098.00	t	42
201	43-1	STANDARD	2	4339.00	t	43
202	43-2	DELUXE	2	6199.00	t	43
203	43-3	SUITE	3	7128.00	t	43
204	43-4	STANDARD	4	8368.00	t	43
205	43-5	DELUXE	4	9298.00	t	43
206	44-1	STANDARD	2	2939.00	t	44
207	44-2	DELUXE	2	4199.00	t	44
208	44-3	SUITE	3	4828.00	t	44
209	44-4	STANDARD	4	5668.00	t	44
210	44-5	DELUXE	4	6298.00	t	44
211	45-1	STANDARD	2	2029.00	t	45
212	45-2	DELUXE	2	2899.00	t	45
213	45-3	SUITE	3	3333.00	t	45
214	45-4	STANDARD	4	3913.00	t	45
215	45-5	DELUXE	4	4348.00	t	45
216	46-1	STANDARD	2	3709.00	t	46
217	46-2	DELUXE	2	5299.00	t	46
218	46-3	SUITE	3	6093.00	t	46
219	46-4	STANDARD	4	7153.00	t	46
220	46-5	DELUXE	4	7948.00	t	46
221	47-1	STANDARD	2	2239.00	t	47
222	47-2	DELUXE	2	3199.00	t	47
223	47-3	SUITE	3	3678.00	t	47
224	47-4	STANDARD	4	4318.00	t	47
225	47-5	DELUXE	4	4798.00	t	47
226	48-1	STANDARD	2	2659.00	t	48
227	48-2	DELUXE	2	3799.00	t	48
228	48-3	SUITE	3	4368.00	t	48
229	48-4	STANDARD	4	5128.00	t	48
230	48-5	DELUXE	4	5698.00	t	48
231	49-1	STANDARD	2	1609.00	t	49
232	49-2	DELUXE	2	2299.00	t	49
233	49-3	SUITE	3	2643.00	t	49
234	49-4	STANDARD	4	3103.00	t	49
235	49-5	DELUXE	4	3448.00	t	49
236	50-1	STANDARD	2	2309.00	t	50
237	50-2	DELUXE	2	3299.00	t	50
238	50-3	SUITE	3	3793.00	t	50
239	50-4	STANDARD	4	4453.00	t	50
240	50-5	DELUXE	4	4948.00	t	50
241	51-1	STANDARD	2	3149.00	t	51
242	51-2	DELUXE	2	4499.00	t	51
243	51-3	SUITE	3	5173.00	t	51
244	51-4	STANDARD	4	6073.00	t	51
245	51-5	DELUXE	4	6748.00	t	51
246	52-1	STANDARD	2	1399.00	t	52
247	52-2	DELUXE	2	1999.00	t	52
248	52-3	SUITE	3	2298.00	t	52
249	52-4	STANDARD	4	2698.00	t	52
250	52-5	DELUXE	4	2998.00	t	52
251	53-1	STANDARD	2	3709.00	t	53
252	53-2	DELUXE	2	5299.00	t	53
253	53-3	SUITE	3	6093.00	t	53
254	53-4	STANDARD	4	7153.00	t	53
255	53-5	DELUXE	4	7948.00	t	53
256	54-1	STANDARD	2	3219.00	t	54
257	54-2	DELUXE	2	4599.00	t	54
258	54-3	SUITE	3	5288.00	t	54
259	54-4	STANDARD	4	6208.00	t	54
260	54-5	DELUXE	4	6898.00	t	54
261	55-1	STANDARD	2	2099.00	t	55
262	55-2	DELUXE	2	2999.00	t	55
263	55-3	SUITE	3	3448.00	t	55
264	55-4	STANDARD	4	4048.00	t	55
265	55-5	DELUXE	4	4498.00	t	55
266	56-1	STANDARD	2	2239.00	t	56
267	56-2	DELUXE	2	3199.00	t	56
268	56-3	SUITE	3	3678.00	t	56
269	56-4	STANDARD	4	4318.00	t	56
270	56-5	DELUXE	4	4798.00	t	56
271	57-1	STANDARD	2	2449.00	t	57
272	57-2	DELUXE	2	3499.00	t	57
273	57-3	SUITE	3	4023.00	t	57
274	57-4	STANDARD	4	4723.00	t	57
275	57-5	DELUXE	4	5248.00	t	57
276	58-1	STANDARD	2	3499.00	t	58
277	58-2	DELUXE	2	4999.00	t	58
278	58-3	SUITE	3	5748.00	t	58
279	58-4	STANDARD	4	6748.00	t	58
280	58-5	DELUXE	4	7498.00	t	58
281	59-1	STANDARD	2	2099.00	t	59
282	59-2	DELUXE	2	2999.00	t	59
283	59-3	SUITE	3	3448.00	t	59
284	59-4	STANDARD	4	4048.00	t	59
285	59-5	DELUXE	4	4498.00	t	59
286	60-1	STANDARD	2	2309.00	t	60
287	60-2	DELUXE	2	3299.00	t	60
288	60-3	SUITE	3	3793.00	t	60
289	60-4	STANDARD	4	4453.00	t	60
290	60-5	DELUXE	4	4948.00	t	60
291	61-1	STANDARD	2	4059.00	t	61
292	61-2	DELUXE	2	5799.00	t	61
293	61-3	SUITE	3	6668.00	t	61
294	61-4	STANDARD	4	7828.00	t	61
295	61-5	DELUXE	4	8698.00	t	61
296	62-1	STANDARD	2	4409.00	t	62
297	62-2	DELUXE	2	6299.00	t	62
298	62-3	SUITE	3	7243.00	t	62
299	62-4	STANDARD	4	8503.00	t	62
300	62-5	DELUXE	4	9448.00	t	62
301	63-1	STANDARD	2	3009.00	t	63
302	63-2	DELUXE	2	4299.00	t	63
303	63-3	SUITE	3	4943.00	t	63
304	63-4	STANDARD	4	5803.00	t	63
305	63-5	DELUXE	4	6448.00	t	63
306	64-1	STANDARD	2	3219.00	t	64
307	64-2	DELUXE	2	4599.00	t	64
308	64-3	SUITE	3	5288.00	t	64
309	64-4	STANDARD	4	6208.00	t	64
310	64-5	DELUXE	4	6898.00	t	64
311	65-1	STANDARD	2	3149.00	t	65
312	65-2	DELUXE	2	4499.00	t	65
313	65-3	SUITE	3	5173.00	t	65
314	65-4	STANDARD	4	6073.00	t	65
315	65-5	DELUXE	4	6748.00	t	65
316	66-1	STANDARD	2	2519.00	t	66
317	66-2	DELUXE	2	3599.00	t	66
318	66-3	SUITE	3	4138.00	t	66
319	66-4	STANDARD	4	4858.00	t	66
320	66-5	DELUXE	4	5398.00	t	66
321	67-1	STANDARD	2	2309.00	t	67
322	67-2	DELUXE	2	3299.00	t	67
323	67-3	SUITE	3	3793.00	t	67
324	67-4	STANDARD	4	4453.00	t	67
325	67-5	DELUXE	4	4948.00	t	67
326	68-1	STANDARD	2	2939.00	t	68
327	68-2	DELUXE	2	4199.00	t	68
328	68-3	SUITE	3	4828.00	t	68
329	68-4	STANDARD	4	5668.00	t	68
330	68-5	DELUXE	4	6298.00	t	68
331	69-1	STANDARD	2	2099.00	t	69
332	69-2	DELUXE	2	2999.00	t	69
333	69-3	SUITE	3	3448.00	t	69
334	69-4	STANDARD	4	4048.00	t	69
335	69-5	DELUXE	4	4498.00	t	69
336	2-1	STANDARD	2	2239.00	t	2
337	2-2	DELUXE	2	3199.00	t	2
338	2-3	SUITE	3	3678.00	t	2
339	2-4	STANDARD	4	4318.00	t	2
340	2-5	DELUXE	4	4798.00	t	2
341	38-1	STANDARD	2	3359.00	t	38
342	38-2	DELUXE	2	4799.00	t	38
343	38-3	SUITE	3	5518.00	t	38
344	38-4	STANDARD	4	6478.00	t	38
345	38-5	DELUXE	4	7198.00	t	38
346	70-1	STANDARD	2	1959.00	t	70
347	70-2	DELUXE	2	2799.00	t	70
348	70-3	SUITE	3	3218.00	t	70
349	70-4	STANDARD	4	3778.00	t	70
350	70-5	DELUXE	4	4198.00	t	70
351	71-1	STANDARD	2	3919.00	t	71
352	71-2	DELUXE	2	5599.00	t	71
353	71-3	SUITE	3	6438.00	t	71
354	71-4	STANDARD	4	7558.00	t	71
355	71-5	DELUXE	4	8398.00	t	71
356	72-1	STANDARD	2	2099.00	t	72
357	72-2	DELUXE	2	2999.00	t	72
358	72-3	SUITE	3	3448.00	t	72
359	72-4	STANDARD	4	4048.00	t	72
360	72-5	DELUXE	4	4498.00	t	72
361	73-1	STANDARD	2	2729.00	t	73
362	73-2	DELUXE	2	3899.00	t	73
363	73-3	SUITE	3	4483.00	t	73
364	73-4	STANDARD	4	5263.00	t	73
365	73-5	DELUXE	4	5848.00	t	73
366	74-1	STANDARD	2	2309.00	t	74
367	74-2	DELUXE	2	3299.00	t	74
368	74-3	SUITE	3	3793.00	t	74
369	74-4	STANDARD	4	4453.00	t	74
370	74-5	DELUXE	4	4948.00	t	74
\.


--
-- Data for Name: users_customerprofile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_customerprofile (id, phone_number, is_verified, profile_picture, user_id) FROM stdin;
1	9569808325	f		2
2	auto-4	f		4
\.


--
-- Data for Name: vendors_vendorprofile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vendors_vendorprofile (id, business_name, phone_number, is_verified, profile_picture, user_id) FROM stdin;
1	Hotel	9415262474	f		3
2	StayGrid Hospitality	9999999999	f		5
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 56, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 5, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 14, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 23, true);


--
-- Name: hotels_amenity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_amenity_id_seq', 1, false);


--
-- Name: hotels_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_booking_id_seq', 3, true);


--
-- Name: hotels_hotel_amenities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_hotel_amenities_id_seq', 1, false);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 74, true);


--
-- Name: hotels_hotelimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_hotelimage_id_seq', 74, true);


--
-- Name: hotels_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_review_id_seq', 1, false);


--
-- Name: hotels_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_room_id_seq', 370, true);


--
-- Name: users_customerprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_customerprofile_id_seq', 2, true);


--
-- Name: vendors_vendorprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vendors_vendorprofile_id_seq', 2, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: hotels_amenity hotels_amenity_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_amenity
    ADD CONSTRAINT hotels_amenity_name_key UNIQUE (name);


--
-- Name: hotels_amenity hotels_amenity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_amenity
    ADD CONSTRAINT hotels_amenity_pkey PRIMARY KEY (id);


--
-- Name: hotels_booking hotels_booking_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_booking
    ADD CONSTRAINT hotels_booking_pkey PRIMARY KEY (id);


--
-- Name: hotels_hotel_amenities hotels_hotel_amenities_hotel_id_amenity_id_11a02791_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel_amenities
    ADD CONSTRAINT hotels_hotel_amenities_hotel_id_amenity_id_11a02791_uniq UNIQUE (hotel_id, amenity_id);


--
-- Name: hotels_hotel_amenities hotels_hotel_amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel_amenities
    ADD CONSTRAINT hotels_hotel_amenities_pkey PRIMARY KEY (id);


--
-- Name: hotels_hotel hotels_hotel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel
    ADD CONSTRAINT hotels_hotel_pkey PRIMARY KEY (id);


--
-- Name: hotels_hotelimage hotels_hotelimage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotelimage
    ADD CONSTRAINT hotels_hotelimage_pkey PRIMARY KEY (id);


--
-- Name: hotels_review hotels_review_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_review
    ADD CONSTRAINT hotels_review_pkey PRIMARY KEY (id);


--
-- Name: hotels_room hotels_room_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_room
    ADD CONSTRAINT hotels_room_pkey PRIMARY KEY (id);


--
-- Name: hotels_review one_review_per_user_per_hotel; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_review
    ADD CONSTRAINT one_review_per_user_per_hotel UNIQUE (user_id, hotel_id);


--
-- Name: hotels_room unique_room_number_per_hotel; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_room
    ADD CONSTRAINT unique_room_number_per_hotel UNIQUE (hotel_id, room_number);


--
-- Name: users_customerprofile users_customerprofile_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_customerprofile
    ADD CONSTRAINT users_customerprofile_phone_number_key UNIQUE (phone_number);


--
-- Name: users_customerprofile users_customerprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_customerprofile
    ADD CONSTRAINT users_customerprofile_pkey PRIMARY KEY (id);


--
-- Name: users_customerprofile users_customerprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_customerprofile
    ADD CONSTRAINT users_customerprofile_user_id_key UNIQUE (user_id);


--
-- Name: vendors_vendorprofile vendors_vendorprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors_vendorprofile
    ADD CONSTRAINT vendors_vendorprofile_pkey PRIMARY KEY (id);


--
-- Name: vendors_vendorprofile vendors_vendorprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors_vendorprofile
    ADD CONSTRAINT vendors_vendorprofile_user_id_key UNIQUE (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: hotels_amenity_name_adf4f6a4_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_amenity_name_adf4f6a4_like ON public.hotels_amenity USING btree (name varchar_pattern_ops);


--
-- Name: hotels_booking_room_id_a36c4fd7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_booking_room_id_a36c4fd7 ON public.hotels_booking USING btree (room_id);


--
-- Name: hotels_booking_user_id_91e9bb9d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_booking_user_id_91e9bb9d ON public.hotels_booking USING btree (user_id);


--
-- Name: hotels_hotel_amenities_amenity_id_bf0b2c3e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_hotel_amenities_amenity_id_bf0b2c3e ON public.hotels_hotel_amenities USING btree (amenity_id);


--
-- Name: hotels_hotel_amenities_hotel_id_fcca9371; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_hotel_amenities_hotel_id_fcca9371 ON public.hotels_hotel_amenities USING btree (hotel_id);


--
-- Name: hotels_hotel_owner_id_dae0ba86; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_hotel_owner_id_dae0ba86 ON public.hotels_hotel USING btree (owner_id);


--
-- Name: hotels_hotelimage_hotel_id_ff6c0c35; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_hotelimage_hotel_id_ff6c0c35 ON public.hotels_hotelimage USING btree (hotel_id);


--
-- Name: hotels_review_hotel_id_96e56aaa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_review_hotel_id_96e56aaa ON public.hotels_review USING btree (hotel_id);


--
-- Name: hotels_review_user_id_ebd052ef; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_review_user_id_ebd052ef ON public.hotels_review USING btree (user_id);


--
-- Name: hotels_room_hotel_id_0ee74c95; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hotels_room_hotel_id_0ee74c95 ON public.hotels_room USING btree (hotel_id);


--
-- Name: users_customerprofile_phone_number_912ceb26_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_customerprofile_phone_number_912ceb26_like ON public.users_customerprofile USING btree (phone_number varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_booking hotels_booking_room_id_a36c4fd7_fk_hotels_room_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_booking
    ADD CONSTRAINT hotels_booking_room_id_a36c4fd7_fk_hotels_room_id FOREIGN KEY (room_id) REFERENCES public.hotels_room(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_booking hotels_booking_user_id_91e9bb9d_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_booking
    ADD CONSTRAINT hotels_booking_user_id_91e9bb9d_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_hotel_amenities hotels_hotel_amenities_amenity_id_bf0b2c3e_fk_hotels_amenity_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel_amenities
    ADD CONSTRAINT hotels_hotel_amenities_amenity_id_bf0b2c3e_fk_hotels_amenity_id FOREIGN KEY (amenity_id) REFERENCES public.hotels_amenity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_hotel_amenities hotels_hotel_amenities_hotel_id_fcca9371_fk_hotels_hotel_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel_amenities
    ADD CONSTRAINT hotels_hotel_amenities_hotel_id_fcca9371_fk_hotels_hotel_id FOREIGN KEY (hotel_id) REFERENCES public.hotels_hotel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_hotel hotels_hotel_owner_id_dae0ba86_fk_vendors_vendorprofile_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotel
    ADD CONSTRAINT hotels_hotel_owner_id_dae0ba86_fk_vendors_vendorprofile_id FOREIGN KEY (owner_id) REFERENCES public.vendors_vendorprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_hotelimage hotels_hotelimage_hotel_id_ff6c0c35_fk_hotels_hotel_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_hotelimage
    ADD CONSTRAINT hotels_hotelimage_hotel_id_ff6c0c35_fk_hotels_hotel_id FOREIGN KEY (hotel_id) REFERENCES public.hotels_hotel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_review hotels_review_hotel_id_96e56aaa_fk_hotels_hotel_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_review
    ADD CONSTRAINT hotels_review_hotel_id_96e56aaa_fk_hotels_hotel_id FOREIGN KEY (hotel_id) REFERENCES public.hotels_hotel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_review hotels_review_user_id_ebd052ef_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_review
    ADD CONSTRAINT hotels_review_user_id_ebd052ef_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: hotels_room hotels_room_hotel_id_0ee74c95_fk_hotels_hotel_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels_room
    ADD CONSTRAINT hotels_room_hotel_id_0ee74c95_fk_hotels_hotel_id FOREIGN KEY (hotel_id) REFERENCES public.hotels_hotel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: users_customerprofile users_customerprofile_user_id_c320f1e5_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_customerprofile
    ADD CONSTRAINT users_customerprofile_user_id_c320f1e5_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vendors_vendorprofile vendors_vendorprofile_user_id_3929a54a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors_vendorprofile
    ADD CONSTRAINT vendors_vendorprofile_user_id_3929a54a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict OLhsZlQQyJvfNbBBYXcmV2ebSdokAws3UfCdZByYX5NewYvdkv1Byv28De5TwMG

