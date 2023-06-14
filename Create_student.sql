CREATE OR REPLACE PACKAGE manage_student AS
    PROCEDURE stworz_studenta(p_semestr INTEGER);
    PROCEDURE przypisz_studenta(p_indeks INTEGER, p_grupa INTEGER, p_semestr INTEGER, p_kierunek VARCHAR2);
    PROCEDURE dodaj_studentow_i_przypisz(p_grupa INTEGER, p_semestr INTEGER, p_kierunek VARCHAR2);
    PROCEDURE dodaj_studentow_all(p_parzysty BOOLEAN);
END manage_student;
/

CREATE OR REPLACE PACKAGE BODY manage_student AS
    PROCEDURE stworz_studenta(p_semestr INTEGER) IS
        v_indeks student.nr_indeksu%TYPE;
        v_imie_nazwisko student.imie_nazwisko%TYPE;
    BEGIN
        v_indeks := student_seq.NEXTVAL;
        v_imie_nazwisko := 'Student '||TO_CHAR(student_seq.CURRVAL);
        INSERT INTO student(nr_indeksu, imie_nazwisko, semestr) 
        VALUES (v_indeks, v_imie_nazwisko, p_semestr);
    END stworz_studenta;
    
    PROCEDURE przypisz_studenta(p_indeks INTEGER, p_grupa INTEGER, p_semestr INTEGER, p_kierunek VARCHAR2) IS
        CURSOR zajecia_cursor IS
            SELECT z.id_zajec
            FROM zajecia z
            JOIN przedmiot p ON p.id_przedmiotu = z.id_przedmiotu
            JOIN kierunek k ON k.id_kierunku = p.id_kierunku
            WHERE (z.nr_grupy = p_grupa OR p.typ = 'W') AND p.semestr = p_semestr AND k.nazwa = p_kierunek;
        v_id_zajec zajecia.id_zajec%TYPE;
    BEGIN
        OPEN zajecia_cursor;
        LOOP
            FETCH zajecia_cursor INTO v_id_zajec;
            EXIT WHEN zajecia_cursor%NOTFOUND;
            INSERT INTO zajecia_studenta(id_zajec, nr_indeksu) VALUES (v_id_zajec, p_indeks);
        END LOOP;
        CLOSE zajecia_cursor;
    END przypisz_studenta;
    
    PROCEDURE dodaj_studentow_i_przypisz(p_grupa INTEGER, p_semestr INTEGER, p_kierunek VARCHAR2) IS
    BEGIN
        FOR i IN 1..30 LOOP
            stworz_studenta(p_semestr);
            przypisz_studenta(student_seq.CURRVAL, p_grupa, p_semestr, p_kierunek);
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Nieoczekiwany błąd: '||SQLCODE||', '||SQLERRM);
    END dodaj_studentow_i_przypisz;
    
    PROCEDURE dodaj_studentow_all(p_parzysty BOOLEAN) IS
        CURSOR sem_gr_kier_cursor IS
          SELECT DISTINCT p.semestr, z.nr_grupy, k.nazwa
          FROM przedmiot p
          JOIN kierunek k ON k.id_kierunku = p.id_kierunku
          JOIN zajecia z ON z.id_przedmiotu = p.id_przedmiotu
          WHERE z.nr_grupy IS NOT NULL;
        v_semestr przedmiot.semestr%TYPE;
        v_grupa zajecia.nr_grupy%TYPE;
        v_kierunek kierunek.nazwa%TYPE;
    BEGIN
        OPEN sem_gr_kier_cursor;
        LOOP
            FETCH sem_gr_kier_cursor INTO v_semestr, v_grupa, v_kierunek;
            EXIT WHEN sem_gr_kier_cursor%NOTFOUND;
            IF p_parzysty AND MOD(v_semestr, 2) = 0 THEN
                dodaj_studentow_i_przypisz(v_grupa, v_semestr, v_kierunek);
            ELSIF NOT p_parzysty AND MOD(v_semestr, 2) = 1 THEN
                dodaj_studentow_i_przypisz(v_grupa, v_semestr, v_kierunek);
            END IF;
        END LOOP;
        CLOSE sem_gr_kier_cursor;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Nieoczekiwany błąd: '||SQLCODE||', '||SQLERRM);
    END dodaj_studentow_all;
    
END manage_student;
/

