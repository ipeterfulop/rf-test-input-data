CREATE OR REPLACE PROCEDURE ugyfel_masolasa_meseorszagba
AS
BEGIN
    FOR r IN (select * from ugyfel where get_normalizalt_orszag_nev(orszag) = 'magyarorszag')
        LOOP
            r.ugyfel_azonosito := NULL;
            r.orszag  := 'Meseország';
            r.eves_jovedelem  := 2*r.eves_jovedelem;
            INSERT INTO ugyfel (ugyfel_tipus, orszag, eves_jovedelem VALUES (r.ugyfel_azonosito, r.orszag, r.eves_jovedelem));
        END LOOP;
END;