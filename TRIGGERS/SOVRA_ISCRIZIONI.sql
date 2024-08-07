CREATE OR REPLACE TRIGGER sovra_iscrizioni
BEFORE INSERT ON iscrizione
FOR EACH ROW

DECLARE
  verifica NUMBER;
  errore_periodi_iscrizioni EXCEPTION;
  cod_fis VARCHAR(16);

BEGIN

  /* seleziona il codice fiscale della persona che si sta iscrivendo
  (non è presente in iscrizione, ma in abbonato) */

  SELECT cf INTO cod_fis
  FROM abbonato 
  WHERE codice_abbonamento = :NEW.codice_abbonamento;

  /* verifica se la persona possiede già, un abbonamento al corso valido, 
  ovvero, se le date del preesistente e del nuovo abbonamento si sovrappongono */

  SELECT COUNT (cf) INTO verifica
  FROM iscrizione
  NATURAL JOIN abbonato
  WHERE cf = cod_fis AND 
  nome_corso = :NEW.nome_corso AND 
  data_inizio_corso = :NEW.data_inizio_corso AND (
    data_inizio_abbonamento BETWEEN :NEW.data_inizio_abbonamento AND :NEW.data_fine_abbonamento 
    OR
    data_fine_abbonamento BETWEEN :NEW.data_inizio_abbonamento AND :NEW.data_fine_abbonamento
  );

  -- nel caso, lancia eccezione
  
  IF (verifica > 0) THEN
    RAISE errore_periodi_iscrizioni;
  END IF;

EXCEPTION
WHEN errore_periodi_iscrizioni THEN
    RAISE_APPLICATION_ERROR('-20011','ERRORE DATE ISCRIZIONE AL CORSO: Il tesserato risulta già iscritto, a questo corso, in questo periodo!');

END;
/