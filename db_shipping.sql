--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-07-24 11:17:50

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: app; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA app;


ALTER SCHEMA app OWNER TO pg_database_owner;

--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA app; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA app IS 'standard public schema';


--
-- TOC entry 7 (class 2615 OID 24867)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 24868)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 239 (class 1255 OID 24852)
-- Name: buat_id_shipment(date); Type: FUNCTION; Schema: app; Owner: postgres
--

CREATE FUNCTION app.buat_id_shipment(tanggal date) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    nomor_urut integer;
BEGIN
    SELECT nextval('shipment_seq') INTO nomor_urut;
    RETURN to_char(tanggal, 'yymmdd') || lpad(nomor_urut::text, 3, '0');
END;
$$;


ALTER FUNCTION app.buat_id_shipment(tanggal date) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 24855)
-- Name: create_shipment(integer, integer, integer, date, time without time zone); Type: PROCEDURE; Schema: app; Owner: postgres
--

CREATE PROCEDURE app.create_shipment(IN id_shipping integer, IN store_id integer, IN driver_id integer, IN sending_date date, IN sending_time time without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO app.shipment (id_shipping, store_id, driver_id, sending_date, sending_time)
	VALUES (id_shipping, store_id, driver_id, sending_date, sending_time);
END;
$$;


ALTER PROCEDURE app.create_shipment(IN id_shipping integer, IN store_id integer, IN driver_id integer, IN sending_date date, IN sending_time time without time zone) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 24866)
-- Name: update_shipment(integer, integer, character varying, integer); Type: PROCEDURE; Schema: app; Owner: postgres
--

CREATE PROCEDURE app.update_shipment(IN rqproduct_id integer, IN rqqty integer, IN rqunit character varying, INOUT resid integer)
    LANGUAGE plpgsql
    AS $$
begin
update app.shipment
set product_id = rqproduct_id, 
qty = rqqty, 
unit = rqunit
where id_shipping = resid returning id_shipping into resid;
commit;
END;
$$;


ALTER PROCEDURE app.update_shipment(IN rqproduct_id integer, IN rqqty integer, IN rqunit character varying, INOUT resid integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 24665)
-- Name: codriver; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.codriver (
    id_codriver integer NOT NULL,
    name_codriver name NOT NULL COLLATE pg_catalog."default"
);


ALTER TABLE app.codriver OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24670)
-- Name: driver; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.driver (
    id_driver integer NOT NULL,
    name_driver name NOT NULL COLLATE pg_catalog."default",
    codriver_id integer,
    vehicle_id integer
);


ALTER TABLE app.driver OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24647)
-- Name: operator; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.operator (
    id_operator integer NOT NULL,
    name_operator character varying NOT NULL
);


ALTER TABLE app.operator OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24642)
-- Name: product; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.product (
    id_product integer NOT NULL,
    name_product text NOT NULL
);


ALTER TABLE app.product OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24697)
-- Name: shipment; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.shipment (
    id_shipping integer NOT NULL,
    product_id integer,
    qty integer,
    unit character varying(20),
    store_id integer,
    sending_date date,
    sending_time time without time zone,
    "delivered _date" date,
    delivered_time time without time zone,
    driver_id integer,
    status text
);


ALTER TABLE app.shipment OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24851)
-- Name: shipment_seq; Type: SEQUENCE; Schema: app; Owner: postgres
--

CREATE SEQUENCE app.shipment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app.shipment_seq OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24685)
-- Name: store; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.store (
    id_store integer NOT NULL,
    name_store name NOT NULL COLLATE pg_catalog."default",
    address text NOT NULL,
    receiver character varying NOT NULL,
    operator_id integer
);


ALTER TABLE app.store OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24652)
-- Name: vehicle; Type: TABLE; Schema: app; Owner: postgres
--

CREATE TABLE app.vehicle (
    id_vehicle integer NOT NULL,
    shipping_vehicle character varying(20) NOT NULL,
    no_polisi character varying(20) NOT NULL
);


ALTER TABLE app.vehicle OWNER TO postgres;

