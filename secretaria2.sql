--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: aluno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE aluno (
    matricula integer NOT NULL,
    nomea character varying(100) NOT NULL,
    sexoa character varying(2),
    curso character varying(30),
    cpf character varying(11) NOT NULL,
    celular character varying(11),
    CONSTRAINT validador_sexo CHECK (((sexoa)::text = ANY ((ARRAY['M'::character varying, 'F'::character varying])::text[])))
);


ALTER TABLE aluno OWNER TO postgres;

--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE enderecos (
    matricula integer,
    endereco character varying(100),
    cidade character varying(50) NOT NULL,
    estado character varying(2),
    CONSTRAINT enderecos_estado_check CHECK (((estado)::text = ANY ((ARRAY['AC'::character varying, 'AL'::character varying, 'AP'::character varying, 'AM'::character varying, 'BA'::character varying, 'CE'::character varying, 'DF'::character varying, 'ES'::character varying, 'GO'::character varying, 'MA'::character varying, 'MT'::character varying, 'MS'::character varying, 'MG'::character varying, 'PA'::character varying, 'PB'::character varying, 'PR'::character varying, 'PE'::character varying, 'PI'::character varying, 'RR'::character varying, 'RO'::character varying, 'RJ'::character varying, 'RN'::character varying, 'RS'::character varying, 'SC'::character varying, 'SP'::character varying, 'SE'::character varying, 'TO'::character varying])::text[])))
);


ALTER TABLE enderecos OWNER TO postgres;

--
-- Name: aluno_dados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW aluno_dados AS
 SELECT aluno.matricula,
    aluno.nomea,
    aluno.sexoa,
    aluno.curso,
    aluno.cpf,
    aluno.celular,
    enderecos.endereco,
    enderecos.cidade,
    enderecos.estado
   FROM (aluno
     JOIN enderecos USING (matricula))
  WHERE (aluno.matricula = aluno.matricula);


ALTER TABLE aluno_dados OWNER TO postgres;

--
-- Name: cursar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cursar (
    cod_c integer NOT NULL,
    cod_a integer NOT NULL
);


ALTER TABLE cursar OWNER TO postgres;

--
-- Name: disciplina; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE disciplina (
    cod_disc integer NOT NULL,
    masp integer NOT NULL,
    cargahp integer,
    cargaht integer,
    periodo integer,
    nomed character varying(40)
);


ALTER TABLE disciplina OWNER TO postgres;

--
-- Name: professor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE professor (
    masp integer NOT NULL,
    dep character varying(3),
    nomep character varying(30),
    sexop character varying(1),
    CONSTRAINT professor_masp_check CHECK ((masp < 999999999))
);


ALTER TABLE professor OWNER TO postgres;

--
-- Name: disciplina_cursadas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW disciplina_cursadas AS
 SELECT aluno.nomea AS aluno,
    professor.nomep AS professor,
    disciplina.nomed AS disciplina
   FROM (((aluno
     CROSS JOIN professor)
     JOIN disciplina USING (masp))
     CROSS JOIN cursar)
  WHERE ((cursar.cod_c = disciplina.cod_disc) AND (cursar.cod_a = aluno.matricula) AND (professor.masp = professor.masp));


ALTER TABLE disciplina_cursadas OWNER TO postgres;

--
-- Name: orienta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE orienta (
    cod_o integer,
    matricula_o integer NOT NULL
);


ALTER TABLE orienta OWNER TO postgres;

--
-- Name: orientaoes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW orientaoes AS
 SELECT aluno.nomea AS aluno_orienta,
    professor.nomep AS professor_orientador
   FROM ((aluno
     CROSS JOIN professor)
     CROSS JOIN orienta)
  WHERE ((orienta.cod_o = professor.masp) AND (aluno.matricula = orienta.matricula_o));


ALTER TABLE orientaoes OWNER TO postgres;

