CREATE OR REPLACE TYPE termin_info AS OBJECT (
    godz_rozpoczecia TIMESTAMP,
    dzien_tygodnia NUMBER,
    nr_sali sala.nr_sali%TYPE
);
/

CREATE OR REPLACE FUNCTION znajdz_wolny_termin (typ_sali IN VARCHAR2) 
RETURN termin_info IS
    wolny_termin termin_info := termin_info(NULL, NULL, NULL);
BEGIN
    FOR dzien in 1..5 LOOP
        FOR godz in 8..19 LOOP
            wolny_termin.godz_rozpoczecia := TO_TIMESTAMP(TO_CHAR(godz) || ':00:00', 'HH24:MI:SS');
            DECLARE
                CURSOR c_sala IS
                SELECT nr_sali
                FROM sala
                WHERE typ = typ_sali AND nr_sali NOT IN (
                    SELECT nr_sali
                    FROM zajecia
                    WHERE dzien_tygodnia = dzien AND 
                    (
                        (godz_rozpoczecia >= wolny_termin.godz_rozpoczecia AND godz_rozpoczecia < wolny_termin.godz_rozpoczecia + INTERVAL '90' MINUTE) OR 
                        (wolny_termin.godz_rozpoczecia < godz_rozpoczecia + INTERVAL '90' MINUTE AND wolny_termin.godz_rozpoczecia + INTERVAL '90' MINUTE <= wolny_termin.godz_rozpoczecia + INTERVAL '90' MINUTE)
                    )
                )
                AND ROWNUM = 1;
                sala_rec c_sala%ROWTYPE;
            BEGIN
                OPEN c_sala;
                FETCH c_sala INTO sala_rec;
                IF c_sala%FOUND THEN
                    CLOSE c_sala;
                    wolny_termin.dzien_tygodnia := dzien;
                    wolny_termin.nr_sali := sala_rec.nr_sali;
                    RETURN wolny_termin;
                END IF;
                CLOSE c_sala;
            END;
        END LOOP;
    END LOOP;
    RETURN NULL;
END;
/

CREATE OR REPLACE FUNCTION znajdz_typ_sali (typ_zajec IN VARCHAR2) 
RETURN VARCHAR2 IS
    typ_sali VARCHAR2(20);
BEGIN
    CASE typ_zajec
        WHEN 'W' THEN typ_sali := 'wykladowa';
        WHEN 'L' THEN typ_sali := 'laboratoryjna';
        WHEN 'CW' THEN typ_sali := 'cwiczeniowa';
        WHEN 'PS' THEN typ_sali := 'komputerowa';
    END CASE;
    RETURN typ_sali;
END;
/

CREATE OR REPLACE PROCEDURE dodaj_zajecia (
    typ_zajec VARCHAR2,
    id_przedmiotu INTEGER,
    id_pracownika INTEGER
) IS
    typ_sali VARCHAR2(20);
    wolny_termin termin_info;
    nowe_id_zajec zajecia.id_zajec%TYPE;
BEGIN
    typ_sali := znajdz_typ_sali(typ_zajec);
    
    wolny_termin := znajdz_wolny_termin(typ_sali);
    IF wolny_termin IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak wolnych terminów');
    END IF;
    
    nowe_id_zajec := zajecia_seq.NEXTVAL;
    INSERT INTO zajecia (id_zajec, typ_zajec, id_przedmiotu, id_pracownika, nr_sali, dzien_tygodnia, godz_rozpoczecia)
    VALUES (nowe_id_zajec, typ_zajec, id_przedmiotu, id_pracownika, wolny_termin.nr_sali, wolny_termin.dzien_tygodnia, wolny_termin.godz_rozpoczecia);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
CREATE OR REPLACE FUNCTION SZUKAJ_PRACOWNIKA (
    POCZATEK TIMESTAMP, 
    KONIEC TIMESTAMP
) RETURN INTEGER AS
    ID_PRACOWNIKA INTEGER;
BEGIN
    SELECT ID_PRACOWNIKA
    INTO ID_PRACOWNIKA
    FROM (
        SELECT Z.ID_PRACOWNIKA
        FROM ZAJECIA Z
        WHERE NOT EXISTS (
            SELECT 1
            FROM ZAJECIA Z1
            WHERE Z.ID_PRACOWNIKA = Z1.ID_PRACOWNIKA
            AND ((Z1.GODZ_ROZPOCZECIA BETWEEN POCZATEK AND KONIEC) OR 
                (Z1.GODZ_ZAKONCZENIA BETWEEN POCZATEK AND KONIEC) OR 
                (Z1.GODZ_ROZPOCZECIA <= POCZATEK AND Z1.GODZ_ZAKONCZENIA >= KONIEC))
        )
        GROUP BY Z.ID_PRACOWNIKA
        HAVING COUNT(*) < 6
        ORDER BY COUNT(*) ASC
    )
    WHERE ROWNUM = 1;
    
    RETURN ID_PRACOWNIKA;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END SZUKAJ_PRACOWNIKA;
/