--
-- TOC entry 3485 (class 0 OID 24665)
-- Dependencies: 219
-- Data for Name: codriver; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.codriver (id_codriver, name_codriver) FROM stdin;
1	Andi Wahyu
2	Dadang Bima
3	Hari Saputra
\.


--
-- TOC entry 3486 (class 0 OID 24670)
-- Dependencies: 220
-- Data for Name: driver; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.driver (id_driver, name_driver, codriver_id, vehicle_id) FROM stdin;
3	Ginanjar	3	1
2	Hari Saputra	2	2
1	Dimas Ahmad	1	1
\.


--
-- TOC entry 3483 (class 0 OID 24647)
-- Dependencies: 217
-- Data for Name: operator; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.operator (id_operator, name_operator) FROM stdin;
1	Ahmad Agus
2	Fitrianto
\.


--
-- TOC entry 3482 (class 0 OID 24642)
-- Dependencies: 216
-- Data for Name: product; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.product (id_product, name_product) FROM stdin;
205	Milna Biskuit Bayi Pisang\n
204	Milna Biskuit Bayi Jeruk\n
203	Milna Biskuit Bayi Kacang Hijau\n
202	Milna Biskuit Bayi Beras Merah\n
201	Milna Biskuit Bayi Original\n
105	Hydro Coco Vita-D 330ml\n
104	Hydro Coco 1 liter\n
103	Hydro Coco 500ml\n
102	Hydro Coco 330ml\n
101	Hydro Coco 250ml\n
215	Milna Bubur Bayi Hati Ayam Brokoli Untuk 8 - 12 Bulan\n
214	Milna Bubur Bayi Daging Kacang Polong Untuk 8 - 12 Bulan\n
213	Milna Bubur Bayi Ayam Jagung Manis Untuk 8 - 12 Bulan\n
212	Milna Bubur Bayi Tim Hati Ayam Bayam Untuk 6 - 12 Bulan\n
211	Milna Bubur Bayi Sup Daging Brokoli Untuk 6 - 12 Bulan\n
210	Milna Bubur Bayi Sup Ayam Wortel Untuk 6 - 12 Bulan\n
209	Milna Bubur Bayi Pisang Untuk 6 - 12 Bulan\n
208	Milna Bubur Bayi Beras Merah Untuk 6 - 12 Bulan\n
207	Milna Biskuit Bayi Apel Jeruk\n
206	Milna Biskuit Bayi Apel\n
225	Milna Goodmil Wortel Labu\n
224	Milna Goodmil Peach Stroberi Jeruk\n
223	Milna Bubur Bayi WGAIN Ayam Bayam\n
222	Milna Bubur Bayi WGAIN Ayam Manis Teriyaki\n
221	Milna Bubur Bayi WGAIN Ayam Wortel Brokoli\n
220	Milna Bubur Bayi WGAIN Ayam Kacang Polong\n
219	Milna Bubur Organik Multigrain\n
218	Milna Bubur Organik Beras Merah\n
217	Milna Bubur Organik Kacang Hijau\n
216	Milna Bubur Organik Pisang\n
235	Milna Nature Puffs Organic Keju\n
234	Milna Nature Puffs Organic Pisang\n
233	Milna Biskuit Bayi Finger\n
232	Milna Nature Delight Apel Pisang Stroberi\n
231	Milna Nature Delight Apel Labu Wortel\n
230	Milna Nature Delight Apel Peach\n
229	Milna Goodmil Hypoallergenic Beras Merah\n
228	Milna Goodmil Beras Merah Ayam\n
227	Milna Goodmil Beras Merah Pisang\n
226	Milna Goodmil Beras Merah Semur Ayam\n
402	Entrasol Active Mochaccino\n
401	Entrasol Active Vanilla latte\n
304	Nutrive Benecol Lychee\n
303	Nutrive Benecol Orange\n
302	Nutrive Benecol Strawberry\n
301	Nutrive Benecol Blackcurrant\n
239	Milna Rice Crackers Sweet Potato Carrot\n
238	Milna Rice Crackers Banana Berries\n
237	Milna Rice Crackers Apple Orange\n
236	Milna Nature Puffs Organic Apel & Mix Berries\n
412	Entrasol Platinum Chocolate\n
411	Entrasol Platinum Vanilla\n
410	Entrasol Cereal Chocolate\n
409	Entrasol Cereal Vanilla Vegie\n
408	Entrasol UHT Chocolate\n
407	Entrasol UHT Vanilla Latte\n
406	Entrasol Gold Vanilla\n
405	Entrasol Gold Chocolate\n
404	Entrasol Gold Original\n
403	Entrasol Active Chocolate\n
\.


