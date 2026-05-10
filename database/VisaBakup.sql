--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2026-05-09 11:42:40

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 18300)
-- Name: carte_resident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carte_resident (
    id integer NOT NULL,
    demande_id integer NOT NULL,
    passeport_id integer NOT NULL,
    reference character varying(50),
    date_debut date NOT NULL,
    date_fin date NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.carte_resident OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 18299)
-- Name: carte_resident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carte_resident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carte_resident_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 247
-- Name: carte_resident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carte_resident_id_seq OWNED BY public.carte_resident.id;


--
-- TOC entry 250 (class 1259 OID 18320)
-- Name: catalogue_piece_commune; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.catalogue_piece_commune (
    id integer NOT NULL,
    code character varying(80) NOT NULL,
    libelle text NOT NULL
);


ALTER TABLE public.catalogue_piece_commune OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 18319)
-- Name: catalogue_piece_commune_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.catalogue_piece_commune_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.catalogue_piece_commune_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 249
-- Name: catalogue_piece_commune_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.catalogue_piece_commune_id_seq OWNED BY public.catalogue_piece_commune.id;


--
-- TOC entry 254 (class 1259 OID 18357)
-- Name: catalogue_piece_complementaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.catalogue_piece_complementaire (
    id integer NOT NULL,
    type_visa_id integer NOT NULL,
    code character varying(80) NOT NULL,
    libelle text NOT NULL,
    est_obligatoire boolean DEFAULT true NOT NULL
);


ALTER TABLE public.catalogue_piece_complementaire OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 18356)
-- Name: catalogue_piece_complementaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.catalogue_piece_complementaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.catalogue_piece_complementaire_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 253
-- Name: catalogue_piece_complementaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.catalogue_piece_complementaire_id_seq OWNED BY public.catalogue_piece_complementaire.id;


--
-- TOC entry 242 (class 1259 OID 18225)
-- Name: demande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demande (
    id integer NOT NULL,
    demandeur_id integer NOT NULL,
    visa_transformable_id integer,
    type_visa_id integer NOT NULL,
    type_demande_id integer NOT NULL,
    statut_demande_id integer NOT NULL,
    date_demande date DEFAULT CURRENT_DATE NOT NULL,
    date_traitement date,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.demande OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 18224)
-- Name: demande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.demande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demande_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 241
-- Name: demande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.demande_id_seq OWNED BY public.demande.id;


--
-- TOC entry 252 (class 1259 OID 18331)
-- Name: demande_piece_commune; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demande_piece_commune (
    id integer NOT NULL,
    demande_id integer NOT NULL,
    catalogue_piece_id integer NOT NULL,
    statut_piece_id integer NOT NULL,
    fichier_path character varying(500),
    date_fourniture timestamp without time zone
);


ALTER TABLE public.demande_piece_commune OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 18330)
-- Name: demande_piece_commune_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.demande_piece_commune_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demande_piece_commune_id_seq OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 251
-- Name: demande_piece_commune_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.demande_piece_commune_id_seq OWNED BY public.demande_piece_commune.id;


--
-- TOC entry 256 (class 1259 OID 18374)
-- Name: demande_piece_complementaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demande_piece_complementaire (
    id integer NOT NULL,
    demande_id integer NOT NULL,
    catalogue_complementaire_id integer NOT NULL,
    statut_piece_id integer NOT NULL,
    fichier_path character varying(500),
    date_fourniture timestamp without time zone
);


ALTER TABLE public.demande_piece_complementaire OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 18373)
-- Name: demande_piece_complementaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.demande_piece_complementaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demande_piece_complementaire_id_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 255
-- Name: demande_piece_complementaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.demande_piece_complementaire_id_seq OWNED BY public.demande_piece_complementaire.id;


--
-- TOC entry 244 (class 1259 OID 18260)
-- Name: demande_statut_historique; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demande_statut_historique (
    id integer NOT NULL,
    demande_id integer NOT NULL,
    statut_demande_id integer NOT NULL,
    date_changement_statut timestamp without time zone DEFAULT now() NOT NULL,
    commentaire text,
    changed_by character varying(100)
);


ALTER TABLE public.demande_statut_historique OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 18259)
-- Name: demande_statut_historique_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.demande_statut_historique_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demande_statut_historique_id_seq OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 243
-- Name: demande_statut_historique_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.demande_statut_historique_id_seq OWNED BY public.demande_statut_historique.id;


--
-- TOC entry 232 (class 1259 OID 18129)
-- Name: demandeur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demandeur (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    date_naissance date NOT NULL,
    lieu_naissance character varying(150) NOT NULL,
    telephone character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    adresse text NOT NULL,
    nationalite_id integer NOT NULL,
    situation_familiale_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.demandeur OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 18128)
