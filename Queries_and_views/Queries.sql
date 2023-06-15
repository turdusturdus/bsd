DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_studenta_vw%ROWTYPE;
  start_time NUMBER;
  end_time NUMBER;
BEGIN
  start_time := DBMS_UTILITY.GET_TIME;
  ref_cur := selectors.zajecia_studenta(2479);
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
  end_time := DBMS_UTILITY.GET_TIME;
  dbms_output.put_line('Elapsed time: ' || TO_CHAR(end_time - start_time) || ' centiseconds.');
END;

DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_w_sali_vw%ROWTYPE;
  start_time NUMBER;
  end_time NUMBER;
BEGIN
  start_time := DBMS_UTILITY.GET_TIME;
  ref_cur := selectors.zajecia_w_sali('61');
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
  end_time := DBMS_UTILITY.GET_TIME;
  dbms_output.put_line('Elapsed time: ' || TO_CHAR(end_time - start_time) || ' centiseconds.');
END;


DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_pracownika_vw%ROWTYPE;
  start_time NUMBER;
  end_time NUMBER;
BEGIN
  start_time := DBMS_UTILITY.GET_TIME;
  ref_cur := selectors.zajecia_pracownika(1); -- Wprowadź prawidłowy id_pracownika
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
  end_time := DBMS_UTILITY.GET_TIME;
  dbms_output.put_line('Elapsed time: ' || TO_CHAR(end_time - start_time) || ' centiseconds.');
END;

DECLARE
  ref_cur SYS_REFCURSOR;
  z_row pracownik_student_vw%ROWTYPE;
  start_time NUMBER;
  end_time NUMBER;
BEGIN
  start_time := DBMS_UTILITY.GET_TIME;
  ref_cur := selectors.pracownik_student(2479);
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.imie_nazwisko);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
  end_time := DBMS_UTILITY.GET_TIME;
  dbms_output.put_line('Elapsed time: ' || TO_CHAR(end_time - start_time) || ' centiseconds.');
END;


