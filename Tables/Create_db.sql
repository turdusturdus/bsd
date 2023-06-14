CREATE TABLE budynek (
    id_budynku INTEGER NOT NULL,
    nazwa      VARCHAR2(50)
);

ALTER TABLE budynek ADD CONSTRAINT budynek_pk PRIMARY KEY ( id_budynku );

CREATE TABLE kierunek (
    id_kierunku INTEGER NOT NULL,
    nazwa       VARCHAR2(100) NOT NULL
);

ALTER TABLE kierunek ADD CONSTRAINT kierunek_pk PRIMARY KEY ( id_kierunku );

CREATE TABLE pracownik (
    id_pracownika INTEGER NOT NULL,
    imie_nazwisko VARCHAR2(50) NOT NULL,
    czy_etatowy   CHAR(1)
);

ALTER TABLE pracownik
    ADD CHECK ( czy_etatowy IN ( 'F', 'T' ) );

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( id_pracownika );

CREATE TABLE przedmiot (
    id_przedmiotu INTEGER NOT NULL,
    nazwa         VARCHAR2(50) NOT NULL,
    typ           VARCHAR2(5) NOT NULL,
    semestr       INTEGER NOT NULL,
    id_kierunku   INTEGER NOT NULL
);

ALTER TABLE przedmiot
    ADD CHECK ( typ IN ( 'CW', 'L', 'LEK', 'PS', 'SEM',
                         'W' ) );

ALTER TABLE przedmiot ADD CONSTRAINT przedmiot_pk PRIMARY KEY ( id_przedmiotu );

CREATE TABLE sala (
    nr_sali    VARCHAR2(10) NOT NULL,
    typ        VARCHAR2(20),
    id_budynku INTEGER NOT NULL
);

ALTER TABLE sala
    ADD CHECK ( typ IN ( 'cwiczeniowa', 'komputerowa', 'laboratoryjna', 'wykladowa' ) );

ALTER TABLE sala ADD CONSTRAINT sala_pk PRIMARY KEY ( nr_sali );

CREATE TABLE student (
    nr_indeksu    INTEGER NOT NULL,
    imie_nazwisko VARCHAR2(50) NOT NULL,
    semestr       INTEGER
);

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( nr_indeksu );

CREATE TABLE zajecia (
    id_zajec         INTEGER NOT NULL,
    godz_rozpoczecia TIMESTAMP NOT NULL,
    godz_zakonczenia TIMESTAMP NOT NULL,
    dzien_tygodnia   INTEGER NOT NULL,
    nr_grupy         INTEGER,
    nr_sali          VARCHAR2(10) NOT NULL,
    id_przedmiotu    INTEGER NOT NULL,
    id_pracownika    INTEGER NOT NULL
);

ALTER TABLE zajecia
    ADD CHECK ( dzien_tygodnia IN ( 1, 2, 3, 4, 5,
                                    6, 7 ) );

ALTER TABLE zajecia ADD CONSTRAINT zajecia_pk PRIMARY KEY ( id_zajec );

CREATE TABLE zajecia_studenta (
    id_zajec   INTEGER NOT NULL,
    nr_indeksu INTEGER NOT NULL
);

ALTER TABLE zajecia_studenta ADD CONSTRAINT zajecia_studenta_pk PRIMARY KEY ( id_zajec,
                                                                              nr_indeksu );

ALTER TABLE przedmiot
    ADD CONSTRAINT przedmiot_kierunek_fk FOREIGN KEY ( id_kierunku )
        REFERENCES kierunek ( id_kierunku );
ALTER TABLE sala
    ADD CONSTRAINT sala_budynek_fk FOREIGN KEY ( id_budynku )
        REFERENCES budynek ( id_budynku );

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_pracownik_fk FOREIGN KEY ( id_pracownika )
        REFERENCES pracownik ( id_pracownika );

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_przedmiot_fk FOREIGN KEY ( id_przedmiotu )
        REFERENCES przedmiot ( id_przedmiotu );

ALTER TABLE zajecia
    ADD CONSTRAINT zajecia_sala_fk FOREIGN KEY ( nr_sali )
        REFERENCES sala ( nr_sali );

ALTER TABLE zajecia_studenta
    ADD CONSTRAINT zajecia_student_fk FOREIGN KEY ( nr_indeksu )
        REFERENCES student ( nr_indeksu );

ALTER TABLE zajecia_studenta
    ADD CONSTRAINT zajecia_zajecia_fk FOREIGN KEY ( id_zajec )
        REFERENCES zajecia ( id_zajec );

ALTER TABLE zajecia
    ADD CONSTRAINT check_time CHECK (
        EXTRACT(HOUR FROM godz_rozpoczecia) >= 8 AND
        EXTRACT(HOUR FROM godz_rozpoczecia) <= 19 AND
        (EXTRACT(HOUR FROM godz_rozpoczecia) != 19 OR EXTRACT(MINUTE FROM godz_rozpoczecia) <= 30)
    );

ALTER TABLE zajecia
    ADD CONSTRAINT check_duration CHECK (
        godz_zakonczenia = godz_rozpoczecia + INTERVAL '90' MINUTE
    );

ALTER TABLE zajecia
    ADD CONSTRAINT unique_przedmiot_grupa UNIQUE (id_przedmiotu, nr_grupy);