-- Name: demandeur_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.demandeur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demandeur_id_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 231
-- Name: demandeur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.demandeur_id_seq OWNED BY public.demandeur.id;


--
-- TOC entry 218 (class 1259 OID 18066)
-- Name: nationalite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nationalite (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    libelle character varying(100) NOT NULL
);


ALTER TABLE public.nationalite OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 18065)
-- Name: nationalite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nationalite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nationalite_id_seq OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 217
-- Name: nationalite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nationalite_id_seq OWNED BY public.nationalite.id;


--
-- TOC entry 234 (class 1259 OID 18149)
-- Name: passeport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passeport (
    id integer NOT NULL,
    demandeur_id integer NOT NULL,
    numero_passeport character varying(50) NOT NULL,
    pays_delivrance_id integer NOT NULL,
    date_delivrance date NOT NULL,
    date_expiration date NOT NULL
);


ALTER TABLE public.passeport OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 18148)
-- Name: passeport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passeport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passeport_id_seq OWNER TO postgres;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 233
-- Name: passeport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passeport_id_seq OWNED BY public.passeport.id;


--
-- TOC entry 236 (class 1259 OID 18168)
-- Name: passeport_statut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passeport_statut (
    id integer NOT NULL,
    passeport_id integer NOT NULL,
    statut_passeport_id integer NOT NULL,
    date_changement_statut timestamp without time zone DEFAULT now() NOT NULL,
    commentaire text
);


ALTER TABLE public.passeport_statut OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 18167)
-- Name: passeport_statut_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passeport_statut_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passeport_statut_id_seq OWNER TO postgres;

--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 235
-- Name: passeport_statut_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passeport_statut_id_seq OWNED BY public.passeport_statut.id;


--
-- TOC entry 220 (class 1259 OID 18075)
-- Name: situation_familiale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.situation_familiale (
    id integer NOT NULL,
    libelle character varying(100) NOT NULL
);


ALTER TABLE public.situation_familiale OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18074)
-- Name: situation_familiale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.situation_familiale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.situation_familiale_id_seq OWNER TO postgres;

--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 219
-- Name: situation_familiale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.situation_familiale_id_seq OWNED BY public.situation_familiale.id;


--
-- TOC entry 228 (class 1259 OID 18111)
-- Name: statut_demande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statut_demande (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    libelle character varying(80) NOT NULL
);


ALTER TABLE public.statut_demande OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 18110)
-- Name: statut_demande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statut_demande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statut_demande_id_seq OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 227
-- Name: statut_demande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statut_demande_id_seq OWNED BY public.statut_demande.id;


--
-- TOC entry 226 (class 1259 OID 18102)
-- Name: statut_passeport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statut_passeport (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    libelle character varying(80) NOT NULL
);


ALTER TABLE public.statut_passeport OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18101)
-- Name: statut_passeport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statut_passeport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statut_passeport_id_seq OWNER TO postgres;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 225
-- Name: statut_passeport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statut_passeport_id_seq OWNED BY public.statut_passeport.id;


--
-- TOC entry 230 (class 1259 OID 18120)
-- Name: statut_piece; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statut_piece (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    libelle character varying(80) NOT NULL
);


ALTER TABLE public.statut_piece OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 18119)
-- Name: statut_piece_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statut_piece_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statut_piece_id_seq OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 229
-- Name: statut_piece_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statut_piece_id_seq OWNED BY public.statut_piece.id;


--
-- TOC entry 238 (class 1259 OID 18188)
-- Name: transfert_passeport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfert_passeport (
    id integer NOT NULL,
    ancien_passeport_id integer,
    nouveau_passeport_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transfert_passeport OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 18187)
-- Name: transfert_passeport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfert_passeport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transfert_passeport_id_seq OWNER TO postgres;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 237
-- Name: transfert_passeport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfert_passeport_id_seq OWNED BY public.transfert_passeport.id;


--
-- TOC entry 224 (class 1259 OID 18093)
-- Name: type_demande; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_demande (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    libelle character varying(100) NOT NULL
);


ALTER TABLE public.type_demande OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 18092)
-- Name: type_demande_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_demande_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_demande_id_seq OWNER TO postgres;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 223
-- Name: type_demande_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_demande_id_seq OWNED BY public.type_demande.id;


--
-- TOC entry 222 (class 1259 OID 18084)
-- Name: type_visa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_visa (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    libelle character varying(100) NOT NULL
);


ALTER TABLE public.type_visa OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 18083)
-- Name: type_visa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_visa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_visa_id_seq OWNER TO postgres;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_visa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_visa_id_seq OWNED BY public.type_visa.id;


