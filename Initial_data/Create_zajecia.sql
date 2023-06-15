CREATE OR REPLACE PACKAGE manage_zajecia AS

  FUNCTION mapuj_typ_przedmiotu_na_sale (typ_przedmiotu VARCHAR2) RETURN VARCHAR2;

  PROCEDURE utworz_zajecia (dzien_tygodnia INTEGER, godz_rozpoczecia TIMESTAMP);

  PROCEDURE utworz_zajecia_dla_przedmiotow (
    typ_przedmiotu VARCHAR2,
    nazwa_kierunku VARCHAR2,
    dzien_tygodnia INTEGER,
    godz_rozpoczecia TIMESTAMP
  );

END manage_zajecia;
/

CREATE OR REPLACE PACKAGE BODY manage_zajecia AS

  FUNCTION mapuj_typ_przedmiotu_na_sale (typ_przedmiotu VARCHAR2) RETURN VARCHAR2
  AS
  BEGIN
    CASE typ_przedmiotu
      WHEN 'W' THEN RETURN 'wykladowa';
      WHEN 'CW' THEN RETURN 'cwiczeniowa';
      WHEN 'PS' THEN RETURN 'komputerowa';
      WHEN 'L' THEN RETURN 'laboratoryjna';
      ELSE RETURN NULL;
    END CASE;
  END mapuj_typ_przedmiotu_na_sale;

  PROCEDURE utworz_zajecia (dzien_tygodnia INTEGER, godz_rozpoczecia TIMESTAMP)
AS
  CURSOR pracownicy_cur IS
    SELECT id_pracownika
    FROM pracownik;

  CURSOR sale_cur IS
    SELECT nr_sali
    FROM sala
    WHERE typ = 'wykladowa';

  CURSOR przedmioty_cur IS
    SELECT id_przedmiotu
    FROM przedmiot
    WHERE typ = 'W';

  pracownik pracownicy_cur%ROWTYPE;
  sala sale_cur%ROWTYPE;
  przedmiot przedmioty_cur%ROWTYPE;
  godz_zakonczenia TIMESTAMP := godz_rozpoczecia + INTERVAL '90' MINUTE;
BEGIN
  OPEN pracownicy_cur;
  OPEN sale_cur;
  OPEN przedmioty_cur;

  FETCH pracownicy_cur INTO pracownik;
  FETCH sale_cur INTO sala;
  FETCH przedmioty_cur INTO przedmiot;
  
  WHILE pracownicy_cur%FOUND AND sale_cur%FOUND AND przedmioty_cur%FOUND
  LOOP
    INSERT INTO zajecia (id_zajec, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, nr_sali, id_przedmiotu, id_pracownika)
    VALUES (zajecia_seq.NEXTVAL, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, sala.nr_sali, przedmiot.id_przedmiotu, pracownik.id_pracownika);

    FETCH pracownicy_cur INTO pracownik;
    FETCH sale_cur INTO sala;
    FETCH przedmioty_cur INTO przedmiot;
  END LOOP;

  CLOSE pracownicy_cur;
  CLOSE sale_cur;
  CLOSE przedmioty_cur;

END utworz_zajecia;

  PROCEDURE utworz_zajecia_dla_przedmiotow (
    typ_przedmiotu VARCHAR2,
    nazwa_kierunku VARCHAR2,
    dzien_tygodnia INTEGER,
    godz_rozpoczecia TIMESTAMP
  )
  AS
    typ_sali VARCHAR2(20) := mapuj_typ_przedmiotu_na_sale(typ_przedmiotu);

    CURSOR pracownicy_cur IS
      SELECT id_pracownika
      FROM pracownik;

    CURSOR sale_cur IS
      SELECT nr_sali
      FROM sala
      WHERE typ = typ_sali;

    CURSOR przedmioty_cur IS
      SELECT id_przedmiotu
      FROM przedmiot
      WHERE typ = typ_przedmiotu AND id_kierunku = (SELECT id_kierunku FROM kierunek WHERE nazwa = nazwa_kierunku);

    pracownik pracownicy_cur%ROWTYPE;
    sala sale_cur%ROWTYPE;
    przedmiot przedmioty_cur%ROWTYPE;
    godz_zakonczenia TIMESTAMP := godz_rozpoczecia + INTERVAL '90' MINUTE;
  BEGIN
    OPEN pracownicy_cur;
    OPEN sale_cur;
    OPEN przedmioty_cur;

    FETCH przedmioty_cur INTO przedmiot;
    
    WHILE przedmioty_cur%FOUND
    LOOP
      FOR nr_grupy IN 1..3
      LOOP
        FETCH pracownicy_cur INTO pracownik;
        FETCH sale_cur INTO sala;
        
        IF NOT pracownicy_cur%FOUND THEN
          CLOSE pracownicy_cur;
          CLOSE sale_cur;
          CLOSE przedmioty_cur;
          RAISE_APPLICATION_ERROR(-20001, 'Brak wystarczajacej liczby pracownikow');
        END IF;

        IF NOT sale_cur%FOUND THEN
          CLOSE pracownicy_cur;
          CLOSE sale_cur;
          CLOSE przedmioty_cur;
          RAISE_APPLICATION_ERROR(-20002, 'Brak wystarczajacej liczby sal');
        END IF;

        INSERT INTO zajecia (id_zajec, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, nr_grupy, nr_sali, id_przedmiotu, id_pracownika)
        VALUES (zajecia_seq.NEXTVAL, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, nr_grupy, sala.nr_sali, przedmiot.id_przedmiotu, pracownik.id_pracownika);
      END LOOP;

      FETCH przedmioty_cur INTO przedmiot;
    END LOOP;

    CLOSE pracownicy_cur;
    CLOSE sale_cur;
    CLOSE przedmioty_cur;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Brak wystarczajacej liczby przedmiotow, sal lub pracownikow');
  END utworz_zajecia_dla_przedmiotow;

END manage_zajecia;
/

