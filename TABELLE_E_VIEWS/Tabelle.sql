-- CREAZIONE TABELLE E RELATIVI VINCOLI

CREATE TABLE sede (
  citta VARCHAR(64),
  via_piazza VARCHAR(128),
  civico NUMBER(8) NOT NULL,
  provincia VARCHAR(2) NOT NULL,
  telefono_sede VARCHAR(16) NOT NULL CHECK (LENGTH(telefono_sede) >= 9),

  CONSTRAINT pk_sede PRIMARY KEY (citta, via_piazza)
);

CREATE TABLE utenze (
  fattura VARCHAR(16) PRIMARY KEY,
  data_scadenza DATE NOT NULL,
  tipo VARCHAR(64) NOT NULL,
  importo_utenza NUMBER(7,2) NOT NULL CHECK( importo_utenza > 0),
  pagamento_utenza VARCHAR(16) NOT NULL CHECK (LOWER(pagamento_utenza) IN ('pagato', 'non pagato')),
  citta VARCHAR(64),
  via_piazza VARCHAR(128),

  CONSTRAINT fk_sede_utenze FOREIGN KEY (citta, via_piazza)
    REFERENCES sede (citta, via_piazza) ON DELETE CASCADE
);

CREATE TABLE campo(
  id_campo VARCHAR(8) PRIMARY KEY,
  disciplina VARCHAR(64) NOT NULL,
  prezzo_orario NUMBER(5,2) NOT NULL CHECK(prezzo_orario BETWEEN 50 AND 200),
  tipo_terreno VARCHAR(64) NOT NULL,
  citta VARCHAR(64),
  via_piazza VARCHAR(128),

  CONSTRAINT fk_sede_cam FOREIGN KEY (citta,via_piazza) 
    REFERENCES sede (citta, via_piazza) ON DELETE CASCADE
);

CREATE TABLE persona (
  cf VARCHAR(16) PRIMARY KEY CHECK(LENGTH(cf) > 15),
  nome VARCHAR(32) NOT NULL,
  cognome VARCHAR(32) NOT NULL,
  luogo_nascita VARCHAR(64) NOT NULL,
  data_nascita DATE NOT NULL
);

CREATE TABLE abbonato(
  codice_abbonamento NUMBER PRIMARY KEY,
  cf VARCHAR(16),

  CONSTRAINT fk_pers_abb FOREIGN KEY (cf) 
    REFERENCES persona (cf) ON DELETE CASCADE 
);

CREATE TABLE personale (
  cf VARCHAR(16) PRIMARY KEY,
  stipendio NUMBER(7,2) NOT NULL CHECK (stipendio BETWEEN 800 AND 10000),
  mansione VARCHAR(64) NOT NULL,
  data_assunzione DATE NOT NULL,
  data_fr DATE,
  citta VARCHAR(64),
  via_piazza VARCHAR(128),

  CONSTRAINT fk_pers_prsnl FOREIGN KEY (cf)
    REFERENCES persona(cf),
  CONSTRAINT fk_sede_prsnl FOREIGN KEY (citta,via_piazza)
    REFERENCES sede (citta,via_piazza),

  CONSTRAINT chk_date_contratto CHECK ((data_fr IS NULL) OR (data_assunzione < data_fr))
);

CREATE TABLE corso(
  nome_corso VARCHAR(64),
  data_inizio_corso DATE,
  data_fine_corso DATE NOT NULL,
  quota_mensile NUMBER(5,2) NOT NULL CHECK(quota_mensile BETWEEN 20 AND 200),
  cf VARCHAR(16),
  id_campo VARCHAR(8),

  CONSTRAINT pk_corso PRIMARY KEY (nome_corso, data_inizio_corso),
  
  CONSTRAINT fk_istruttore FOREIGN KEY (cf) 
    REFERENCES personale(cf),
  CONSTRAINT fk_cam_cor FOREIGN KEY (id_campo)
    REFERENCES campo (id_campo),
  
  CONSTRAINT chk_date_corso CHECK (data_inizio_corso < data_fine_corso)
);

CREATE TABLE iscrizione (
  codice_abbonamento NUMBER,
  nome_corso VARCHAR(64),
  data_inizio_corso DATE,
  data_inizio_abbonamento DATE NOT NULL,
  data_fine_abbonamento DATE NOT NULL,

  CONSTRAINT pk_iscrizione PRIMARY KEY (codice_abbonamento, nome_corso, data_inizio_corso),

  CONSTRAINT fk_abb_iscr FOREIGN KEY (codice_abbonamento)
    REFERENCES abbonato(codice_abbonamento) ON DELETE CASCADE,
  CONSTRAINT fk_cor_iscr FOREIGN KEY (nome_corso,data_inizio_corso)
    REFERENCES corso (nome_corso, data_inizio_corso) ON DELETE CASCADE,
  
  CONSTRAINT chk_date_iscrizione CHECK (data_inizio_abbonamento <= ADD_MONTHS(data_fine_abbonamento, -1))
);

CREATE TABLE prenotazione (
  id_campo VARCHAR(8),
  data_inizio_attivita DATE,
  data_fine_attivita DATE NOT NULL,
  nominativo_cliente VARCHAR(64) NOT NULL,
  telefono_cliente VARCHAR(16) NOT NULL CHECK (LENGTH(telefono_cliente) >= 9),

  CONSTRAINT pk_pre PRIMARY KEY (id_campo, data_inizio_attivita),

  CONSTRAINT fk_cam_pre FOREIGN KEY (id_campo)
    REFERENCES campo(id_campo) ON DELETE CASCADE
);

