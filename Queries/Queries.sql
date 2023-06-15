DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_studenta_vw%ROWTYPE;
BEGIN
  ref_cur := selectors.zajecia_studenta(2479);
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
END;

DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_w_sali_vw%ROWTYPE;
BEGIN
  ref_cur := selectors.zajecia_w_sali('61');
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
END;


DECLARE
  ref_cur SYS_REFCURSOR;
  z_row zajecia_pracownika_vw%ROWTYPE;
BEGIN
  ref_cur := selectors.zajecia_pracownika(1);
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.nazwa || ' ' || z_row.godz_rozpoczecia || '-' || z_row.godz_zakonczenia);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;

END;

DECLARE
  ref_cur SYS_REFCURSOR;
  z_row pracownik_student_vw%ROWTYPE;
BEGIN
  ref_cur := selectors.pracownik_student(2479);
  FETCH ref_cur INTO z_row;
  WHILE ref_cur%FOUND LOOP
    dbms_output.put_line(z_row.imie_nazwisko);
    FETCH ref_cur INTO z_row;
  END LOOP;
  CLOSE ref_cur;
END;

DECLARE
  v_cursor SYS_REFCURSOR;
  v_result zajecia_wg_typu_vw%ROWTYPE;
BEGIN
  v_cursor := selectors.zajecia_wg_typu('CW');
  LOOP
    FETCH v_cursor INTO v_result;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('ID zajęć: ' || v_result.id_zajec || ', Typ: ' || v_result.typ);
  END LOOP;
  CLOSE v_cursor;
END;
/



