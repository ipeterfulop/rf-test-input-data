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