CREATE TABLE turno (
  codice_turno VARCHAR (8) PRIMARY KEY,
  giorno VARCHAR (10) NOT NULL,
  ora_inizio NUMBER(2) NOT NULL,
  ora_fine NUMBER (2) NOT NULL,

  CONSTRAINT chk_weekday CHECK (LOWER(giorno) IN ('domenica', 'lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato')),

  CONSTRAINT chk_hours CHECK (ora_inizio >= 9 AND ora_inizio <= 23 AND ora_fine >= 9 AND ora_fine <= 23 AND ora_inizio < ora_fine)
);

CREATE TABLE prodotto_attrezzatura (
  codice_barre VARCHAR(64) PRIMARY KEY CHECK(codice_barre > 5),
  nome_prodotto VARCHAR(64) NOT NULL,
  costo_unitario NUMBER(8,2) NOT NULL CHECK(costo_unitario > 0),
  prezzo_vendita_unitario NUMBER(8,2) CHECK(prezzo_vendita_unitario > 0)
);

CREATE TABLE fornitore (
  partita_iva VARCHAR(11) PRIMARY KEY CHECK(LENGTH(partita_iva) > 10),
  nome_fornitore VARCHAR(64) NOT NULL,
  telefono_fornitore VARCHAR(16) NOT NULL CHECK(LENGTH(telefono_fornitore) >= 9)
);

CREATE TABLE ordine (
  partita_iva VARCHAR(11),
  data_richiesta DATE,
  data_consegna DATE,
  citta VARCHAR(64),
  via_piazza VARCHAR(128),

  CONSTRAINT pk_ordine PRIMARY KEY (partita_iva, data_richiesta),

  CONSTRAINT fk_forn_ord FOREIGN KEY (partita_iva)
    REFERENCES fornitore (partita_iva) ON DELETE CASCADE,
  CONSTRAINT fk_sede_ord FOREIGN KEY (citta,via_piazza)
    REFERENCES sede(citta, via_piazza) ON DELETE CASCADE,

  CONSTRAINT chk_date_ordine CHECK (data_richiesta < data_consegna)
);

CREATE TABLE include (
  partita_iva VARCHAR(11),
  data_richiesta DATE,
  codice_barre VARCHAR(64),
  quantita_acquistate NUMBER(8) NOT NULL CHECK(quantita_acquistate > 0),

  CONSTRAINT pk_include PRIMARY KEY (partita_iva, data_richiesta, codice_barre),

  CONSTRAINT fk_ord_inc FOREIGN KEY (partita_iva, data_richiesta)
    REFERENCES ordine (partita_iva, data_richiesta) ON DELETE CASCADE,
  CONSTRAINT fk_prd_inc FOREIGN KEY (codice_barre)
    REFERENCES prodotto_attrezzatura (codice_barre) ON DELETE CASCADE
);

CREATE TABLE lezione (
  codice_turno VARCHAR(8),
  nome_corso VARCHAR(64),
  data_inizio_corso DATE,

  CONSTRAINT pk_lez PRIMARY KEY (codice_turno, nome_corso, data_inizio_corso),

  CONSTRAINT fk_turno_lez FOREIGN KEY (codice_turno)
    REFERENCES turno (codice_turno) ON DELETE CASCADE,
  CONSTRAINT fk_cor_lez FOREIGN KEY (nome_corso, data_inizio_corso)
    REFERENCES corso (nome_corso, data_inizio_corso) ON DELETE CASCADE
);

CREATE TABLE turnazione (
  cf VARCHAR(16),
  codice_turno VARCHAR(8),

  CONSTRAINT pk_trnzn PRIMARY KEY (cf,codice_turno),

  CONSTRAINT fk_prsnl_trnzn FOREIGN KEY (cf)
    REFERENCES personale (cf) ON DELETE CASCADE,
  CONSTRAINT fk_trnzn_turno FOREIGN KEY (codice_turno)
    REFERENCES turno (codice_turno) ON DELETE CASCADE
);

CREATE TABLE vendita (
  id_scontrino NUMBER PRIMARY KEY,
  data_scontrino DATE DEFAULT CURRENT_TIMESTAMP,
  citta VARCHAR(64),
  via_piazza VARCHAR(128),

  CONSTRAINT fk_sede_vendita FOREIGN KEY (citta,via_piazza)
    REFERENCES sede (citta, via_piazza) ON DELETE CASCADE
);

CREATE TABLE vendita_prodotto (
  id_scontrino NUMBER,
  codice_barre VARCHAR(64),
  quantita_vendute NUMBER(8) NOT NULL CHECK(quantita_vendute > 0),

  CONSTRAINT pk_vp PRIMARY KEY (id_scontrino,codice_barre),

  CONSTRAINT fk_vendita_vp FOREIGN KEY (id_scontrino)
    REFERENCES vendita (id_scontrino) ON DELETE CASCADE,
  CONSTRAINT fk_prd_vp FOREIGN KEY (codice_barre)
    REFERENCES prodotto_attrezzatura (codice_barre) ON DELETE CASCADE
);
