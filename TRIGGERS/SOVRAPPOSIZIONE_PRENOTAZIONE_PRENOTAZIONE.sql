CREATE OR REPLACE TRIGGER sovrapposizione_prenotazioni
BEFORE INSERT OR UPDATE ON prenotazione
FOR EACH ROW

DECLARE
  verifica NUMBER;
  prenot_sovrapposta EXCEPTION;

BEGIN

  /* verifica se il campo è già prenotato nello stesso periodo */

  SELECT COUNT (*) INTO verifica
  FROM prenotazione
  WHERE id_campo = :NEW.id_campo AND 

    -- date e ore della prenotazione sovrapposte a quelle nuove
    (data_inizio_attivita BETWEEN :NEW.data_inizio_attivita AND :NEW.data_fine_attivita
  
    OR data_fine_attivita BETWEEN :NEW.data_inizio_attivita AND :NEW.data_fine_attivita
    );

  -- in caso affermativo, lancia eccezione
  IF (verifica > 0) THEN
	  RAISE prenot_sovrapposta;
  END IF;

EXCEPTION
WHEN prenot_sovrapposta THEN
	RAISE_APPLICATION_ERROR('-20012','ERRORE PRENOTAZIONE: Questo campo è già stato prenotato nella fascia oraria indicata!');

END;
/