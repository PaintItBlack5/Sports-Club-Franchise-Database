-- JOB CHE OGNI PRIMO DEL MESE CANCELLA TUTTE LE ISCRIZIONI SCADUTE DA DUE ANNI
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name             =>      'Cancellazione_Iscrizioni',
   job_type             =>      'PLSQL_BLOCK',
   job_action           =>      'BEGIN 
                                    DELETE FROM Iscrizione 
                                    WHERE data_fine_abbonamento < SYSDATE-730;
                                END;',
   start_date           =>      TO_DATE('01-GEN-2017','DD-MON-YYYY'),
   repeat_interval      =>      'FREQ=MONTHLY', 
   enabled              =>      TRUE,
   comments             =>      'Cancellazione delle vecchie iscrizioni');
END;