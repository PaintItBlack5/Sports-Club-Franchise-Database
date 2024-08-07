CREATE OR REPLACE TRIGGER max_ore_personale
BEFORE INSERT OR UPDATE ON turnazione
FOR EACH ROW

DECLARE
	ore_tot NUMBER;
	ore_new NUMBER;
	errore_max_ore EXCEPTION;

BEGIN

	-- somma le ore di lavoro, già accumulate nella settimana, dal lavoratore
	
	SELECT SUM(turno.ora_fine - turno.ora_inizio) INTO ore_tot
	FROM turno
	NATURAL JOIN turnazione
	WHERE turnazione.cf = :NEW.cf;

	-- seleziona le ore di lavoro che si stanno aggiungendo

	SELECT (ora_fine - ora_inizio) INTO ore_new
	FROM turno 
	WHERE codice_turno = :NEW.codice_turno;
	
	-- se la somma delle due è maggiore di 48, lancia eccezione

	IF( (ore_tot + ore_new) > 48) THEN
		RAISE errore_max_ore;
	END IF;

EXCEPTION
WHEN errore_max_ore THEN
	RAISE_APPLICATION_ERROR('-20009','ERRORE MAX ORE SETTIMANALI: Il personale non può lavorare più di 48 ore a settimana!');

END;
/