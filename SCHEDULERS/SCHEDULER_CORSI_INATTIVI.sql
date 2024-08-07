/* JOB CHE OGNI PRIMO DEL MESE CANCELLA TUTTI I CORSI (E LE RELATIVE LEZIONI SETTIMANALI),
   CHE NON HANNO MAI AVUTO ISCRITTI, A DUE MESI DALL'AVVIO */

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name                 =>      'Cancellazione_Corsi_Inattivi',
   job_type                 =>      'PLSQL_BLOCK',
   job_action               =>      'BEGIN 

                                       DELETE FROM lezione
                                       WHERE data_inizio_corso <= ADD_MONTHS(SYSDATE,-2)
                                       AND (nome_corso, data_inizio_corso) IN 
                                          (SELECT nome_corso, data_inizio_corso
                                          FROM corso

                                          MINUS 
                                          SELECT nome_corso, data_inizio_corso
                                          FROM iscrizione
                                          );
                                          
                                       DELETE FROM corso
                                       WHERE data_inizio_corso <= ADD_MONTHS(SYSDATE,-2)
                                       AND (nome_corso, data_inizio_corso) IN 
                                          (SELECT nome_corso, data_inizio_corso
                                          FROM corso
                                          
                                          MINUS 
                                          SELECT nome_corso, data_inizio_corso
                                          FROM iscrizione
                                          );

                                    END;',
                                    
   start_date               =>      TO_DATE('01-GEN-2017','DD-MON-YYYY'),
   repeat_interval          =>      'FREQ=MONTHLY', 
   enabled                  =>      TRUE,
   comments                 =>      'Cancellazione dei corsi e delle lezioni inattivi');
END;