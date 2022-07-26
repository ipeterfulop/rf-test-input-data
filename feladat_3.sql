CREATE SEQUENCE ugyfel_seq
    MINVALUE 1
    START WITH 1000
    INCREMENT BY 1
    CACHE 20;


ALTER TABLE ugyfel (MODIFY ugyfel_azonosito GENERATED BY DEFAULT AS IDENTITY
(START WITH 1000
 INCREMENT BY 1
 MAXVALUE 5000000
 CACHE 1
 CYCLE)
);


CREATE OR REPLACE PROCEDURE ugyfel_masolasa_meseorszagba
AS
BEGIN
    FOR r IN (select * from ugyfel where get_normalizalt_orszag_nev(orszag) = 'magyarorszag')
        LOOP
            r.ugyfel_azonosito := NULL;
            r.orszag  := 'Meseország';
            r.eves_jovedelem  := 2*r.eves_jovedelem;
            INSERT INTO ugyfel VALUES r;
        END LOOP;
END;