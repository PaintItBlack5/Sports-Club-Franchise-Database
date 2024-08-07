--  CREAZIONE RUOLI E UTENTI

-- Creazione Amministratore e relativa assegnazione privilegi
CREATE USER Admin_Polisportive IDENTIFIED by oracle 
DEFAULT TABLESPACE USERS TEMPORARY 
TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;

GRANT ALL PRIVILEGES TO Admin_Polisportive;

-- Creazione Ruoli
CREATE ROLE Direzione;
CREATE ROLE Segreteria;
CREATE ROLE Bar;

-- Privilegi di sistema
GRANT CONNECT, CREATE SESSION TO Direzione;
GRANT CONNECT, CREATE SESSION TO Segreteria;
GRANT CONNECT, CREATE SESSION TO Bar;

-- Privilegi di oggetto
GRANT SELECT, INSERT, UPDATE ON persona TO Segreteria;
GRANT SELECT, UPDATE ON abbonato TO Segreteria;
GRANT SELECT ON personale TO Segreteria;
GRANT SELECT ON vw_abbonamenti_in_corso TO Segreteria;
GRANT SELECT ON vw_abbonamenti_terminati TO Segreteria;
GRANT SELECT ON vw_info_turni_dipendenti TO Segreteria;
GRANT SELECT ON vw_info_corsi_in_atto TO Segreteria;
GRANT SELECT ON vw_info_corsi_terminati TO Segreteria;
GRANT SELECT ON vw_info_prenotazioni_in_corso TO Segreteria;
GRANT SELECT ON vw_info_storico_prenotazioni TO Segreteria;
GRANT DELETE ON prenotazione TO Segreteria;
GRANT SELECT ON vw_storico_utenze_non_pagate TO Segreteria;
GRANT SELECT ON vw_storico_utenze_pagate TO Segreteria;
GRANT SELECT, INSERT, UPDATE ON utenze TO Segreteria;
GRANT SELECT ON sede TO Segreteria;
GRANT SELECT ON campo TO Segreteria;
GRANT SELECT ON vw_importo_ordine TO Segreteria;
GRANT SELECT ON vw_importo_vendita TO Segreteria;

GRANT EXECUTE ON prenotazione_campo TO Segreteria;
GRANT EXECUTE ON iscrizione_corso TO Segreteria;


GRANT SELECT ON sede TO Bar;
GRANT SELECT ON vw_info_ordini_aperti TO Bar;
GRANT SELECT ON vw_info_ordini_ricevuti TO Bar;
GRANT SELECT ON vw_info_turni_dipendenti TO Bar;
GRANT SELECT ON vw_vendite_ultimo_mese TO Bar;
GRANT SELECT ON vw_storico_vendite TO Bar;
GRANT SELECT ON fornitore TO Bar;
GRANT SELECT, INSERT, UPDATE ON prodotto_attrezzatura TO Bar;
GRANT SELECT ON vw_importo_ordine TO Bar;
GRANT SELECT ON vw_importo_vendita TO Bar;

GRANT EXECUTE ON effettua_ordine TO Bar;
GRANT EXECUTE ON ordine_consegnato TO Bar;
GRANT EXECUTE ON vendita_prodotti TO Bar;


GRANT SELECT, INSERT, UPDATE ON persona TO Direzione;
GRANT SELECT, INSERT, UPDATE ON personale TO Direzione;
GRANT SELECT ON vw_bilancio TO Direzione;
GRANT SELECT ON vw_info_ordini_aperti TO Direzione;
GRANT SELECT ON vw_info_ordini_ricevuti TO Direzione;
GRANT SELECT ON vw_abbonamenti_in_corso TO Direzione;
GRANT SELECT ON vw_abbonamenti_terminati TO Direzione;
GRANT SELECT ON vw_info_turni_dipendenti TO Direzione;
GRANT SELECT ON vw_info_corsi_in_atto TO Direzione;
GRANT SELECT ON vw_info_corsi_terminati TO Direzione;
GRANT SELECT ON vw_info_prenotazioni_in_corso TO Direzione;
GRANT SELECT ON vw_info_storico_prenotazioni TO Direzione;
GRANT SELECT ON vw_vendite_ultimo_mese TO Direzione;
GRANT SELECT ON vw_storico_vendite TO Direzione;
GRANT SELECT ON vw_storico_utenze_non_pagate TO Direzione;
GRANT SELECT ON vw_storico_utenze_pagate TO Direzione;
GRANT SELECT, INSERT, UPDATE ON turno TO Direzione;
GRANT SELECT, INSERT, UPDATE ON turnazione TO Direzione;
GRANT SELECT, INSERT, UPDATE ON lezione TO Direzione;
GRANT SELECT, INSERT, UPDATE ON corso TO Direzione;
GRANT SELECT, INSERT, UPDATE ON utenze TO Direzione;
GRANT SELECT, INSERT, UPDATE ON sede TO Direzione;
GRANT SELECT, INSERT, UPDATE ON campo TO Direzione;
GRANT SELECT, INSERT, UPDATE ON fornitore TO Direzione;
GRANT UPDATE, DELETE ON ordine TO Direzione;
GRANT SELECT, INSERT, UPDATE ON prodotto_attrezzatura TO Direzione;
GRANT SELECT ON vw_importo_ordine TO Direzione;
GRANT SELECT ON vw_importo_vendita TO Direzione;

GRANT EXECUTE ON effettua_ordine TO Direzione;
GRANT EXECUTE ON ordine_consegnato TO Direzione;

-- Creazione utenti e relativa assegnazione ruoli
CREATE USER bar1 IDENTIFIED BY bar DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER seg1 IDENTIFIED BY segreteria DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER dir1 IDENTIFIED BY direzione DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER bar2 IDENTIFIED BY bar DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER seg2 IDENTIFIED BY segreteria DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER dir2 IDENTIFIED BY direzione DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER bar3 IDENTIFIED BY bar DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER seg3 IDENTIFIED BY segreteria DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER dir3 IDENTIFIED BY direzione DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;
CREATE USER proprieta IDENTIFIED BY proprieta DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA 24M ON USERS PROFILE DEFAULT;

GRANT Direzione TO dir1, dir2, dir3, proprieta;
GRANT Segreteria TO seg1, seg2, seg3;
GRANT Bar TO bar1, bar2, bar3;