CREATE OR REPLACE TRIGGER personale_maggiorenne
BEFORE INSERT OR UPDATE ON personale
FOR EACH ROW

DECLARE
    data_nascita_p DATE;
    data_assunzione_p DATE;
    errore_eta_p EXCEPTION;

BEGIN

    -- seleziona data di nascita e assunzione del lavoratore

    SELECT data_nascita, :NEW.data_assunzione INTO data_nascita_p, data_assunzione_p 
    FROM persona 
    WHERE cf = :NEW.cf;

    -- se la differenza tra le due è minore di 18 anni (216 mesi), lancia eccezione
    
    IF(MONTHS_BETWEEN(data_assunzione_p, data_nascita_p)<216) THEN
        RAISE errore_eta_p;
    END IF;

EXCEPTION
WHEN errore_eta_p THEN
    RAISE_APPLICATION_ERROR('-20003','ERRORE ETA: Il personale non può essere minorenne al momento dell assunzione!');

END;
/