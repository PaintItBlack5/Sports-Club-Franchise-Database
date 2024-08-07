CREATE OR REPLACE TRIGGER eta_persona
BEFORE INSERT OR UPDATE ON PERSONA
FOR EACH ROW

DECLARE
	errore_eta_6 EXCEPTION;
	errore_eta_100 EXCEPTION;

BEGIN
	
	IF(MONTHS_BETWEEN(SYSDATE,:NEW.data_nascita)<72) THEN
		RAISE errore_eta_6;
	ELSIF (MONTHS_BETWEEN(SYSDATE,:NEW.data_nascita)>1200) THEN
		RAISE errore_eta_100;
	END IF;

EXCEPTION
WHEN errore_eta_6 THEN
	RAISE_APPLICATION_ERROR('-20001','ERRORE ETA: la persona ha meno di 6 anni!');
WHEN errore_eta_100 THEN
	RAISE_APPLICATION_ERROR('-20002','ERRORE ETA: la persona ha più di 100 anni!');

END;
/