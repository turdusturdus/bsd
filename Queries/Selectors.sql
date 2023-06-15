CREATE OR REPLACE PACKAGE selectors AS

  FUNCTION zajecia_studenta(p_id_studenta INTEGER) RETURN SYS_REFCURSOR;
  FUNCTION zajecia_pracownika(p_id_pracownika INTEGER) RETURN SYS_REFCURSOR;
  FUNCTION zajecia_w_sali(p_nr_sali VARCHAR2) RETURN SYS_REFCURSOR;
  FUNCTION pracownik_student(p_id_studenta INTEGER) RETURN SYS_REFCURSOR;
  FUNCTION zajecia_wg_typu(p_typ VARCHAR2) RETURN SYS_REFCURSOR;

END selectors;
/

CREATE OR REPLACE PACKAGE BODY selectors AS

  FUNCTION zajecia_studenta(p_id_studenta INTEGER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM zajecia_studenta_vw WHERE nr_indeksu = p_id_studenta;
    RETURN v_cursor;
  END zajecia_studenta;

  FUNCTION zajecia_pracownika(p_id_pracownika INTEGER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM zajecia_pracownika_vw WHERE id_pracownika = p_id_pracownika;
    RETURN v_cursor;
  END zajecia_pracownika;

  FUNCTION zajecia_w_sali(p_nr_sali VARCHAR2) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM zajecia_w_sali_vw WHERE nr_sali = p_nr_sali;
    RETURN v_cursor;
  END zajecia_w_sali;

  FUNCTION pracownik_student(p_id_studenta INTEGER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM pracownik_student_vw WHERE nr_indeksu = p_id_studenta;
    RETURN v_cursor;
  END pracownik_student;

  FUNCTION zajecia_wg_typu(p_typ VARCHAR2) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM zajecia_wg_typu_vw WHERE typ = p_typ;
    RETURN v_cursor;
  END zajecia_wg_typu;

END selectors;
/
