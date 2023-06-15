BEGIN
  simple_insert.dodaj_budynek('Budynek A');
  simple_insert.dodaj_budynek('Budynek B');
  complex_insert.dodaj_sale(40, 'Budynek A');
  complex_insert.dodaj_sale(40, 'Budynek B');
END;

BEGIN
  simple_insert.dodaj_kierunek('Kierunek A');
  simple_insert.dodaj_kierunek('Kierunek B');
  simple_insert.dodaj_kierunek('Kierunek C');
  complex_insert.dodaj_przedmioty(3, 'Kierunek A');
  complex_insert.dodaj_przedmioty(3, 'Kierunek B');
  complex_insert.dodaj_przedmioty(3, 'Kierunek C');
END;

BEGIN
    complex_insert.dodaj_pracownikow(12);
END;

BEGIN
  create_zajecia.utworz_wyklady(1, TIMESTAMP '2023-06-19 8:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('CW', 'Kierunek A', 1, TIMESTAMP '2023-06-19 10:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('L', 'Kierunek A', 1, TIMESTAMP '2023-06-19 12:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('PS', 'Kierunek A', 1, TIMESTAMP '2023-06-19 14:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('CW', 'Kierunek B', 1, TIMESTAMP '2023-06-19 16:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('L', 'Kierunek B', 1, TIMESTAMP '2023-06-19 18:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('PS', 'Kierunek B', 2, TIMESTAMP '2023-06-19 8:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('CW', 'Kierunek C', 2, TIMESTAMP '2023-06-19 10:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('L', 'Kierunek C', 2, TIMESTAMP '2023-06-19 12:00:00');
  create_zajecia.utworz_zajecia_dla_przedmiotow('PS', 'Kierunek C', 2, TIMESTAMP '2023-06-19 14:00:00');
END;

BEGIN
    create_student.dodaj_studentow_all(FALSE);
END;

SELECT 
    (SELECT COUNT(*) FROM kierunek) +
    (SELECT COUNT(*) FROM przedmiot) +
    (SELECT COUNT(*) FROM pracownik) +
    (SELECT COUNT(*) FROM budynek) +
    (SELECT COUNT(*) FROM sala) +
    (SELECT COUNT(*) FROM zajecia) +
    (SELECT COUNT(*) FROM zajecia_studenta) +
    (SELECT COUNT(*) FROM student) AS suma_rekordow
FROM dual;