--
-- TOC entry 246 (class 1259 OID 18280)
-- Name: visa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visa (
    id integer NOT NULL,
    demande_id integer NOT NULL,
    passeport_id integer NOT NULL,
    reference character varying(50),
    date_debut date NOT NULL,
    date_fin date NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.visa OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 18279)
-- Name: visa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visa_id_seq OWNER TO postgres;

--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 245
-- Name: visa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visa_id_seq OWNED BY public.visa.id;


--
-- TOC entry 240 (class 1259 OID 18206)
-- Name: visa_transformable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visa_transformable (
    id integer NOT NULL,
    demandeur_id integer NOT NULL,
    passeport_id integer NOT NULL,
    numero_reference character varying(50),
    lieu_entree character varying(150) NOT NULL,
    date_entree date NOT NULL,
    date_sortie_ref date,
    date_expiration date NOT NULL
);


ALTER TABLE public.visa_transformable OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 18205)
-- Name: visa_transformable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visa_transformable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visa_transformable_id_seq OWNER TO postgres;

--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 239
-- Name: visa_transformable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visa_transformable_id_seq OWNED BY public.visa_transformable.id;


--
-- TOC entry 4813 (class 2604 OID 18303)
-- Name: carte_resident id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carte_resident ALTER COLUMN id SET DEFAULT nextval('public.carte_resident_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 18323)
-- Name: catalogue_piece_commune id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_commune ALTER COLUMN id SET DEFAULT nextval('public.catalogue_piece_commune_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 18360)
-- Name: catalogue_piece_complementaire id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_complementaire ALTER COLUMN id SET DEFAULT nextval('public.catalogue_piece_complementaire_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 18228)
-- Name: demande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande ALTER COLUMN id SET DEFAULT nextval('public.demande_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 18334)
-- Name: demande_piece_commune id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune ALTER COLUMN id SET DEFAULT nextval('public.demande_piece_commune_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 18377)
-- Name: demande_piece_complementaire id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire ALTER COLUMN id SET DEFAULT nextval('public.demande_piece_complementaire_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 18263)
-- Name: demande_statut_historique id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_statut_historique ALTER COLUMN id SET DEFAULT nextval('public.demande_statut_historique_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 18132)
-- Name: demandeur id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demandeur ALTER COLUMN id SET DEFAULT nextval('public.demandeur_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 18069)
-- Name: nationalite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nationalite ALTER COLUMN id SET DEFAULT nextval('public.nationalite_id_seq'::regclass);


--
-- TOC entry 4799 (class 2604 OID 18152)
-- Name: passeport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport ALTER COLUMN id SET DEFAULT nextval('public.passeport_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 18171)
-- Name: passeport_statut id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport_statut ALTER COLUMN id SET DEFAULT nextval('public.passeport_statut_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 18078)
-- Name: situation_familiale id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situation_familiale ALTER COLUMN id SET DEFAULT nextval('public.situation_familiale_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 18114)
-- Name: statut_demande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_demande ALTER COLUMN id SET DEFAULT nextval('public.statut_demande_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 18105)
-- Name: statut_passeport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_passeport ALTER COLUMN id SET DEFAULT nextval('public.statut_passeport_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 18123)
-- Name: statut_piece id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_piece ALTER COLUMN id SET DEFAULT nextval('public.statut_piece_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 18191)
-- Name: transfert_passeport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfert_passeport ALTER COLUMN id SET DEFAULT nextval('public.transfert_passeport_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 18096)
-- Name: type_demande id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_demande ALTER COLUMN id SET DEFAULT nextval('public.type_demande_id_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 18087)
-- Name: type_visa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_visa ALTER COLUMN id SET DEFAULT nextval('public.type_visa_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 18283)
-- Name: visa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa ALTER COLUMN id SET DEFAULT nextval('public.visa_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 18209)
-- Name: visa_transformable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa_transformable ALTER COLUMN id SET DEFAULT nextval('public.visa_transformable_id_seq'::regclass);


--
-- TOC entry 5094 (class 0 OID 18300)
-- Dependencies: 248
-- Data for Name: carte_resident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carte_resident (id, demande_id, passeport_id, reference, date_debut, date_fin, created_at) FROM stdin;
1	2	2	REF-CR-DUPLICATA	2024-10-04	2027-10-04	2026-05-06 11:14:00.557081
\.


--
-- TOC entry 5096 (class 0 OID 18320)
-- Dependencies: 250
-- Data for Name: catalogue_piece_commune; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.catalogue_piece_commune (id, code, libelle) FROM stdin;
1	PHOTO_ID	01 photos d'identité récentes
2	NOTICE_RENS	Notice de renseignement
\.


--
-- TOC entry 5100 (class 0 OID 18357)
-- Dependencies: 254
-- Data for Name: catalogue_piece_complementaire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.catalogue_piece_complementaire (id, type_visa_id, code, libelle, est_obligatoire) FROM stdin;
1	1	AUTORISATION_EMPLOI	Autorisation d'emploi délivrée par le Ministère de la Fonction Publique	t
2	1	ATTESTATION_EMPLOI	Attestation d'emploi délivrée par l'employeur (original)	t
3	2	STATUT_SOCIETE	Statut de la Société	t
4	2	EXTRAIT_REGISTRE	Extrait d'inscription au Registre de Commerce	t
5	2	CARTE_FISCALE	Carte fiscale en cours de validité	t
\.


--
-- TOC entry 5088 (class 0 OID 18225)
-- Dependencies: 242
-- Data for Name: demande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demande (id, demandeur_id, visa_transformable_id, type_visa_id, type_demande_id, statut_demande_id, date_demande, date_traitement, created_at, updated_at) FROM stdin;
1	1	1	1	1	2	2026-05-06	\N	2026-05-06 11:02:44.789228	2026-05-06 11:02:44.789228
2	2	\N	1	1	4	2026-05-06	2026-05-06	2026-05-06 11:14:00.557081	2026-05-06 11:14:00.557081
3	2	\N	1	3	3	2026-05-06	\N	2026-05-06 11:14:00.557081	2026-05-06 11:19:43.688685
\.


--
-- TOC entry 5098 (class 0 OID 18331)
-- Dependencies: 252
-- Data for Name: demande_piece_commune; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demande_piece_commune (id, demande_id, catalogue_piece_id, statut_piece_id, fichier_path, date_fourniture) FROM stdin;
1	1	1	1	\N	\N
2	1	2	1	\N	\N
3	3	1	2	2e652b0e-f3e6-496c-8b06-14d38842ef16.png	2026-05-06 11:15:52.673816
4	3	2	2	29cb532b-5807-4429-b964-036643006902.png	2026-05-06 11:16:08.988311
\.


--
-- TOC entry 5102 (class 0 OID 18374)
-- Dependencies: 256
-- Data for Name: demande_piece_complementaire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demande_piece_complementaire (id, demande_id, catalogue_complementaire_id, statut_piece_id, fichier_path, date_fourniture) FROM stdin;
1	1	1	1	\N	\N
2	1	2	1	\N	\N
3	3	1	2	2437336c-4bb4-4da4-9ea5-777298a91903.png	2026-05-06 11:16:13.514233
4	3	2	2	54be8d37-fa27-4a3b-8338-18fcde3394d8.png	2026-05-06 11:16:17.673901
\.


--
-- TOC entry 5090 (class 0 OID 18260)
-- Dependencies: 244
-- Data for Name: demande_statut_historique; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demande_statut_historique (id, demande_id, statut_demande_id, date_changement_statut, commentaire, changed_by) FROM stdin;
1	1	2	2026-05-06 11:02:44.804175	Création de la demande initiale	SYSTEM
2	3	2	2026-05-06 11:14:00.564156	Demande de duplicata créée	SYSTEM
3	3	3	2026-05-06 11:19:43.688685	Le scan des pièces est terminé, dossier prêt pour traitement	SYSTEM
\.


--
-- TOC entry 5078 (class 0 OID 18129)
-- Dependencies: 232
-- Data for Name: demandeur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demandeur (id, nom, prenom, date_naissance, lieu_naissance, telephone, email, adresse, nationalite_id, situation_familiale_id, created_at) FROM stdin;
1	Jean	Charle	1970-05-15	Marseille 	0345555555	jeancharle@gmail.com	Marseille	2	1	2026-05-06 11:00:16.323814
2	SUZUKI	Himari	1967-03-23	Tokyo	0345555555	suzukihimari@gmail.com	Antanarivo Madagascar	4	1	2026-05-06 11:10:09.175611
\.


--
-- TOC entry 5064 (class 0 OID 18066)
-- Dependencies: 218
-- Data for Name: nationalite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nationalite (id, code, libelle) FROM stdin;
1	MG	Malgache
2	FR	Française
3	US	Américaine
4	JP	Japonais
5	CH	Japonais
\.


--
-- TOC entry 5080 (class 0 OID 18149)
-- Dependencies: 234
-- Data for Name: passeport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passeport (id, demandeur_id, numero_passeport, pays_delivrance_id, date_delivrance, date_expiration) FROM stdin;
1	1	XP2050XF	2	1981-03-11	2030-12-12
2	2	NN0573S	4	2021-07-11	2030-07-11
\.


--
-- TOC entry 5082 (class 0 OID 18168)
-- Dependencies: 236
-- Data for Name: passeport_statut; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passeport_statut (id, passeport_id, statut_passeport_id, date_changement_statut, commentaire) FROM stdin;
1	1	1	2026-05-06 11:02:38.758699	Statut initial à la création
2	2	1	2026-05-06 11:11:55.598901	Statut initial à la création
\.


--
-- TOC entry 5066 (class 0 OID 18075)
-- Dependencies: 220
-- Data for Name: situation_familiale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.situation_familiale (id, libelle) FROM stdin;
1	Célibataire
2	Marié(e)
3	Divorcé(e)
4	Veuf / Veuve
5	Union libre
\.


--
-- TOC entry 5074 (class 0 OID 18111)
-- Dependencies: 228
-- Data for Name: statut_demande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statut_demande (id, code, libelle) FROM stdin;
1	BROUILLON	Brouillon
2	CREER	Créer
3	SCAN_TERMINER	Scan terminé
4	APPROUVEE	Approuvée
5	REJETEE	Rejetée
\.


--
-- TOC entry 5072 (class 0 OID 18102)
-- Dependencies: 226
-- Data for Name: statut_passeport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statut_passeport (id, code, libelle) FROM stdin;
1	ACTIF	Actif
2	EXPIRE	Expiré
3	PERDU	Perdu
4	VOLE	Volé
\.


--
-- TOC entry 5076 (class 0 OID 18120)
-- Dependencies: 230
-- Data for Name: statut_piece; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statut_piece (id, code, libelle) FROM stdin;
1	NON_FOURNI	Non fourni
2	FOURNI	Fourni
3	NON_APPLICABLE	Non applicable
\.


--
-- TOC entry 5084 (class 0 OID 18188)
-- Dependencies: 238
-- Data for Name: transfert_passeport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfert_passeport (id, ancien_passeport_id, nouveau_passeport_id, created_at) FROM stdin;
\.


--
-- TOC entry 5070 (class 0 OID 18093)
-- Dependencies: 224
-- Data for Name: type_demande; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_demande (id, code, libelle) FROM stdin;
1	NOUVEAU_TITRE	Nouveau titre de séjour
2	RENOUVELLEMENT	Renouvellement de titre
3	DUPLICATA	Duplicata
4	TRANSFERT	Transfert Passeport
\.


--
-- TOC entry 5068 (class 0 OID 18084)
-- Dependencies: 222
-- Data for Name: type_visa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_visa (id, code, libelle) FROM stdin;
1	TRAVAILLEUR	Travailleur expatrié
2	INVESTISSEUR	Investisseur
\.


--
-- TOC entry 5092 (class 0 OID 18280)
-- Dependencies: 246
-- Data for Name: visa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visa (id, demande_id, passeport_id, reference, date_debut, date_fin, created_at) FROM stdin;
1	2	2	REF-VISA-DUPLICATA	2024-10-04	2027-10-04	2026-05-06 11:14:00.557081
\.


--
-- TOC entry 5086 (class 0 OID 18206)
-- Dependencies: 240
-- Data for Name: visa_transformable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visa_transformable (id, demandeur_id, passeport_id, numero_reference, lieu_entree, date_entree, date_sortie_ref, date_expiration) FROM stdin;
1	1	1	VISAT45	Mada	2026-04-27	\N	2026-05-31
\.


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 247
-- Name: carte_resident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carte_resident_id_seq', 1, true);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 249
-- Name: catalogue_piece_commune_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.catalogue_piece_commune_id_seq', 2, true);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 253
-- Name: catalogue_piece_complementaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.catalogue_piece_complementaire_id_seq', 5, true);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 241
-- Name: demande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.demande_id_seq', 3, true);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 251
-- Name: demande_piece_commune_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.demande_piece_commune_id_seq', 4, true);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 255
-- Name: demande_piece_complementaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.demande_piece_complementaire_id_seq', 4, true);


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 243
-- Name: demande_statut_historique_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.demande_statut_historique_id_seq', 3, true);


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 231
-- Name: demandeur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.demandeur_id_seq', 2, true);


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 217
-- Name: nationalite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nationalite_id_seq', 5, true);


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 233
-- Name: passeport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passeport_id_seq', 2, true);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 235
-- Name: passeport_statut_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passeport_statut_id_seq', 2, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 219
-- Name: situation_familiale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.situation_familiale_id_seq', 5, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 227
-- Name: statut_demande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statut_demande_id_seq', 5, true);


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 225
-- Name: statut_passeport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statut_passeport_id_seq', 4, true);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 229
-- Name: statut_piece_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statut_piece_id_seq', 3, true);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 237
-- Name: transfert_passeport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfert_passeport_id_seq', 1, false);


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 223
-- Name: type_demande_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_demande_id_seq', 4, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_visa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_visa_id_seq', 2, true);


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 245
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visa_id_seq', 1, true);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 239
-- Name: visa_transformable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visa_transformable_id_seq', 1, true);


--
-- TOC entry 4871 (class 2606 OID 18306)
-- Name: carte_resident carte_resident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carte_resident
    ADD CONSTRAINT carte_resident_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 18308)
-- Name: carte_resident carte_resident_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carte_resident
    ADD CONSTRAINT carte_resident_reference_key UNIQUE (reference);


--
-- TOC entry 4875 (class 2606 OID 18329)
-- Name: catalogue_piece_commune catalogue_piece_commune_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_commune
    ADD CONSTRAINT catalogue_piece_commune_code_key UNIQUE (code);


--
-- TOC entry 4877 (class 2606 OID 18327)
-- Name: catalogue_piece_commune catalogue_piece_commune_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_commune
    ADD CONSTRAINT catalogue_piece_commune_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 18365)
-- Name: catalogue_piece_complementaire catalogue_piece_complementaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_complementaire
    ADD CONSTRAINT catalogue_piece_complementaire_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 18367)
-- Name: catalogue_piece_complementaire catalogue_piece_complementaire_type_visa_id_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_complementaire
    ADD CONSTRAINT catalogue_piece_complementaire_type_visa_id_code_key UNIQUE (type_visa_id, code);


--
-- TOC entry 4879 (class 2606 OID 18340)
-- Name: demande_piece_commune demande_piece_commune_demande_id_catalogue_piece_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune
    ADD CONSTRAINT demande_piece_commune_demande_id_catalogue_piece_id_key UNIQUE (demande_id, catalogue_piece_id);


--
-- TOC entry 4881 (class 2606 OID 18338)
-- Name: demande_piece_commune demande_piece_commune_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune
    ADD CONSTRAINT demande_piece_commune_pkey PRIMARY KEY (id);


--
-- TOC entry 4887 (class 2606 OID 18383)
-- Name: demande_piece_complementaire demande_piece_complementaire_demande_id_catalogue_complemen_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire
    ADD CONSTRAINT demande_piece_complementaire_demande_id_catalogue_complemen_key UNIQUE (demande_id, catalogue_complementaire_id);


--
-- TOC entry 4889 (class 2606 OID 18381)
-- Name: demande_piece_complementaire demande_piece_complementaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire
    ADD CONSTRAINT demande_piece_complementaire_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 18233)
-- Name: demande demande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 18268)
-- Name: demande_statut_historique demande_statut_historique_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_statut_historique
    ADD CONSTRAINT demande_statut_historique_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 18137)
-- Name: demandeur demandeur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demandeur
    ADD CONSTRAINT demandeur_pkey PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 18073)
-- Name: nationalite nationalite_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nationalite
    ADD CONSTRAINT nationalite_code_key UNIQUE (code);


--
-- TOC entry 4823 (class 2606 OID 18071)
-- Name: nationalite nationalite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nationalite
    ADD CONSTRAINT nationalite_pkey PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 18156)
-- Name: passeport passeport_numero_passeport_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport
    ADD CONSTRAINT passeport_numero_passeport_key UNIQUE (numero_passeport);


--
-- TOC entry 4853 (class 2606 OID 18154)
-- Name: passeport passeport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport
    ADD CONSTRAINT passeport_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 18176)
-- Name: passeport_statut passeport_statut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport_statut
    ADD CONSTRAINT passeport_statut_pkey PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 18082)
-- Name: situation_familiale situation_familiale_libelle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situation_familiale
    ADD CONSTRAINT situation_familiale_libelle_key UNIQUE (libelle);


--
-- TOC entry 4827 (class 2606 OID 18080)
-- Name: situation_familiale situation_familiale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.situation_familiale
    ADD CONSTRAINT situation_familiale_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 18118)
-- Name: statut_demande statut_demande_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_demande
    ADD CONSTRAINT statut_demande_code_key UNIQUE (code);


--
-- TOC entry 4843 (class 2606 OID 18116)
-- Name: statut_demande statut_demande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_demande
    ADD CONSTRAINT statut_demande_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 18109)
-- Name: statut_passeport statut_passeport_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_passeport
    ADD CONSTRAINT statut_passeport_code_key UNIQUE (code);


--
-- TOC entry 4839 (class 2606 OID 18107)
-- Name: statut_passeport statut_passeport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_passeport
    ADD CONSTRAINT statut_passeport_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 18127)
-- Name: statut_piece statut_piece_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_piece
    ADD CONSTRAINT statut_piece_code_key UNIQUE (code);


--
-- TOC entry 4847 (class 2606 OID 18125)
-- Name: statut_piece statut_piece_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statut_piece
    ADD CONSTRAINT statut_piece_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 18194)
-- Name: transfert_passeport transfert_passeport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfert_passeport
    ADD CONSTRAINT transfert_passeport_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 18100)
-- Name: type_demande type_demande_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_demande
    ADD CONSTRAINT type_demande_code_key UNIQUE (code);


--
-- TOC entry 4835 (class 2606 OID 18098)
-- Name: type_demande type_demande_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_demande
    ADD CONSTRAINT type_demande_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 18091)
-- Name: type_visa type_visa_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_visa
    ADD CONSTRAINT type_visa_code_key UNIQUE (code);


--
-- TOC entry 4831 (class 2606 OID 18089)
-- Name: type_visa type_visa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_visa
    ADD CONSTRAINT type_visa_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 18286)
