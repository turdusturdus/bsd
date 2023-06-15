CREATE OR REPLACE PACKAGE queries AS

PROCEDURE zajecia_studenta(p_id_studenta INTEGER);
PROCEDURE zajecia_pracownika(p_id_pracownika INTEGER);
PROCEDURE studenci_na_zajeciach(p_id_zajec INTEGER);
PROCEDURE studenci_semestr_kierunek(p_semestr INTEGER, p_id_kierunku INTEGER);
PROCEDURE zajecia_w_sali(p_nr_sali VARCHAR2);
PROCEDURE pracownicy_studenta(p_id_studenta INTEGER);

END queries;
/

CREATE OR REPLACE PACKAGE BODY queries AS

PROCEDURE zajecia_studenta(p_id_studenta INTEGER) IS
BEGIN
    SELECT z.*, p.*
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu
    JOIN zajecia_studenta zs ON z.id_zajec = zs.id_zajec
    WHERE zs.nr_indeksu = p_id_studenta;
END zajecia_studenta;

PROCEDURE zajecia_pracownika(p_id_pracownika INTEGER) IS
BEGIN
    SELECT z.*, p.*
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu
    WHERE z.id_pracownika = p_id_pracownika;
END zajecia_pracownika;

PROCEDURE studenci_na_zajeciach(p_id_zajec INTEGER) IS
BEGIN
    SELECT s.*
    FROM student s
    JOIN zajecia_studenta zs ON s.nr_indeksu = zs.nr_indeksu
    WHERE zs.id_zajec = p_id_zajec;
END studenci_na_zajeciach;

PROCEDURE studenci_semestr_kierunek(p_semestr INTEGER, p_id_kierunku INTEGER) IS
BEGIN
    SELECT s.*
    FROM student s
    JOIN przedmiot p ON s.semestr = p.semestr
    WHERE p.semestr = p_semestr AND p.id_kierunku = p_id_kierunku;
END studenci_semestr_kierunek;

PROCEDURE zajecia_w_sali(p_nr_sali VARCHAR2) IS
BEGIN
    SELECT z.*, p.*
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu
    WHERE z.nr_sali = p_nr_sali;
END zajecia_w_sali;

PROCEDURE pracownicy_studenta(p_id_studenta INTEGER) IS
BEGIN
    SELECT DISTINCT pr.*
    FROM pracownik pr
    JOIN zajecia z ON pr.id_pracownika = z.id_pracownika
    JOIN zajecia_studenta zs ON z.id_zajec = zs.id_zajec
    WHERE zs.nr_indeksu = p_id_studenta;
END pracownicy_studenta;

END queries;
/
