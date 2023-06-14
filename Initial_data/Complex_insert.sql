CREATE OR REPLACE PACKAGE complex_insert IS
  PROCEDURE dodaj_sale (liczba_sal NUMBER, nazwa_budynku VARCHAR2);
  
  PROCEDURE dodaj_przedmioty (liczba_przedmiotow NUMBER, nazwa_kierunku VARCHAR2);

  PROCEDURE dodaj_pracownikow (liczba_pracownikow NUMBER);
  
END complex_insert;

/

create or replace PACKAGE BODY complex_insert IS
  PROCEDURE dodaj_sale (liczba_sal NUMBER, nazwa_budynku VARCHAR2)
  AS
  BEGIN
      FOR i IN 1..liczba_sal LOOP
          simple_insert.dodaj_sala(TO_CHAR(i), CASE MOD(i, 4) WHEN 0 THEN 'wykladowa' WHEN 1 THEN 'laboratoryjna' WHEN 2 THEN 'komputerowa' ELSE 'cwiczeniowa' END, nazwa_budynku);
      END LOOP;
  END dodaj_sale;

  PROCEDURE dodaj_przedmioty (liczba_przedmiotow NUMBER, nazwa_kierunku VARCHAR2)
  AS
  BEGIN
      FOR semestr IN 1..6 LOOP
          -- Warunek sprawdzający czy semestr jest nieparzysty.
          IF MOD(semestr, 2) = 1 THEN
              FOR przedmiot IN 1..liczba_przedmiotow LOOP
                  simple_insert.dodaj_przedmiot('Przedmiot ' || TO_CHAR(przedmiot) || TO_CHAR(semestr) || SUBSTR(nazwa_kierunku, -1), CASE MOD(przedmiot, 3) WHEN 0 THEN 'L' WHEN 1 THEN 'CW' ELSE 'W' END, semestr, nazwa_kierunku);
              END LOOP;
          END IF;
      END LOOP;
  END dodaj_przedmioty;

  PROCEDURE dodaj_pracownikow (liczba_pracownikow NUMBER)
  AS
  BEGIN
      FOR i IN 1..liczba_pracownikow LOOP
          INSERT INTO pracownik (id_pracownika, imie_nazwisko, czy_etatowy)
          VALUES (pracownik_seq.NEXTVAL, 'Pracownik ' || TO_CHAR(i), 'T');
      END LOOP;
  END dodaj_pracownikow;

END complex_insert;
/