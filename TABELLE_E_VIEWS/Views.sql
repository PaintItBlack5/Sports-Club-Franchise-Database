CREATE OR REPLACE VIEW vw_info_prenotazioni_in_corso AS
SELECT citta, via_piazza, id_campo, disciplina, data_inizio_attivita, data_fine_attivita, 
    nominativo_cliente, telefono_cliente, prezzo_orario, tipo_terreno 
FROM prenotazione NATURAL JOIN campo 
WHERE (data_inizio_attivita >= SYSDATE)
ORDER BY data_inizio_attivita;

CREATE OR REPLACE VIEW vw_info_storico_prenotazioni AS
SELECT citta, via_piazza, id_campo, disciplina, data_inizio_attivita, data_fine_attivita,
    nominativo_cliente, telefono_cliente, prezzo_orario, tipo_terreno 
FROM prenotazione NATURAL JOIN campo 
WHERE (data_inizio_attivita < SYSDATE)
ORDER BY data_inizio_attivita;

CREATE OR REPLACE VIEW vw_info_corsi_in_atto AS
SELECT corso.nome_corso, corso.data_inizio_corso, corso.data_fine_corso, count(DISTINCT abbonato.cf) AS abbonati, corso.quota_mensile, 
sede.citta, sede.via_piazza, campo.id_campo, persona.nome AS nome_istruttore, persona.cognome AS cognome_istruttore
FROM corso
JOIN iscrizione ON iscrizione.nome_corso = corso.nome_corso AND iscrizione.data_inizio_corso = corso.data_inizio_corso
JOIN abbonato ON iscrizione.codice_abbonamento = abbonato.codice_abbonamento
JOIN persona ON persona.cf = corso.cf
JOIN campo ON campo.id_campo = corso.id_campo
JOIN sede ON campo.citta = sede.citta AND campo.via_piazza = sede.via_piazza
WHERE corso.data_fine_corso >= SYSDATE
GROUP BY corso.nome_corso, corso.data_inizio_corso, corso.data_fine_corso, corso.quota_mensile, 
sede.citta, sede.via_piazza, campo.id_campo, persona.nome, persona.cognome;

CREATE OR REPLACE VIEW vw_info_corsi_terminati AS
SELECT corso.nome_corso, corso.data_inizio_corso, corso.data_fine_corso, count(DISTINCT abbonato.cf) AS abbonati, corso.quota_mensile, 
sede.citta, sede.via_piazza, campo.id_campo, persona.nome AS nome_istruttore, persona.cognome AS cognome_istruttore
FROM corso
JOIN iscrizione ON iscrizione.nome_corso = corso.nome_corso AND iscrizione.data_inizio_corso = corso.data_inizio_corso
JOIN abbonato ON iscrizione.codice_abbonamento = abbonato.codice_abbonamento
JOIN persona ON persona.cf = corso.cf
JOIN campo ON campo.id_campo = corso.id_campo
JOIN sede ON campo.citta = sede.citta AND campo.via_piazza = sede.via_piazza
WHERE corso.data_fine_corso < SYSDATE
GROUP BY corso.nome_corso, corso.data_inizio_corso, corso.data_fine_corso, corso.quota_mensile, 
sede.citta, sede.via_piazza, campo.id_campo, persona.nome, persona.cognome;

CREATE OR REPLACE VIEW vw_info_turni_dipendenti AS
SELECT persona.cognome, persona.nome, personale.mansione, personale.citta, personale.via_piazza, turno.codice_turno, turno.giorno, turno.ora_inizio, turno.ora_fine
FROM turnazione inner JOIN persona ON turnazione.cf=persona.cf
inner JOIN personale ON turnazione.cf=personale.cf
inner JOIN turno ON turnazione.codice_turno=turno.codice_turno
ORDER BY turnazione.codice_turno;

CREATE OR REPLACE VIEW vw_info_ordini_ricevuti AS
SELECT ordine.partita_iva, ordine.data_richiesta, ordine.data_consegna, ordine.citta, ordine.via_piazza, include.codice_barre, prodotto_attrezzatura.nome_prodotto, include.quantita_acquistate, (prodotto_attrezzatura.costo_unitario * include.quantita_acquistate) AS costo
FROM include JOIN ordine ON include.partita_iva = ordine.partita_iva AND include.data_richiesta = ordine.data_richiesta
JOIN prodotto_attrezzatura ON prodotto_attrezzatura.codice_barre = include.codice_barre
WHERE ordine.data_consegna <= SYSDATE AND ordine.data_consegna IS NOT NULL
ORDER BY ordine.data_richiesta;

