CREATE OR REPLACE PROCEDURE vendita_prodotti(
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

    cod_scontrino NUMBER := 0;
    tot_scontrino NUMBER := 0;

    -- Cursore contenente la lista di prodotti (stampa)
    CURSOR C 
    IS (SELECT vendita_prodotto.codice_barre AS cod_prd, prodotto_attrezzatura.nome_prodotto AS nome,
        vendita_prodotto.quantita_vendute AS qnt,
        (prodotto_attrezzatura.prezzo_vendita_unitario * vendita_prodotto.quantita_vendute) AS costo 
        FROM vendita_prodotto 
        JOIN prodotto_attrezzatura ON vendita_prodotto.codice_barre = prodotto_attrezzatura.codice_barre
        WHERE vendita_prodotto.id_scontrino = cod_scontrino);

BEGIN
    
    -- inserimento della vendita
    INSERT INTO vendita (citta, via_piazza)
    VALUES (citta, via_piazza);
    SELECT ID_SCONTRINO_SEQ.CURRVAL INTO cod_scontrino FROM DUAL;

    -- inserimento dei prodotti
    INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute) 
    VALUES (cod_scontrino, codice_barre_prod1,quantita_prod1);

    IF ((codice_barre_prod2 IS NOT NULL) AND (quantita_prod2 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod2,quantita_prod2);
    END IF;

    IF ((codice_barre_prod3 IS NOT NULL) AND (quantita_prod3 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod3,quantita_prod3);
    END IF;

    IF ((codice_barre_prod4 IS NOT NULL) AND (quantita_prod4 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod4,quantita_prod4);
    END IF;

    IF ((codice_barre_prod4 IS NOT NULL) AND (quantita_prod5 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod5,quantita_prod5);
    END IF;

    IF ((codice_barre_prod5 IS NOT NULL) AND (quantita_prod6 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod6,quantita_prod6);
    END IF;

    IF ((codice_barre_prod6 IS NOT NULL) AND (quantita_prod7 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod7,quantita_prod7);
    END IF;

    IF ((codice_barre_prod7 IS NOT NULL) AND (quantita_prod8 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod8,quantita_prod8);
    END IF;

    IF ((codice_barre_prod8 IS NOT NULL) AND (quantita_prod9 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod9,quantita_prod9);
    END IF;

    IF ((codice_barre_prod9 IS NOT NULL) AND (quantita_prod10 IS NOT NULL)) THEN
        INSERT INTO vendita_prodotto (id_scontrino,codice_barre,quantita_vendute)
        VALUES (cod_scontrino, codice_barre_prod10,quantita_prod10);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Stampato lo scontrino numero: ' || cod_scontrino);

    FOR rec IN C
    LOOP    
        DBMS_OUTPUT.PUT_LINE('cod_prd: '||rec.cod_prd ||' - nome: ' ||rec.nome ||' - qnt: '||rec.qnt || ' - subtot: ' || rec.costo || '€');
        tot_scontrino := tot_scontrino + rec.costo;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTALE SCONTRINO: ' || tot_scontrino || '€');
    
END;
/