--
-- TOC entry 3488 (class 0 OID 24697)
-- Dependencies: 222
-- Data for Name: shipment; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.shipment (id_shipping, product_id, qty, unit, store_id, sending_date, sending_time, "delivered _date", delivered_time, driver_id, status) FROM stdin;
2	105	5	box	1	2023-05-01	10:00:00	2023-05-01	13:30:00	1	selesai
3	206	10	box	1	2023-05-01	10:00:00	2023-05-01	13:30:00	1	selesai
4	101	3	box	2	2023-05-01	11:00:00	2023-05-01	13:00:00	2	selesai
5	102	2	box	2	2023-05-01	11:00:00	2023-05-01	13:00:00	2	selesai
6	404	8	box	2	2023-05-01	11:00:00	2023-05-01	13:00:00	2	selesai
7	230	10	box	3	2023-05-02	09:00:00	2023-05-02	12:00:00	3	selesai
8	231	5	box	3	2023-05-02	09:00:00	2023-05-02	12:00:00	3	selesai
9	237	12	box	3	2023-05-02	09:00:00	2023-05-02	12:00:00	3	selesai
10	219	10	box	3	2023-05-02	09:00:00	2023-05-02	12:00:00	3	selesai
11	401	5	box	4	2023-05-02	09:00:00	2023-05-02	14:00:00	3	selesai
12	404	4	box	4	2023-05-02	09:00:00	2023-05-02	14:00:00	3	selesai
13	405	6	box	4	2023-05-02	09:00:00	2023-05-02	14:00:00	3	selesai
1	101	5	box	1	2023-05-01	10:00:00	2023-05-01	13:30:00	1	selesai
14	223	8	box	2	2023-07-19	09:00:00	\N	\N	1	\N
\.


--
-- TOC entry 3487 (class 0 OID 24685)
-- Dependencies: 221
-- Data for Name: store; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.store (id_store, name_store, address, receiver, operator_id) FROM stdin;
4	Apotek Agung	Pasar Senen no 301	Jamal	2
3	Toko Anak Sehat	Jln Imam Bonjol no 33	Aji	2
2	Toko Maju Bersama	Jln Agus Salim no 22	Eriawan	1
1	Apotek Agus Sari	Jln Angga Jaya no 21	Dian Ayu	1
\.


--
-- TOC entry 3484 (class 0 OID 24652)
-- Dependencies: 218
-- Data for Name: vehicle; Type: TABLE DATA; Schema: app; Owner: postgres
--

COPY app.vehicle (id_vehicle, shipping_vehicle, no_polisi) FROM stdin;
1	Box A001	B 1234 GA
2	Box A002	B 3214 JS
\.


--
-- TOC entry 3247 (class 0 OID 24869)
-- Dependencies: 224
-- Data for Name: pga_jobagent; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
\.


--
-- TOC entry 3248 (class 0 OID 24878)
-- Dependencies: 226
-- Data for Name: pga_jobclass; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
\.


--
-- TOC entry 3249 (class 0 OID 24888)
-- Dependencies: 228
-- Data for Name: pga_job; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
\.


--
-- TOC entry 3251 (class 0 OID 24936)
-- Dependencies: 232
-- Data for Name: pga_schedule; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
\.


--
-- TOC entry 3252 (class 0 OID 24964)
-- Dependencies: 234
-- Data for Name: pga_exception; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
\.


