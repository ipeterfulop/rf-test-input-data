```oracle
SELECT u.ugyfel_azonosito,
       CASE
           WHEN NVL(getnormalizaltorszagnev(orszag), '') = 'magyarorszag' THEN 'Magyarorszag'
           ELSE 'Egyeb' END as orszagbesorolas,
      CASE WHEN 

FROM ugyfel u

WHERE u.orszag IS NOT NULL
  AND u.eves_jovedelem IS NOT NULL
  AND u.ugyfel_azonosito IN (SELECT DISTINCT ugyfel_azonosito FROM rendeles)
  AND u.ugyfel_azonosito NOT IN
      (SELECT DISTINCT ugyfel_azonosito
       FROM rendeles
       WHERE EXTRACT(YEAR FROM rendeles_idopontja) = EXTRACT(YEAR FROM SYSDATE));
```