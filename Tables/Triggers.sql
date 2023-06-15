CREATE OR REPLACE FUNCTION kolizja_zajec(czas1_poczatek TIMESTAMP, czas1_koniec TIMESTAMP, czas2_poczatek TIMESTAMP, czas2_koniec TIMESTAMP) RETURN NUMBER AS
  wynik NUMBER;
BEGIN
  IF ((czas1_poczatek < czas2_koniec AND czas1_koniec > czas2_poczatek) OR
     (czas1_koniec > czas2_poczatek AND czas1_poczatek < czas2_koniec)) THEN
    wynik := 1;
  ELSE
    wynik := 0;
  END IF;
  RETURN wynik;
END kolizja_zajec;
/

CREATE OR REPLACE TRIGGER pracownik_w_zajeciach
BEFORE INSERT OR UPDATE ON zajecia
FOR EACH ROW
DECLARE
    istniejace_zajecia INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO istniejace_zajecia
    FROM zajecia
    WHERE id_pracownika = :NEW.id_pracownika AND
          dzien_tygodnia = :NEW.dzien_tygodnia AND
          kolizja_zajec(godz_rozpoczecia, godz_zakonczenia, :NEW.godz_rozpoczecia, :NEW.godz_zakonczenia) = 1;

    IF istniejace_zajecia > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Pracownik uczestniczy już w zajęciach w tym samym czasie');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER student_w_zajeciach
BEFORE INSERT OR UPDATE ON zajecia_studenta
FOR EACH ROW
DECLARE
    istniejace_zajecia INTEGER;
    nowe_zajecia_rozpoczecie TIMESTAMP;
    nowe_zajecia_zakonczenie TIMESTAMP;
BEGIN
    SELECT godz_rozpoczecia, godz_zakonczenia INTO nowe_zajecia_rozpoczecie, nowe_zajecia_zakonczenie FROM zajecia WHERE id_zajec = :NEW.id_zajec;
    SELECT COUNT(*)
    INTO istniejace_zajecia
    FROM zajecia_studenta zs
    JOIN zajecia z ON z.id_zajec = zs.id_zajec
    WHERE zs.nr_indeksu = :NEW.nr_indeksu AND
          z.dzien_tygodnia = (SELECT dzien_tygodnia FROM zajecia WHERE id_zajec = :NEW.id_zajec) AND
          kolizja_zajec(z.godz_rozpoczecia, z.godz_zakonczenia, nowe_zajecia_rozpoczecie, nowe_zajecia_zakonczenie) = 1;

    IF istniejace_zajecia > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Student uczestniczy już w zajęciach w tym samym czasie');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER zajecia_w_sali
BEFORE INSERT OR UPDATE ON zajecia
FOR EACH ROW
DECLARE
    istniejace_zajecia INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO istniejace_zajecia
    FROM zajecia
    WHERE nr_sali = :NEW.nr_sali AND
          dzien_tygodnia = :NEW.dzien_tygodnia AND
          kolizja_zajec(godz_rozpoczecia, godz_zakonczenia, :NEW.godz_rozpoczecia, :NEW.godz_zakonczenia) = 1;

    IF istniejace_zajecia > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'W sali odbywają się już zajęcia w tym samym czasie');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER zajecia_w_grupie
BEFORE INSERT OR UPDATE ON zajecia
FOR EACH ROW
DECLARE
    istniejace_zajecia INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO istniejace_zajecia
    FROM zajecia z
    JOIN przedmiot p ON p.id_przedmiotu = z.id_przedmiotu
    WHERE (z.nr_grupy = :NEW.nr_grupy OR p.typ = 'W') AND
          p.semestr = (SELECT semestr FROM przedmiot WHERE id_przedmiotu = :NEW.id_przedmiotu) AND
          z.dzien_tygodnia = :NEW.dzien_tygodnia AND
          kolizja_zajec(z.godz_rozpoczecia, z.godz_zakonczenia, :NEW.godz_rozpoczecia, :NEW.godz_zakonczenia) = 1;

    IF istniejace_zajecia > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Dla tej samej grupy i semestru lub w czasie wykładu odbywają się już zajęcia');
    END IF;
END;
/


