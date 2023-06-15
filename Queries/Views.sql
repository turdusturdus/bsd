CREATE OR REPLACE VIEW zajecia_studenta_vw AS
    SELECT z.id_zajec, z.godz_rozpoczecia, z.godz_zakonczenia, z.dzien_tygodnia, z.nr_sali, z.nr_grupy, p.id_przedmiotu, p.nazwa, p.typ, zs.nr_indeksu
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu
    JOIN zajecia_studenta zs ON z.id_zajec = zs.id_zajec;

CREATE OR REPLACE VIEW zajecia_pracownika_vw AS
    SELECT z.id_zajec, z.godz_rozpoczecia, z.godz_zakonczenia, z.dzien_tygodnia, z.nr_sali, z.nr_grupy, p.id_przedmiotu, p.nazwa, p.typ, z.id_pracownika
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu;

CREATE VIEW zajecia_w_sali_vw AS
    SELECT z.id_zajec, z.godz_rozpoczecia, z.godz_zakonczenia, z.dzien_tygodnia, z.nr_sali, z.nr_grupy, p.id_przedmiotu, p.nazwa, p.typ
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu;

CREATE OR REPLACE VIEW pracownik_student_vw AS
    SELECT DISTINCT pr.*, zs.nr_indeksu
    FROM pracownik pr
    JOIN zajecia z ON pr.id_pracownika = z.id_pracownika
    JOIN zajecia_studenta zs ON z.id_zajec = zs.id_zajec;
    
CREATE OR REPLACE VIEW zajecia_wg_typu_vw AS
    SELECT z.*, p.typ
    FROM zajecia z
    JOIN przedmiot p ON z.id_przedmiotu = p.id_przedmiotu;