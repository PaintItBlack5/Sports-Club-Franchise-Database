CREATE OR REPLACE TRIGGER max_iscritti_corso
BEFORE INSERT OR UPDATE ON iscrizione
FOR EACH ROW

DECLARE
	contatore NUMBER;
	errore_max_iscritti EXCEPTION;

BEGIN
	
	/* conta gli iscritti al corso,
	con abbonamento ancora valido */

	SELECT COUNT(*) INTO contatore
	FROM iscrizione
	WHERE nome_corso = :NEW.nome_corso AND
	data_inizio_corso = :NEW.data_inizio_corso AND 
	data_fine_abbonamento > :NEW.data_inizio_abbonamento;
	
	-- se maggiore di 30, lancia eccezione
	
	IF(contatore >= 30) THEN
		RAISE errore_max_iscritti;
	END IF;

EXCEPTION
WHEN errore_max_iscritti THEN
	RAISE_APPLICATION_ERROR('-20007','ERRORE ETA: Il corso non può avere più di 30 iscritti!');

END;
/