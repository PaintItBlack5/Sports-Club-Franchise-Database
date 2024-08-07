CREATE OR REPLACE TRIGGER durata_prenotazione
BEFORE INSERT OR UPDATE ON prenotazione
FOR EACH ROW

DECLARE
  errore_durata_prenotazione EXCEPTION;

BEGIN
	
	IF( (:NEW.data_inizio_attivita + INTERVAL '4' HOUR) < :NEW.data_fine_attivita OR
	(:NEW.data_fine_attivita - INTERVAL '1' HOUR) < :NEW.data_inizio_attivita ) THEN
		
		RAISE errore_durata_prenotazione;
	END IF;

EXCEPTION
WHEN errore_durata_prenotazione THEN
	RAISE_APPLICATION_ERROR('-20005','ERRORE DURATA ATTIVITA: il campo non può essere occupato per più di 4 ore o meno di 1 ora!');

END;
/