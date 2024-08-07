CREATE OR REPLACE PROCEDURE iscrizione_corso(
    nome_corso_x VARCHAR,
    data_inizio_corso VARCHAR,
    data_inizio_abbonamento VARCHAR,
    num_mesi_x NUMBER,
    cf_x VARCHAR,
    nome_x VARCHAR := NULL,
    cognome_x VARCHAR := NULL,
    luogo_nascita_x VARCHAR := NULL,
    data_nascita VARCHAR := NULL)

IS

    data_inizio_corso_x DATE := TO_DATE(data_inizio_corso, 'dd/mm/yyyy');
    data_inizio_abbonamento_x DATE := TO_DATE(data_inizio_abbonamento, 'dd/mm/yyyy');
    data_fine_abbonamento_x DATE := ADD_MONTHS(data_inizio_abbonamento_x, num_mesi_x);
    data_nascita_x DATE := TO_DATE(data_nascita, 'dd/mm/yyyy');
    cod_abb NUMBER := 0;
    persona_non_reg NUMBER := 0;
    istruttore_iscritto NUMBER := 0;
    error_persona_non_reg EXCEPTION;
    error_istrutt_iscritto EXCEPTION;
    nome_temp VARCHAR(64);
    cognome_temp VARCHAR(64);

BEGIN
    
    -- verifica se ad iscriversi è l'istruttore del corso stesso e nel caso lancia l'eccezione

    SELECT COUNT(cf) INTO istruttore_iscritto 
    FROM corso 
    WHERE cf=cf_x;
    
    IF (istruttore_iscritto > 0) THEN 
        RAISE error_istrutt_iscritto;
    END IF;

    -- verifica se ad iscriversi è una persona non registrata nel DB e nel caso lancia l'eccezione

    SELECT COUNT(cf) INTO persona_non_reg 
    FROM persona 
    WHERE cf=cf_x;

    -- se la persona non è registrata 
    IF (persona_non_reg = 0) THEN

        -- se sono stati inseriti tutti i parametri per farlo
        IF (nome_x IS NOT NULL AND
            cognome_x IS NOT NULL AND
            luogo_nascita_x IS NOT NULL AND
            data_nascita_x IS NOT NULL) THEN

                -- registra persona
                INSERT INTO persona (cf, nome, cognome, luogo_nascita, data_nascita)
                VALUES (cf_x, nome_x, cognome_x, luogo_nascita_x, data_nascita_x);

                -- selezione per stampa
                SELECT nome, cognome INTO nome_temp, cognome_temp 
                FROM persona 
                WHERE cf = cf_x;
                DBMS_OUTPUT.PUT_LINE('REGISTRAZIONE PERSONA: '|| nome_temp || ' ' || cognome_temp || ' EFFETTUATA!');
        
        --altrimenti lancia eccezione
        ELSE 
            RAISE error_persona_non_reg;
        END IF;
    END IF;

    -- registrazione abbonato e relativo codice abbonamento
    INSERT INTO abbonato (cf)
    VALUES (cf_x);

    SELECT COD_ABB_SEQ.CURRVAL INTO cod_abb FROM DUAL;

    -- registrazione iscrizione al corso
    INSERT INTO iscrizione (codice_abbonamento, nome_corso, data_inizio_corso, data_inizio_abbonamento, data_fine_abbonamento)
    VALUES (cod_abb, nome_corso_x, data_inizio_corso_x, data_inizio_abbonamento_x, data_fine_abbonamento_x);

    DBMS_OUTPUT.PUT_LINE('ISCRIZIONE AVVENUTA CON SUCCESSO!');

    EXCEPTION
    WHEN error_istrutt_iscritto THEN
        RAISE_APPLICATION_ERROR('-20021','ERRORE: L ISTRUTTORE DEL CORSO NON PUO ISCRIVERSI AL CORSO CHE SUPERVISIONA!');
    WHEN error_persona_non_reg THEN
        RAISE_APPLICATION_ERROR('-20022','ERRORE: PERSONA NON REGISTRATA E DATI INSERITI INSUFFICIENTI PER UNA NUOVA REGISTRAZIONE!');

END;
/
