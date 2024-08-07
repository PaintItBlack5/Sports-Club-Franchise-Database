CREATE OR REPLACE TRIGGER auto_increm_cod_abb
BEFORE INSERT ON abbonato
FOR EACH ROW
BEGIN
  SELECT cod_abb_seq.NEXTVAL
  INTO :NEW.codice_abbonamento
  FROM DUAL;
END;
/