-- Name: visa visa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa
    ADD CONSTRAINT visa_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 18288)
-- Name: visa visa_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa
    ADD CONSTRAINT visa_reference_key UNIQUE (reference);


--
-- TOC entry 4859 (class 2606 OID 18213)
-- Name: visa_transformable visa_transformable_numero_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa_transformable
    ADD CONSTRAINT visa_transformable_numero_reference_key UNIQUE (numero_reference);


--
-- TOC entry 4861 (class 2606 OID 18211)
-- Name: visa_transformable visa_transformable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa_transformable
    ADD CONSTRAINT visa_transformable_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 18309)
-- Name: carte_resident carte_resident_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carte_resident
    ADD CONSTRAINT carte_resident_demande_id_fkey FOREIGN KEY (demande_id) REFERENCES public.demande(id);


--
-- TOC entry 4910 (class 2606 OID 18314)
-- Name: carte_resident carte_resident_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carte_resident
    ADD CONSTRAINT carte_resident_passeport_id_fkey FOREIGN KEY (passeport_id) REFERENCES public.passeport(id);


--
-- TOC entry 4914 (class 2606 OID 18368)
-- Name: catalogue_piece_complementaire catalogue_piece_complementaire_type_visa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catalogue_piece_complementaire
    ADD CONSTRAINT catalogue_piece_complementaire_type_visa_id_fkey FOREIGN KEY (type_visa_id) REFERENCES public.type_visa(id);


