CREATE OR REPLACE PROCEDURE effettua_ordine(
    partita_ivaX VARCHAR,
    data_richiesta VARCHAR,
    citta VARCHAR,
    via_piazza VARCHAR,
    codice_barre_prod1 VARCHAR,
    quantita_prod1 NUMBER,
    codice_barre_prod2 VARCHAR := NULL,
    quantita_prod2 NUMBER := NULL,
    codice_barre_prod3 VARCHAR := NULL,
    quantita_prod3 NUMBER := NULL,
    codice_barre_prod4 VARCHAR :=  NULL ,
    quantita_prod4 NUMBER :=  NULL,
    codice_barre_prod5 VARCHAR := NULL,
    quantita_prod5 NUMBER := NULL,
    codice_barre_prod6 VARCHAR := NULL,
    quantita_prod6 NUMBER := NULL,
    codice_barre_prod7 VARCHAR := NULL,
    quantita_prod7 NUMBER := NULL,
    codice_barre_prod8 VARCHAR := NULL,
    quantita_prod8 NUMBER := NULL,
    codice_barre_prod9 VARCHAR := NULL,
    quantita_prod9 NUMBER := NULL,
    codice_barre_prod10 VARCHAR := NULL,
    quantita_prod10 NUMBER := NULL
)

IS

    nome_fornitoreX VARCHAR(64);
    tot_ordine NUMBER := 0;
    data_richiestaX DATE := TO_DATE(data_richiesta, 'dd/mm/yyyy');

    -- Cursore contenente la lista di prodotti (stampa)
    CURSOR C 
    IS(    
        SELECT codice_barre AS cod_prd, nome_prodotto AS nome, quantita_acquistate AS qnt,
        (costo_unitario * quantita_acquistate) AS costo 
        FROM include 
        NATURAL JOIN prodotto_attrezzatura
        WHERE partita_iva = partita_ivaX AND data_richiesta = data_richiestaX);

BEGIN

    -- inserimento dell'ordine
    INSERT INTO ordine (citta, via_piazza, partita_iva, data_richiesta)
    VALUES (citta, via_piazza, partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'));

    SELECT nome_fornitore INTO nome_fornitoreX FROM fornitore WHERE partita_iva = partita_ivaX;

    -- inserimento dei prodotti
    INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
    VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod1,quantita_prod1);

    IF ((codice_barre_prod2 IS NOT NULL) AND (quantita_prod2 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod2,quantita_prod2);
    END IF;

    IF ((codice_barre_prod3 IS NOT NULL) AND (quantita_prod3 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod3,quantita_prod3);
    END IF;

    IF ((codice_barre_prod4 IS NOT NULL) AND (quantita_prod4 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod4,quantita_prod4);
    END IF;

    IF ((codice_barre_prod4 IS NOT NULL) AND (quantita_prod5 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod5,quantita_prod5);
    END IF;

    IF ((codice_barre_prod5 IS NOT NULL) AND (quantita_prod6 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod6,quantita_prod6);
    END IF;

    IF ((codice_barre_prod6 IS NOT NULL) AND (quantita_prod7 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod7,quantita_prod7);
    END IF;

    IF ((codice_barre_prod7 IS NOT NULL) AND (quantita_prod8 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod8,quantita_prod8);
    END IF;
    
    IF ((codice_barre_prod8 IS NOT NULL) AND (quantita_prod9 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod9,quantita_prod9);
    END IF;

    IF ((codice_barre_prod9 IS NOT NULL) AND (quantita_prod10 IS NOT NULL)) THEN
        INSERT INTO include (partita_iva,data_richiesta,codice_barre,quantita_acquistate)
        VALUES (partita_ivaX, TO_DATE(data_richiesta, 'dd/mm/yyyy'), codice_barre_prod10,quantita_prod10);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Ordine effettuato presso: ' || nome_fornitoreX || ' - partita iva: ' || partita_ivaX || ' - in data: '|| data_richiesta);

    FOR rec IN C
    LOOP    
        DBMS_OUTPUT.PUT_LINE('cod_prd: '||rec.cod_prd ||' - nome: ' ||rec.nome ||' - qnt: '||rec.qnt || ' - subtot: ' || rec.costo || '€');
        tot_ordine := tot_ordine + rec.costo;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTALE ORDINE: ' || tot_ordine || '€');

END;
/