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