--
-- Data for Name: aluno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY aluno (matricula, nomea, sexoa, curso, cpf, celular) FROM stdin;
977803203	Yago Filipe Moreira	M	Direito Empresarial	48742614341	82992910003
948393715	Evelyn Sophie Cristiane Sales	F	Engenharia de Software	33164397577	81994053884
813602805	Lorena Marina Viana	F	Ciencia de Dados	97963408875	82993175639
118957214	Sarah Allana Laura Mendes	F	Marketing Digital	69940849060	63992093379
396671005	Severino Fernando Thomas Almeida	M	Administra├óÔé¼┬í├âÔÇáo de Empresas	67450011441	51992395061
646616867	Sophia Barbosa Silva	F	Engenharia de Alimentos	89574123598	45000990985
673753557	Daniel Henrique Aragao	M	Psicologia Organizacional	9781759801	82994861164
\.


--
-- Data for Name: cursar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cursar (cod_c, cod_a) FROM stdin;
1	977803203
1	673753557
1	948393715
2	813602805
2	118957214
3	396671005
3	646616867
\.


--
-- Data for Name: disciplina; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY disciplina (cod_disc, masp, cargahp, cargaht, periodo, nomed) FROM stdin;
1	12345678	0	72	1	Metodos Computacionais
2	34567890	100	20	2	Botanica Aplicada
3	23456789	0	120	1	Analise Numerica
\.


--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY enderecos (matricula, endereco, cidade, estado) FROM stdin;
977803203	Travessa Rio da Silva	Montes Claros	MG
948393715	Rua Professora Maria Menelau	Pintopolis	MG
813602805	Quadra H	S├åo Paulo	SP
118957214	Quadra 110 Sul Avenida NS 10, 523, Plano Diretor Sul	Palmas	TO
396671005	Rua Seis de Maio, 325, Vila da Paz	Cachoeirinha	RS
646616867	Rua Bartoleu Kuma	Curutiba	RS
673753557	Rua Edilia dos Santos	Porto Seguro	SE
\.


--
-- Data for Name: orienta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY orienta (cod_o, matricula_o) FROM stdin;
12345678	977803203
12345678	673753557
87654321	948393715
23456789	813602805
23456789	118957214
98765432	396671005
34567890	646616867
\.


--
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY professor (masp, dep, nomep, sexop) FROM stdin;
12345678	DCC	Joao da Silva	M
87654321	DCC	Maria Oliveira Souza	F
23456789	DCE	Pedro dos Santos	M
98765432	DCB	Ana da Silva Pereira	F
34567890	DCB	Luiza Mendes Oliveira	F
\.


--
-- Name: aluno aluno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT aluno_pkey PRIMARY KEY (matricula);


--
-- Name: aluno cpf_unico; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aluno
    ADD CONSTRAINT cpf_unico UNIQUE (cpf);


--
-- Name: cursar cursar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cursar
    ADD CONSTRAINT cursar_pkey PRIMARY KEY (cod_c, cod_a);


--
-- Name: disciplina disciplina_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT disciplina_pkey PRIMARY KEY (cod_disc);


--
-- Name: professor professor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (masp);


--
-- Name: cursar assiste; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cursar
    ADD CONSTRAINT assiste FOREIGN KEY (cod_a) REFERENCES aluno(matricula) ON DELETE CASCADE;


--
-- Name: cursar cursa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cursar
    ADD CONSTRAINT cursa FOREIGN KEY (cod_c) REFERENCES disciplina(cod_disc) ON DELETE CASCADE;


--
-- Name: enderecos deleta_dados; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos
    ADD CONSTRAINT deleta_dados FOREIGN KEY (matricula) REFERENCES aluno(matricula) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enderecos enderecos_matricula_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enderecos
    ADD CONSTRAINT enderecos_matricula_fkey FOREIGN KEY (matricula) REFERENCES aluno(matricula);


--
-- Name: orienta orientado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orienta
    ADD CONSTRAINT orientado FOREIGN KEY (matricula_o) REFERENCES aluno(matricula) ON DELETE CASCADE;


--
-- Name: orienta orientador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orienta
    ADD CONSTRAINT orientador FOREIGN KEY (cod_o) REFERENCES professor(masp) ON DELETE CASCADE;


--
-- Name: disciplina prof; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY disciplina
    ADD CONSTRAINT prof FOREIGN KEY (masp) REFERENCES professor(masp);


--
-- PostgreSQL database dump complete
--