--
-- TOC entry 3253 (class 0 OID 24978)
-- Dependencies: 236
-- Data for Name: pga_joblog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
\.


--
-- TOC entry 3250 (class 0 OID 24912)
-- Dependencies: 230
-- Data for Name: pga_jobstep; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
\.


--
-- TOC entry 3254 (class 0 OID 24994)
-- Dependencies: 238
-- Data for Name: pga_jobsteplog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
\.


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 223
-- Name: shipment_seq; Type: SEQUENCE SET; Schema: app; Owner: postgres
--

SELECT pg_catalog.setval('app.shipment_seq', 13, true);


--
-- TOC entry 3303 (class 2606 OID 24669)
-- Name: codriver codriver_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.codriver
    ADD CONSTRAINT codriver_pk PRIMARY KEY (id_codriver);


--
-- TOC entry 3305 (class 2606 OID 24674)
-- Name: driver driver_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.driver
    ADD CONSTRAINT driver_pk PRIMARY KEY (id_driver);


--
-- TOC entry 3299 (class 2606 OID 24651)
-- Name: operator operator_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.operator
    ADD CONSTRAINT operator_pk PRIMARY KEY (id_operator);


--
-- TOC entry 3297 (class 2606 OID 24806)
-- Name: product product_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.product
    ADD CONSTRAINT product_pk PRIMARY KEY (id_product);


--
-- TOC entry 3310 (class 2606 OID 24701)
-- Name: shipment shipping_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.shipment
    ADD CONSTRAINT shipping_pk PRIMARY KEY (id_shipping);


--
-- TOC entry 3307 (class 2606 OID 24691)
-- Name: store store_pk; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.store
    ADD CONSTRAINT store_pk PRIMARY KEY (id_store);


--
-- TOC entry 3301 (class 2606 OID 24656)
-- Name: vehicle vehicle_pkey; Type: CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (id_vehicle);


--
-- TOC entry 3308 (class 1259 OID 25027)
-- Name: shipment_index; Type: INDEX; Schema: app; Owner: postgres
--

CREATE INDEX shipment_index ON app.shipment USING btree (id_shipping, sending_time);


--
-- TOC entry 3334 (class 2606 OID 24675)
-- Name: driver codriver_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.driver
    ADD CONSTRAINT codriver_id_fk FOREIGN KEY (codriver_id) REFERENCES app.codriver(id_codriver);


--
-- TOC entry 3337 (class 2606 OID 24846)
-- Name: shipment driver_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.shipment
    ADD CONSTRAINT driver_id_fk FOREIGN KEY (driver_id) REFERENCES app.driver(id_driver) NOT VALID;


--
-- TOC entry 3336 (class 2606 OID 24692)
-- Name: store operator_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.store
    ADD CONSTRAINT operator_id_fk FOREIGN KEY (operator_id) REFERENCES app.operator(id_operator);


--
-- TOC entry 3338 (class 2606 OID 24807)
-- Name: shipment product_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.shipment
    ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES app.product(id_product);


--
-- TOC entry 3339 (class 2606 OID 24707)
-- Name: shipment store_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.shipment
    ADD CONSTRAINT store_id_fk FOREIGN KEY (store_id) REFERENCES app.store(id_store) NOT VALID;


--
-- TOC entry 3335 (class 2606 OID 24680)
-- Name: driver vehicle_id_fk; Type: FK CONSTRAINT; Schema: app; Owner: postgres
--

ALTER TABLE ONLY app.driver
    ADD CONSTRAINT vehicle_id_fk FOREIGN KEY (vehicle_id) REFERENCES app.vehicle(id_vehicle) NOT VALID;


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE codriver; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.codriver TO backend_admin;


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE driver; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.driver TO backend_admin;


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE operator; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.operator TO backend_admin;


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE product; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.product TO backend_admin;


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE shipment; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.shipment TO backend_admin;


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE store; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.store TO backend_admin;


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE vehicle; Type: ACL; Schema: app; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.vehicle TO backend_admin;


-- Completed on 2023-07-24 11:17:50

--
-- PostgreSQL database dump complete
--

