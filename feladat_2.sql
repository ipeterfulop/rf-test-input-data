CREATE OR REPLACE FUNCTION get_normalizalt_orszag_nev(
    orszagnev VARCHAR2
) RETURN VARCHAR2 as
    normalizalt_nev VARCHAR2(50);
BEGIN

    normalizalt_nev
        := LOWER(
            REPLACE(
                    REPLACE(
                            REPLACE(
                                    orszagnev, ' ', ''
                                ),
                            'á', 'a'),
                    'Á', 'A')
        );

    return normalizalt_nev;
END;


SELECT orszagbesorolas, tipusbesorolas, AVG(eves_jovedelem) as atlagjovedelem
FROM (SELECT u.ugyfel_azonosito,
             eves_jovedelem,
             CASE
                 WHEN NVL(get_normalizalt_orszag_nev(orszag), '') = 'magyarorszag' THEN 'Magyarország'
                 ELSE 'Egyéb' END     as orszagbesorolas,
             CASE
                 WHEN (ugyfel_tipus IN ('NAGYVALLALATI', 'KISVALLALATI')) THEN 'NAGYVALLALATI vagy KISVALLALATI'
                 ELSE ugyfel_tipus END as tipusbesorolas
      FROM ugyfel u
      WHERE u.orszag IS NOT NULL
        AND u.eves_jovedelem IS NOT NULL
        AND u.ugyfel_azonosito IN (SELECT DISTINCT ugyfel_azonosito FROM rendeles)
        AND u.ugyfel_azonosito NOT IN
            (SELECT DISTINCT ugyfel_azonosito
             FROM rendeles
             WHERE EXTRACT(YEAR FROM rendeles_idopontja) = EXTRACT(YEAR FROM SYSDATE))`) t
GROUP BY orszagbesorolas, tipusbesorolas
ORDER BY orszagbesorolas DESC;
