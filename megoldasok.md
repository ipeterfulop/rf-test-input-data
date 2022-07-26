# Bevezető


# 1. Feladat
```oracle
SELECT
    SUM(CASE WHEN (stat.rendelesek_szama BETWEEN 0 AND 10) THEN 1 ELSE 0 END) as rendelesek_szama_1_es_10_kozott,
    SUM(CASE WHEN (stat.rendelesek_szama BETWEEN 11 AND 100) THEN 1 ELSE 0 END) as rendelesek_szama_11_es_100_kozott,
    SUM(CASE WHEN (stat.rendelesek_szama > 100) THEN 1 ELSE 0 END) as rendelesek_szama_100_nal_tobb
FROM
    (
        SELECT
            u.ugyfel_azonosito,
            nvl(stat_r.rendelesek_szama_r, 0) AS rendelesek_szama
        FROM
            ugyfel u
                LEFT JOIN (
                SELECT
                    ugyfel_azonosito,
                    COUNT(*) AS rendelesek_szama_r
                FROM
                    rendeles
                GROUP BY
                    ugyfel_azonosito
            ) stat_r ON u.ugyfel_azonosito = stat_r.ugyfel_azonosito
    ) stat;
```

# 2. Feladat
A csoportosító lekérdezés megírása előtt írtam egy függvényt, amely az ```ugyfel.orszag``` oszlopban a ```Magyarország``` 
különbőző előfordulásait kezeli, pontosabban a bemenetként kapott karakterláncból törli a szóközöket, 
illetve cseréli az ékezetes betűket, majd a kapott eredmény karakterláncot kisbetűkre alakítva téríti vissza. 
```oracle
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
```
  
Ezen függvény felhasználásával 

```oracle
SELECT orszagbesorolas, tipusbesorolas, AVG(eves_jovedelem) as atlagjovedelem
FROM (`SELECT u.ugyfel_azonosito,
             eves_jovedelem,
             CASE
                 WHEN NVL(getNormalizaltOrszagNev(orszag), '') = 'magyarorszag' THEN 'Magyarország'
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
```