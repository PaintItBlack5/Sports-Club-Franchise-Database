CREATE OR REPLACE TRIGGER max_ore_gg_personale
BEFORE INSERT OR UPDATE ON turnazione
FOR EACH ROW

DECLARE
  ore_tot NUMBER;
  ore_new NUMBER;
  errore_max_ore_gg EXCEPTION;

BEGIN

  -- somma le ore di lavoro, già accumulate nella giornata, dal lavoratore

  SELECT SUM(turno.ora_fine - turno.ora_inizio) INTO ore_tot
  FROM turno
  NATURAL JOIN turnazione
  WHERE turnazione.cf = :NEW.cf AND turno.giorno =  (SELECT giorno
                                                    FROM turno
                                                    WHERE codice_turno = :NEW.codice_turno);

  -- seleziona le ore di lavoro che si stanno aggiungendo

  SELECT (ora_fine - ora_inizio) INTO ore_new 
  FROM turno 
  WHERE codice_turno = :NEW.codice_turno;

  -- se la somma delle due è maggiore di 13, lancia eccezione

  IF( (ore_tot + ore_new) > 13) THEN
    RAISE errore_max_ore_gg;
  END IF;

EXCEPTION
WHEN errore_max_ore_gg THEN
  RAISE_APPLICATION_ERROR('-20010','ERRORE MAX ORE GG: Il personale non può lavorare più di 13 ore al giorno!');

END;
/