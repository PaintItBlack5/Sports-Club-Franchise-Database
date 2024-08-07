CREATE OR REPLACE TRIGGER sovrapposizione_corsi
BEFORE INSERT ON lezione
FOR EACH ROW

DECLARE
      verifica NUMBER;
      errore_corso_sovrapposto EXCEPTION;

BEGIN

      /* verifica se sullo stesso campo, nello stesso giorno e nella stessa fascia oraria,
      del nuovo corso, se ne svolge già uno */

      SELECT COUNT (*) INTO verifica
      FROM (-- seleziona giorno e fasce orarie, dei corsi che si sovrappongono, a quelle del corso nuovo 
            SELECT giorno,ora_inizio,ora_fine 
            FROM (-- seleziona tutti i corsi che si svolgono sullo stesso campo, di quello nuovo
                  SELECT *
                  FROM corso 
                  NATURAL JOIN lezione 
                  NATURAL JOIN turno
                  WHERE id_campo = (-- campo del nuovo corso
                                    SELECT id_campo 
                                    FROM corso 
                                    WHERE nome_corso = :NEW.nome_corso AND data_inizio_corso = :NEW.data_inizio_corso
                                    )
                  )
            WHERE giorno =   (-- giorno della nuova lezione
                              SELECT giorno 
                              FROM turno
                              WHERE codice_turno = :NEW.codice_turno) AND

                              -- l'ora di inizio turno è tra:
                              (ora_inizio BETWEEN
                                          (-- ora inizio e ora fine della lezione del nuovo corso
                                          SELECT ora_inizio
                                          FROM turno 
                                          WHERE codice_turno = :NEW.codice_turno) AND
                                          (SELECT ora_fine 
                                          FROM turno 
                                          WHERE codice_turno = :NEW.codice_turno) 
                              
                              -- oppure l'ora di fine turno è tra:
                              OR ora_fine BETWEEN 
                                          (-- ora inizio e ora fine della lezione del nuovo corso
                                          SELECT ora_inizio
                                          FROM turno 
                                          WHERE codice_turno = :NEW.codice_turno) AND 
                                          (SELECT ora_fine 
                                          FROM turno 
                                          WHERE codice_turno = :NEW.codice_turno)
                              )         
      
            );
      
      -- in caso affermativo, lancia eccezione
      IF (verifica > 0) THEN
            RAISE errore_corso_sovrapposto;
      END IF; 

EXCEPTION
WHEN errore_corso_sovrapposto THEN
	RAISE_APPLICATION_ERROR('-20013','ERRORE CORSO: Questo campo è già occuppato da un corso nella fascia oraria indicata!');

END;
/