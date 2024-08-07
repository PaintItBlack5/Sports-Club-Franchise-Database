CREATE OR REPLACE PROCEDURE prenotazione_campo(
  disciplinaX VARCHAR,
  cittaX VARCHAR,
  via_piazzaX VARCHAR,
  data_inizio_attivita VARCHAR,
  durata_ore_attivitaX number,
  nominativo_clienteX VARCHAR,
  telefono_clienteX VARCHAR)

IS

  data_inizio_attivitaX DATE := TO_DATE(data_inizio_attivita, 'dd/mm/yyyy hh24:mi');

  data_fine_attivitaX DATE := TO_DATE(TO_CHAR(data_inizio_attivitaX + durata_ore_attivitaX/24,'dd/mm/yyyy hh24:mi'),
    'dd/mm/yyyy hh24:mi');

  giornoX VARCHAR(10) := TO_CHAR(TO_DATE(data_inizio_attivita, 'dd/mm/yyyy hh24:mi'), 'Day');

  ora_inizioX NUMBER := TO_NUMBER(TO_CHAR(data_inizio_attivitaX,'HH24,MI'));
  ora_fineX NUMBER:= TO_NUMBER(TO_CHAR(data_fine_attivitaX,'HH24,MI'));

  idC campo.id_campo%TYPE;

  campi_esauriti EXCEPTION;

  -- Cursore contenente tutti i campi liberi
  CURSOR C 
  IS(  
  
    (SELECT id_campo FROM campo WHERE citta=cittaX AND via_piazza=via_piazzaX AND disciplina=disciplinaX)
  
    MINUS -- Campi occupati da prenotazioni
      (SELECT id_campo
      FROM prenotazione
      WHERE(
      (data_inizio_attivita BETWEEN data_inizio_attivitaX AND data_fine_attivitaX)
      OR
      (data_fine_attivita BETWEEN data_inizio_attivitaX AND data_fine_attivitaX)
      ))

    MINUS -- Campi occupati da lezioni dei corsi
    SELECT id_campo
    FROM (SELECT *
          FROM corso NATURAL JOIN lezione NATURAL JOIN turno
          WHERE giorno = giornoX AND

            (ora_inizio BETWEEN ora_inizioX AND ora_fineX
            
            OR ora_fine BETWEEN ora_inizioX AND ora_fineX)         
          )
);

BEGIN

  OPEN C;
  FETCH C INTO idC;
  -- se ci sono campi liberi (il cursore contiene elementi)
  IF idC IS NOT NULL THEN

    -- inserimento prenotazione  
    INSERT INTO prenotazione (id_campo, data_inizio_attivita, data_fine_attivita, nominativo_cliente , telefono_cliente)
    VALUES (idC, data_inizio_attivitaX, data_fine_attivitaX, nominativo_clienteX, telefono_clienteX);
      
    DBMS_OUTPUT.PUT_LINE('CAMPO '|| idC || ' prenotato!');

  -- altrimenti lancia eccezione  
  ELSE
    RAISE campi_esauriti;        
  END IF;
  
  CLOSE C;

EXCEPTION
  WHEN campi_esauriti THEN
  RAISE_APPLICATION_ERROR('-20022','ERRORE: NESSUN CAMPO DISPONIBILE per la sede e la disciplina indicate!');

END;
/