CREATE OR REPLACE TRIGGER auto_increm_id_scontr
BEFORE INSERT ON vendita
FOR EACH ROW
BEGIN
  SELECT id_scontrino_seq.NEXTVAL
  INTO :NEW.id_scontrino
  FROM DUAL;
END;
/