--
-- TOC entry 4900 (class 2606 OID 18234)
-- Name: demande demande_demandeur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_demandeur_id_fkey FOREIGN KEY (demandeur_id) REFERENCES public.demandeur(id);


--
-- TOC entry 4911 (class 2606 OID 18346)
-- Name: demande_piece_commune demande_piece_commune_catalogue_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune
    ADD CONSTRAINT demande_piece_commune_catalogue_piece_id_fkey FOREIGN KEY (catalogue_piece_id) REFERENCES public.catalogue_piece_commune(id);


--
-- TOC entry 4912 (class 2606 OID 18341)
-- Name: demande_piece_commune demande_piece_commune_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune
    ADD CONSTRAINT demande_piece_commune_demande_id_fkey FOREIGN KEY (demande_id) REFERENCES public.demande(id);


--
-- TOC entry 4913 (class 2606 OID 18351)
-- Name: demande_piece_commune demande_piece_commune_statut_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_commune
    ADD CONSTRAINT demande_piece_commune_statut_piece_id_fkey FOREIGN KEY (statut_piece_id) REFERENCES public.statut_piece(id);


--
-- TOC entry 4915 (class 2606 OID 18389)
-- Name: demande_piece_complementaire demande_piece_complementaire_catalogue_complementaire_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire
    ADD CONSTRAINT demande_piece_complementaire_catalogue_complementaire_id_fkey FOREIGN KEY (catalogue_complementaire_id) REFERENCES public.catalogue_piece_complementaire(id);


