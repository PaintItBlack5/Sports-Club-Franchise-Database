CREATE OR REPLACE TRIGGER personale_futuro 
BEFORE INSERT OR UPDATE ON personale
FOR EACH ROW

DECLARE
    errore_personale_futuro EXCEPTION;

BEGIN

    IF(:NEW.data_assunzione > SYSDATE) THEN
        RAISE errore_personale_futuro;
    END IF;

EXCEPTION
WHEN errore_personale_futuro THEN
    RAISE_APPLICATION_ERROR('-20016','ERRORE DATA ASSUNZIONE PERSONALE: La data di assunzione di questo membro dello staff è nel futuro!');

END;
/