CREATE OR REPLACE VIEW vw_info_ordini_aperti AS
SELECT ordine.partita_iva, ordine.data_richiesta, ordine.data_consegna, ordine.citta, ordine.via_piazza, include.codice_barre, prodotto_attrezzatura.nome_prodotto, include.quantita_acquistate, (prodotto_attrezzatura.costo_unitario * include.quantita_acquistate) AS costo
FROM include JOIN ordine ON include.partita_iva = ordine.partita_iva AND include.data_richiesta = ordine.data_richiesta
JOIN prodotto_attrezzatura ON include.codice_barre = prodotto_attrezzatura.codice_barre
WHERE ordine.data_consegna IS NULL
ORDER BY ordine.data_richiesta;

CREATE OR REPLACE VIEW vw_abbonamenti_in_corso AS
SELECT abb.nome, abb.cognome, iscrizione.nome_corso, iscrizione.data_inizio_abbonamento, iscrizione.data_fine_abbonamento, corso.quota_mensile, 
campo.citta, campo.via_piazza
FROM iscrizione NATURAL JOIN (SELECT abbonato.codice_abbonamento, persona.nome, persona.cognome  FROM  abbonato NATURAL JOIN persona)abb
JOIN corso ON iscrizione.nome_corso = corso.nome_corso AND iscrizione.data_inizio_corso=corso.data_inizio_corso
JOIN campo ON corso.id_campo= campo.id_campo
WHERE iscrizione.data_fine_abbonamento > SYSDATE
ORDER BY campo.citta, campo.via_piazza, iscrizione.nome_corso, iscrizione.data_inizio_abbonamento;

CREATE OR REPLACE VIEW vw_abbonamenti_terminati AS
SELECT abb.nome, abb.cognome, iscrizione.nome_corso, iscrizione.data_inizio_abbonamento, iscrizione.data_fine_abbonamento, corso.quota_mensile, 
campo.citta, campo.via_piazza
FROM iscrizione NATURAL JOIN (SELECT abbonato.codice_abbonamento, persona.nome, persona.cognome  FROM  abbonato NATURAL JOIN persona)abb
JOIN corso ON iscrizione.nome_corso = corso.nome_corso AND iscrizione.data_inizio_corso=corso.data_inizio_corso
JOIN campo ON corso.id_campo= campo.id_campo
WHERE iscrizione.data_fine_abbonamento <= SYSDATE
ORDER BY campo.citta, campo.via_piazza, iscrizione.nome_corso, iscrizione.data_inizio_abbonamento;

CREATE OR REPLACE VIEW vw_vendite_ultimo_mese AS
SELECT vendita_prodotto.codice_barre, prodotto_attrezzatura.nome_prodotto, SUM(vendita_prodotto.quantita_vendute) AS quantita_vendute_tot,  vendita.citta, vendita.via_piazza
FROM vendita_prodotto JOIN prodotto_attrezzatura ON vendita_prodotto.codice_barre=prodotto_attrezzatura.codice_barre
JOIN vendita ON vendita_prodotto.id_scontrino=vendita.id_scontrino
WHERE vendita.data_scontrino >= ADD_MONTHS(SYSDATE, -1)
GROUP BY vendita_prodotto.codice_barre, prodotto_attrezzatura.nome_prodotto, vendita.citta, vendita.via_piazza
ORDER BY  quantita_vendute_tot DESC;

CREATE OR REPLACE VIEW vw_storico_vendite AS
SELECT vendita.id_scontrino, vendita_prodotto.codice_barre, prodotto_attrezzatura.nome_prodotto, vendita_prodotto.quantita_vendute,  vendita.citta, vendita.via_piazza
FROM vendita_prodotto JOIN prodotto_attrezzatura ON vendita_prodotto.codice_barre=prodotto_attrezzatura.codice_barre
JOIN vendita ON vendita_prodotto.id_scontrino=vendita.id_scontrino
ORDER BY vendita.citta, vendita.via_piazza, vendita.id_scontrino;

CREATE OR REPLACE VIEW vw_storico_utenze_pagate AS
SELECT fattura, data_scadenza, tipo, importo_utenza, citta, via_piazza 
FROM utenze WHERE pagamento_utenza = 'pagato' 
ORDER BY citta, via_piazza, data_scadenza DESC;

CREATE OR REPLACE VIEW vw_storico_utenze_non_pagate AS
SELECT fattura, data_scadenza, tipo, importo_utenza, citta, via_piazza 
FROM utenze WHERE pagamento_utenza = 'non pagato' 
ORDER BY citta, via_piazza, data_scadenza DESC;