--
-- TOC entry 4916 (class 2606 OID 18384)
-- Name: demande_piece_complementaire demande_piece_complementaire_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire
    ADD CONSTRAINT demande_piece_complementaire_demande_id_fkey FOREIGN KEY (demande_id) REFERENCES public.demande(id);


--
-- TOC entry 4917 (class 2606 OID 18394)
-- Name: demande_piece_complementaire demande_piece_complementaire_statut_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_piece_complementaire
    ADD CONSTRAINT demande_piece_complementaire_statut_piece_id_fkey FOREIGN KEY (statut_piece_id) REFERENCES public.statut_piece(id);


--
-- TOC entry 4901 (class 2606 OID 18254)
-- Name: demande demande_statut_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_statut_demande_id_fkey FOREIGN KEY (statut_demande_id) REFERENCES public.statut_demande(id);


--
-- TOC entry 4905 (class 2606 OID 18269)
-- Name: demande_statut_historique demande_statut_historique_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_statut_historique
    ADD CONSTRAINT demande_statut_historique_demande_id_fkey FOREIGN KEY (demande_id) REFERENCES public.demande(id);


--
-- TOC entry 4906 (class 2606 OID 18274)
-- Name: demande_statut_historique demande_statut_historique_statut_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande_statut_historique
    ADD CONSTRAINT demande_statut_historique_statut_demande_id_fkey FOREIGN KEY (statut_demande_id) REFERENCES public.statut_demande(id);


