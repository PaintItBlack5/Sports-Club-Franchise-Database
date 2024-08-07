CREATE OR REPLACE TRIGGER sovrapposizione_pre_corso
BEFORE INSERT ON prenotazione
FOR EACH ROW

DECLARE
  verifica NUMBER;
  pre_sovrapposta_corso EXCEPTION;

BEGIN
      
      /* verifica se sullo stesso campo, nello stesso giorno e nella stessa fascia oraria,
      della nuova prenotazione, si svolge già un corso */

      SELECT COUNT (*) INTO verifica
      FROM (-- seleziona giorno e fasce orarie, dei corsi che si svolgono sul campo della nuova prenotazione
            SELECT giorno,ora_inizio,ora_fine 
            FROM (SELECT *
                  FROM corso 
                  NATURAL JOIN lezione 
                  NATURAL JOIN turno
                  WHERE id_campo = :NEW.id_campo
                  )
            WHERE giorno = -- giorno della prenotazione
                              TO_CHAR(:NEW.data_inizio_attivita, 'Day') AND
                              
                              -- fasce orarie delle lezioni che si sovrappongono a quelle della nuova prenotazione 
                  (ora_inizio BETWEEN TO_NUMBER(TO_CHAR(:NEW.data_inizio_attivita,'HH24,MI')) AND
                                          TO_NUMBER(TO_CHAR(:NEW.data_fine_attivita,'HH24,MI')) 
             
                  OR ora_fine BETWEEN TO_NUMBER(TO_CHAR(:NEW.data_inizio_attivita,'HH24,MI')) AND
                                          TO_NUMBER(TO_CHAR(:NEW.data_fine_attivita,'HH24,MI'))
                  )         
            );

      -- in caso affermativo, lancia eccezione
      IF (verifica > 0) THEN
	      RAISE pre_sovrapposta_corso;
      END IF;

EXCEPTION
WHEN pre_sovrapposta_corso THEN
	RAISE_APPLICATION_ERROR('-20014','ERRORE PRENOTAZIONE: Questo campo è già occuppato da un corso nella fascia oraria indicata!');

END;
/