CREATE OR REPLACE VIEW vw_personale_contratto_determ AS
SELECT cf, ROUND((SUM(stipendio) * MONTHS_BETWEEN(data_fr, data_assunzione))) AS stipendi_totali , data_assunzione, data_fr , citta, via_piazza FROM personale 
WHERE data_fr IS NOT NULL
GROUP BY cf, data_assunzione, data_fr, citta, via_piazza
ORDER BY citta, via_piazza;

CREATE OR REPLACE VIEW vw_personale_contratto_indet AS
SELECT cf, ROUND((SUM(stipendio)) * MONTHS_BETWEEN(SYSDATE, data_assunzione)) AS stipendi_totali , data_assunzione, citta, via_piazza FROM personale 
WHERE data_fr IS NULL
GROUP BY cf, data_assunzione, citta, via_piazza
ORDER BY citta, via_piazza;

CREATE OR REPLACE VIEW vw_importo_ordine AS
SELECT partita_iva, data_richiesta, citta, via_piazza, SUM(quantita_acquistate*costo_unitario) AS importo_ordine
FROM ordine NATURAL JOIN include NATURAL JOIN prodotto_attrezzatura
GROUP BY partita_iva, data_richiesta, citta, via_piazza;

CREATE OR REPLACE VIEW vw_importo_vendita AS
SELECT id_scontrino, citta, via_piazza, SUM(quantita_vendute*prezzo_vendita_unitario) AS importo_vendita
FROM vendita_prodotto NATURAL JOIN prodotto_attrezzatura NATURAL JOIN vendita
GROUP BY id_scontrino, citta, via_piazza;

CREATE OR REPLACE VIEW vw_bilancio AS
SELECT citta, via_piazza, utenze, ordini, stipendi_fr, stipendi_indeterminati, vendite, prenotazioni, abbonamenti_in_corso, abbonamenti_terminati, 
(u.utenze + o.ordini + sfr.stipendi_fr + sind.stipendi_indeterminati) AS uscite, 
(v.vendite + p.prenotazioni + aic.abbonamenti_in_corso + at.abbonamenti_terminati) AS entrate, 
((v.vendite + p.prenotazioni + aic.abbonamenti_in_corso + at.abbonamenti_terminati) - (u.utenze + o.ordini + sfr.stipendi_fr + sind.stipendi_indeterminati)) AS bilancio
FROM( SELECT citta, via_piazza, SUM(importo_utenza) AS utenze
      FROM vw_storico_utenze_pagate
      GROUP BY citta, via_piazza) u
      NATURAL JOIN ( SELECT citta, via_piazza, SUM(importo_ordine) AS ordini
                     FROM vw_importo_ordine
                     GROUP BY citta, via_piazza) o
                     NATURAL JOIN (SELECT citta, via_piazza, SUM(stipendi_totali) AS stipendi_fr
                                   FROM vw_personale_contratto_determ
                                   GROUP BY citta, via_piazza) sfr
                                   NATURAL JOIN (SELECT citta, via_piazza, SUM(stipendi_totali) AS stipendi_indeterminati
                                                 FROM vw_personale_contratto_indet
                                                 GROUP BY citta, via_piazza) sind
                                                 NATURAL JOIN (SELECT citta, via_piazza, SUM(vw_importo_vendita.importo_vendita) AS vendite
                                                               FROM vw_importo_vendita
                                                               GROUP BY citta, via_piazza) v
                                                               NATURAL JOIN (SELECT citta, via_piazza, SUM(((data_fine_attivita - data_inizio_attivita) * 24) * prezzo_orario) AS prenotazioni
                                                                             FROM vw_info_storico_prenotazioni
                                                                             GROUP BY citta, via_piazza) p
                                                                             NATURAL JOIN (SELECT citta, via_piazza, ROUND(SUM(MONTHS_BETWEEN(data_fine_abbonamento, data_inizio_abbonamento) * quota_mensile), 2) AS abbonamenti_in_corso
                                                                                           FROM vw_abbonamenti_in_corso
                                                                                           GROUP BY citta, via_piazza) aic
                                                                                           NATURAL JOIN (SELECT citta, via_piazza, ROUND(SUM(MONTHS_BETWEEN(data_fine_abbonamento, data_inizio_abbonamento) * quota_mensile), 2) AS abbonamenti_terminati
                                                                                           FROM vw_abbonamenti_terminati
                                                                                           GROUP BY citta, via_piazza) at;