--
-- TOC entry 4902 (class 2606 OID 18249)
-- Name: demande demande_type_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_type_demande_id_fkey FOREIGN KEY (type_demande_id) REFERENCES public.type_demande(id);


--
-- TOC entry 4903 (class 2606 OID 18244)
-- Name: demande demande_type_visa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_type_visa_id_fkey FOREIGN KEY (type_visa_id) REFERENCES public.type_visa(id);


--
-- TOC entry 4904 (class 2606 OID 18239)
-- Name: demande demande_visa_transformable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demande
    ADD CONSTRAINT demande_visa_transformable_id_fkey FOREIGN KEY (visa_transformable_id) REFERENCES public.visa_transformable(id);


--
-- TOC entry 4890 (class 2606 OID 18138)
-- Name: demandeur demandeur_nationalite_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demandeur
    ADD CONSTRAINT demandeur_nationalite_id_fkey FOREIGN KEY (nationalite_id) REFERENCES public.nationalite(id);


--
-- TOC entry 4891 (class 2606 OID 18143)
-- Name: demandeur demandeur_situation_familiale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demandeur
    ADD CONSTRAINT demandeur_situation_familiale_id_fkey FOREIGN KEY (situation_familiale_id) REFERENCES public.situation_familiale(id);


--
-- TOC entry 4892 (class 2606 OID 18157)
-- Name: passeport passeport_demandeur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport
    ADD CONSTRAINT passeport_demandeur_id_fkey FOREIGN KEY (demandeur_id) REFERENCES public.demandeur(id);


