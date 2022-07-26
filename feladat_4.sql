SELECT
    atlagos_ido.ugyfel_azonosito,
    atlagos_ido_hetekben_ket_rendeles_kozott,
    round(100 * ugyfel_rendeleseinek_szama / osszes_rendeles_szama, 2) AS ugyfelrendelesek_es_osszes_rendeles_szazalekos_aranya
FROM
    (
        SELECT
            ugyfel_azonosito,
            trunc(((MAX(rendeles_idopontja) - MIN(rendeles_idopontja)) / 7) / COUNT(*)) atlagos_ido_hetekben_ket_rendeles_kozott,
            COUNT(*) AS ugyfel_rendeleseinek_szama
        FROM
            rendeles r
        GROUP BY
            ugyfel_azonosito
    ) atlagos_ido,
    (
        SELECT
            COUNT(*) osszes_rendeles_szama
        FROM
            rendeles
    ) stat