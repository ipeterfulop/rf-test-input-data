CREATE
OR REPLACE FUNCTION getNormalizaltOrszagNev(
	orszagnev VARCHAR2
) RETURN VARCHAR2 as 
	normalizaltNev VARCHAR2;
BEGIN
	
	normalizaltNev
:= LOWER (
		REPLACE(
			REPLACE(
					REPLACE(
						orszagnev, ' ', ''
						), 
					'á', 'a'),
			'Á', 'A')
		);

return normalizaltNev;
END;


SELECT orszagbesorolas, tipusbesorolas, AVG(eves_jovedelem)
FROM (SELECT u.ugyfel_azonosito,
             eves_jovedelem,
             CASE
                 WHEN NVL(getnormalizaltorszagnev(orszag), '') = 'magyarorszag' THEN 'Magyarország'
                 ELSE 'Egyeb' END     as orszagbesorolas,
             CASE
                 WHEN (ugyfeltipus IN ('NAGYVALLALATI', 'KISVALLALATI')) THEN 'NAGYVALLALATI vagy KISVALLALATI'
                 ELSE ugyfeltipus END as tipusbesorolas
      FROM ugyfel u
      WHERE u.orszag IS NOT NULL
        AND u.eves_jovedelem IS NOT NULL
        AND u.ugyfel_azonosito IN (SELECT DISTINCT ugyfel_azonosito FROM rendeles)
        AND u.ugyfel_azonosito NOT IN
            (SELECT DISTINCT ugyfel_azonosito
             FROM rendeles
             WHERE EXTRACT(YEAR FROM rendeles_idopontja) = EXTRACT(YEAR FROM SYSDATE))
      );
