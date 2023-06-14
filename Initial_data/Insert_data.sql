BEGIN
  dodawanie_tabel.dodaj_budynek('Budynek A');
  dodawanie_tabel.dodaj_sale(40, 'Budynek A');
  dodawanie_tabel.dodaj_budynek('Budynek B');
  dodawanie_tabel.dodaj_sale(40, 'Budynek B');
END;

BEGIN
  simple_insert.dodaj_kierunek('Kierunek A');
  complex_insert.dodaj_przedmioty(3, 'Kierunek A');
  simple_insert.dodaj_kierunek('Kierunek B');
  complex_insert.dodaj_przedmioty(3, 'Kierunek B');
  simple_insert.dodaj_kierunek('Kierunek C');
  complex_insert.dodaj_przedmioty(3, 'Kierunek C');
END;

BEGIN
    complex_insert.dodaj_pracownikow(12);
END;

BEGIN
  utworz_zajecia(1, TIMESTAMP '2023-06-19 8:00:00')
  utworz_zajecia_dla_przedmiotow('CW', 'Kierunek A', 1, TIMESTAMP '2023-06-19 10:00:00');
  utworz_zajecia_dla_przedmiotow('L', 'Kierunek A', 1, TIMESTAMP '2023-06-19 12:00:00');
  utworz_zajecia_dla_przedmiotow('PS', 'Kierunek A', 1, TIMESTAMP '2023-06-19 14:00:00');
  utworz_zajecia_dla_przedmiotow('CW', 'Kierunek B', 1, TIMESTAMP '2023-06-19 16:00:00');
  utworz_zajecia_dla_przedmiotow('L', 'Kierunek B', 1, TIMESTAMP '2023-06-19 18:00:00');
  utworz_zajecia_dla_przedmiotow('PS', 'Kierunek B', 2, TIMESTAMP '2023-06-19 8:00:00');
  utworz_zajecia_dla_przedmiotow('CW', 'Kierunek C', 2, TIMESTAMP '2023-06-19 10:00:00');
  utworz_zajecia_dla_przedmiotow('L', 'Kierunek C', 2, TIMESTAMP '2023-06-19 12:00:00');
  utworz_zajecia_dla_przedmiotow('PS', 'Kierunek C', 2, TIMESTAMP '2023-06-19 14:00:00');
END;

BEGIN
    manage_student.dodaj_studentow_all(0)
END;


