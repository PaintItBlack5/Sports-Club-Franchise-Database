CREATE OR REPLACE TRIGGER tempo_prenotazioni
BEFORE INSERT ON prenotazione
FOR EACH ROW

DECLARE
  errore_prenotazione EXCEPTION;

BEGIN

	IF(SYSDATE > :NEW.data_inizio_attivita ) THEN
		RAISE errore_prenotazione;
	END IF;

EXCEPTION
WHEN errore_prenotazione THEN
	RAISE_APPLICATION_ERROR('-20004','ERRORE PRENOTAZIONE: La prenotazione non può essere effettuata nel passato!');

END;
/