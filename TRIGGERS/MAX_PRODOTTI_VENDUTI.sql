CREATE OR REPLACE TRIGGER max_prodotti_venduti
BEFORE INSERT ON vendita_prodotto
FOR EACH ROW

DECLARE
	tot_acq NUMBER;
	tot_ven NUMBER;
	errore_max_prodotti_venduti EXCEPTION;

BEGIN

	-- calcola la quantità acquistata complessiva del prodotto

	SELECT SUM(quantita_acquistate) INTO tot_acq 
	FROM include 
	WHERE codice_barre = :NEW.codice_barre;

	-- calcola la quantità già venduta complessiva del prodotto

	SELECT SUM(quantita_vendute) INTO tot_ven
	FROM vendita_prodotto
	WHERE codice_barre = :NEW.codice_barre;
	
	/* se la somma delle quantità già vendute e appena vendute
	è maggiore di quella acquistata, lancia eccezione */
	
	IF(tot_ven + :NEW.quantita_vendute >= tot_acq) THEN
		RAISE errore_max_prodotti_venduti;
	END IF;

EXCEPTION
WHEN errore_max_prodotti_venduti THEN
	RAISE_APPLICATION_ERROR('-20015','ERRORE VENDITA: Quantità prodotto non disponibile in magazzino o non registrata!');

END;
/