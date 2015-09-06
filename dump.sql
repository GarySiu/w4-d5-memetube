--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: videos; Type: TABLE; Schema: public; Owner: Gary; Tablespace: 
--

CREATE TABLE videos (
    id bigint NOT NULL,
    title character varying(140),
    video_id character varying(15),
    description character varying(500),
    genre character varying(30),
    views integer
);


ALTER TABLE videos OWNER TO "Gary";

--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: Gary
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE videos_id_seq OWNER TO "Gary";

--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Gary
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: Gary
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: Gary
--

COPY videos (id, title, video_id, description, genre, views) FROM stdin;
1	Civ 5 - Hey Ash Whatcha Plain'?	aLcHJN1soY4	Ash makes a penetrating power play for World Leader in Civ 5.	comedy	1
2	How To Delete Facebook Messenger	7rhK38fzWi0	Today I show you how to delete the Facebook Messenger App. Recently Facebook has been encouraging everyone to install Facebook Messenger on their Smartphones. It even got to the stage where you had no choice but to install the App. Not everyone agreed with this; some people strongly dislike the App, so I decided to see if there was a way to permanently delete the Facebook Messenger App from your phone. Within minutes I discovered this incredibly easy method. You're welcome!	comedy	1
\.


--
-- Name: videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Gary
--

SELECT pg_catalog.setval('videos_id_seq', 2, true);


--
-- Name: public; Type: ACL; Schema: -; Owner: Gary
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM "Gary";
GRANT ALL ON SCHEMA public TO "Gary";
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