--
-- TOC entry 4893 (class 2606 OID 18162)
-- Name: passeport passeport_pays_delivrance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport
    ADD CONSTRAINT passeport_pays_delivrance_id_fkey FOREIGN KEY (pays_delivrance_id) REFERENCES public.nationalite(id);


--
-- TOC entry 4894 (class 2606 OID 18177)
-- Name: passeport_statut passeport_statut_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport_statut
    ADD CONSTRAINT passeport_statut_passeport_id_fkey FOREIGN KEY (passeport_id) REFERENCES public.passeport(id);


--
-- TOC entry 4895 (class 2606 OID 18182)
-- Name: passeport_statut passeport_statut_statut_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passeport_statut
    ADD CONSTRAINT passeport_statut_statut_passeport_id_fkey FOREIGN KEY (statut_passeport_id) REFERENCES public.statut_passeport(id);


--
-- TOC entry 4896 (class 2606 OID 18195)
-- Name: transfert_passeport transfert_passeport_ancien_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfert_passeport
    ADD CONSTRAINT transfert_passeport_ancien_passeport_id_fkey FOREIGN KEY (ancien_passeport_id) REFERENCES public.passeport(id);


--
-- TOC entry 4897 (class 2606 OID 18200)
-- Name: transfert_passeport transfert_passeport_nouveau_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfert_passeport
    ADD CONSTRAINT transfert_passeport_nouveau_passeport_id_fkey FOREIGN KEY (nouveau_passeport_id) REFERENCES public.passeport(id);


--
-- TOC entry 4907 (class 2606 OID 18289)
-- Name: visa visa_demande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa
    ADD CONSTRAINT visa_demande_id_fkey FOREIGN KEY (demande_id) REFERENCES public.demande(id);


--
-- TOC entry 4908 (class 2606 OID 18294)
-- Name: visa visa_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa
    ADD CONSTRAINT visa_passeport_id_fkey FOREIGN KEY (passeport_id) REFERENCES public.passeport(id);


--
-- TOC entry 4898 (class 2606 OID 18214)
-- Name: visa_transformable visa_transformable_demandeur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa_transformable
    ADD CONSTRAINT visa_transformable_demandeur_id_fkey FOREIGN KEY (demandeur_id) REFERENCES public.demandeur(id);


--
-- TOC entry 4899 (class 2606 OID 18219)
-- Name: visa_transformable visa_transformable_passeport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visa_transformable
    ADD CONSTRAINT visa_transformable_passeport_id_fkey FOREIGN KEY (passeport_id) REFERENCES public.passeport(id);


-- Completed on 2026-05-09 11:42:40

--
-- PostgreSQL database dump complete
--

