CREATE OR REPLACE PACKAGE simple_insert IS

  PROCEDURE dodaj_budynek (nazwa_budynku VARCHAR2);
  
  PROCEDURE dodaj_sala (nr_sali VARCHAR2, typ_sali VARCHAR2, nazwa_budynku VARCHAR2);
  
  PROCEDURE dodaj_kierunek (nazwa_kierunku VARCHAR2);
  
  PROCEDURE dodaj_przedmiot (nazwa_przedmiotu VARCHAR2, typ_przedmiotu VARCHAR2, semestr_przedmiotu NUMBER, nazwa_kierunku VARCHAR2);
  
  PROCEDURE dodaj_pracownika (imie_nazwisko VARCHAR2, czy_etatowy CHAR);
  
  PROCEDURE dodaj_zajecia (godz_rozpoczecia TIMESTAMP, godz_zakonczenia TIMESTAMP, dzien_tygodnia INTEGER, nr_grupy INTEGER, nr_sali VARCHAR2, nazwa_przedmiotu VARCHAR2, imie_nazwisko VARCHAR2);

END simple_insert;

/

create or replace PACKAGE BODY simple_insert IS

  PROCEDURE dodaj_budynek (nazwa_budynku VARCHAR2)
  AS
  BEGIN
      INSERT INTO budynek (id_budynku, nazwa)
      VALUES (budynek_seq.NEXTVAL, nazwa_budynku);
  END dodaj_budynek;

  PROCEDURE dodaj_sala (nr_sali VARCHAR2, typ_sali VARCHAR2, nazwa_budynku VARCHAR2)
  AS
      id_budynku NUMBER;
  BEGIN
      SELECT id_budynku INTO id_budynku FROM budynek WHERE nazwa = nazwa_budynku;
      INSERT INTO sala (nr_sali, typ, id_budynku)
      VALUES (sala_seq.NEXTVAL, typ_sali, id_budynku);
  END dodaj_sala;

  PROCEDURE dodaj_kierunek (nazwa_kierunku VARCHAR2)
  AS
  BEGIN
      INSERT INTO kierunek (id_kierunku, nazwa)
      VALUES (kierunek_seq.NEXTVAL, nazwa_kierunku);
  END dodaj_kierunek;

  PROCEDURE dodaj_przedmiot (nazwa_przedmiotu VARCHAR2, typ_przedmiotu VARCHAR2, semestr_przedmiotu NUMBER, nazwa_kierunku VARCHAR2)
  AS
      id_kierunku NUMBER;
  BEGIN
      SELECT id_kierunku INTO id_kierunku FROM kierunek WHERE nazwa = nazwa_kierunku;
      INSERT INTO przedmiot (id_przedmiotu, nazwa, typ, semestr, id_kierunku)
      VALUES (przedmiot_seq.NEXTVAL, nazwa_przedmiotu, typ_przedmiotu, semestr_przedmiotu, id_kierunku);
  END dodaj_przedmiot;

  PROCEDURE dodaj_pracownika (imie_nazwisko VARCHAR2, czy_etatowy CHAR)
  AS
  BEGIN
      INSERT INTO pracownik (id_pracownika, imie_nazwisko, czy_etatowy)
      VALUES (pracownik_seq.NEXTVAL, imie_nazwisko, czy_etatowy);
  END dodaj_pracownika;

   PROCEDURE dodaj_zajecia (godz_rozpoczecia TIMESTAMP, godz_zakonczenia TIMESTAMP, dzien_tygodnia INTEGER, nr_grupy INTEGER, nr_sali VARCHAR2, nazwa_przedmiotu VARCHAR2, imie_nazwisko VARCHAR2)
  AS
      id_przedmiotu NUMBER;
      id_pracownika NUMBER;
  BEGIN
      SELECT id_przedmiotu INTO id_przedmiotu FROM przedmiot WHERE nazwa = nazwa_przedmiotu;
      SELECT id_pracownika INTO id_pracownika FROM pracownik WHERE imie_nazwisko = imie_nazwisko;
      
      INSERT INTO zajecia (id_zajec, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, nr_grupy, nr_sali, id_przedmiotu, id_pracownika)
      VALUES (zajecia_seq.NEXTVAL, godz_rozpoczecia, godz_zakonczenia, dzien_tygodnia, nr_grupy, nr_sali, id_przedmiotu, id_pracownika);
  END dodaj_zajecia;

END simple_insert;
/