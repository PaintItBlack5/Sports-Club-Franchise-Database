CREATE OR REPLACE TRIGGER iscrizione_in_corso
BEFORE INSERT OR UPDATE ON iscrizione
FOR EACH ROW

DECLARE
  data_ic DATE;
  data_fc DATE;
  errore_iscrizione_in_corso EXCEPTION;

BEGIN

  /* seleziona le date di inizio e fine
  del corso a cui si sta iscrivendo l'abbonato */

  SELECT data_inizio_corso, data_fine_corso INTO data_ic, data_fc
  FROM corso
  WHERE nome_corso = :NEW.nome_corso AND data_inizio_corso = :NEW.data_inizio_corso;

  /* se il periodo di validità del nuovo abbonamento non rientra nelle suddette date
  lancia eccezione */

  IF (:NEW.data_inizio_abbonamento NOT BETWEEN data_ic AND data_fc 
    OR
    :NEW.data_fine_abbonamento NOT BETWEEN data_ic AND data_fc) THEN
		

    RAISE errore_iscrizione_in_corso;
  END IF;

EXCEPTION
WHEN errore_iscrizione_in_corso THEN
	RAISE_APPLICATION_ERROR('-20008','ERRORE DATE ISCRIZIONE AL CORSO: Le date dell iscrizione non rientrano nella durata del corso!');

END;
/