CREATE OR REPLACE TRIGGER max_personale_sede
BEFORE INSERT ON personale
FOR EACH ROW

DECLARE
	contatore NUMBER;
	errore_max_personale EXCEPTION;

BEGIN

	-- conta il personale della sede

	SELECT COUNT(*) INTO contatore
	FROM personale
	WHERE citta = :NEW.citta AND via_piazza = :NEW.via_piazza;
	
	-- se è maggiore di 50, lancia eccezione
	
	IF(contatore >= 50) THEN
		RAISE errore_max_personale;
	END IF;

EXCEPTION
WHEN errore_max_personale THEN
	RAISE_APPLICATION_ERROR('-20006','ERRORE ETA: La sede non può avere più di 50 persone nello staff!');

END;
/