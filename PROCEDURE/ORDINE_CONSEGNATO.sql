CREATE OR REPLACE PROCEDURE ordine_consegnato(
  partita_ivaX VARCHAR,
  data_richiesta VARCHAR,
  data_consegna VARCHAR := NULL)

IS

  no_ordine_exception EXCEPTION;
  data_richiestaX DATE := TO_DATE(data_richiesta, 'dd/mm/yyyy');
  data_consegnaX DATE := TO_DATE(data_consegna, 'dd/mm/yyyy');
  counter NUMBER;

BEGIN
  
  -- verifica se l'ordine è stato registrato
  SELECT COUNT(*) INTO counter
  FROM ordine 
  WHERE partita_iva = partita_ivaX AND data_richiesta = data_richiestaX;
  
  IF(counter = 1) THEN
    
    -- se è stata passata una data di consegna, inseriscila
    IF(data_consegnaX IS NOT NULL) THEN
      UPDATE ordine SET data_consegna = data_consegnaX WHERE partita_iva = partita_ivaX AND data_richiesta = data_richiestaX;
      DBMS_OUTPUT.PUT_LINE('Ordine: ' || partita_ivaX || ' richiesto in data: '|| data_richiestaX || ' consegnato in data: ' || data_consegnaX);
    
    -- altrimenti inserisci la data odierna
    ELSE
      UPDATE ordine SET data_consegna = SYSDATE WHERE partita_iva = partita_ivaX AND data_richiesta = data_richiestaX;
      DBMS_OUTPUT.PUT_LINE('Ordine: ' || partita_ivaX || ' richiesto in data: '|| data_richiestaX || ' consegnato in data: ' || SYSDATE);
    END IF;
  
  --altrimenti lancia eccezione
  ELSE
    RAISE no_ordine_exception;
  END IF;

EXCEPTION
WHEN no_ordine_exception THEN
  RAISE_APPLICATION_ERROR('-20020','ERRORE: ordine non registrato! Verificare la partita iva e la data richiesta inserite...');

END;
/