--ACTUALIZA TOTAL DE PAGO EN TABLA VENTA PARA PODER ASÍ GENERAR UN TOTAL DE COMPRA--
CREATE OR REPLACE FUNCTION fRegistroVenta(_VENTA VARCHAR)
RETURNS VARCHAR
AS $$
	DECLARE
		TOTAL NUMERIC := (SELECT SUM(PRECIO_VENTA * CANTIDAD_ARTICULO)
				  FROM DETALLES_VENTA
				  WHERE NUMERO_VENTA = _VENTA);
	BEGIN
		UPDATE VENTA SET TOTAL_VENTA = TOTAL WHERE NUMERO_VENTA = _VENTA;
		RETURN 'VENTA GENERADA';
	END;$$
LANGUAGE PLPGSQL;

--FUNCIÓN QUE GENERA UNA VISTA LA CUAL SE ASEMEJA A UNA FACTURA--
CREATE OR REPLACE FUNCTION fGeradorFactura(_VENTA VARCHAR)
RETURNS TABLE(VENTA CHARACTER VARYING(10),
			  CLIENTE INTEGER,
			  NOMBRE CHARACTER VARYING(30),
			  CANTIDAD INTEGER,
			  DESCRIPCION CHARACTER VARYING(50),
			  PRECIO NUMERIC(6,2),
			  TOTAL NUMERIC(6,2))
AS $$
BEGIN
	RETURN QUERY
	SELECT VE.NUMERO_VENTA, CL.CLIENTE_ID, CL.NOMBRE, 
	DV.CANTIDAD_ARTICULO AS CANTIDAD, 
	PR.DESCRIPCION, DV.PRECIO_VENTA AS PRECIO,
	(DV.CANTIDAD_ARTICULO * DV.PRECIO_VENTA) AS TOTAL_PARCIAL
	FROM DETALLES_VENTA AS DV
	INNER JOIN PRODUCTO AS PR
	ON DV.CODIGO_BARRAS = PR.CODIGO_BARRAS
	INNER JOIN VENTA AS VE
	ON DV.NUMERO_VENTA = VE.NUMERO_VENTA
	INNER JOIN CLIENTE AS CL
	ON VE.CLIENTE_ID = CL.CLIENTE_ID
	WHERE VE.NUMERO_VENTA = _VENTA;
END; $$
LANGUAGE PLPGSQL;

--FUNCION QUE REGRESA UTILIDAD DE UN PRODUCTO--
CREATE OR REPLACE FUNCTION fUTILIDADES(_CODIGO BIGINT)
RETURNS TABLE(CODIGO BIGINT,
			  DESCRIPCION CHARACTER VARYING(50),
			  UTILIDAD NUMERIC(6,2))
AS $$
BEGIN
	RETURN QUERY
	SELECT PR.CODIGO_BARRAS, PR.DESCRIPCION,
	SUM(DV.CANTIDAD_ARTICULO * DV.PRECIO_VENTA) - (SUM(DV.CANTIDAD_ARTICULO) * PR.PRECIO_COMPRA)
	FROM DETALLES_VENTA AS DV
	INNER JOIN PRODUCTO AS PR
	ON DV.CODIGO_BARRAS = PR.CODIGO_BARRAS
	WHERE DV.CODIGO_BARRAS = _CODIGO
	GROUP BY PR.CODIGO_BARRAS;
END; $$
LANGUAGE PLPGSQL;

SELECT * FROM FUTILIDADES(723549137642);

--FUNCIÓN QUE RETORNA AQUELLOS PRODUCTOS CON EXISTENCIAS MENORES A 3--
CREATE OR REPLACE FUNCTION fMENOSDETRES()
RETURNS TABLE(CODIGO BIGINT,
			  DESCRIP CHARACTER VARYING(50),
			  EXISTENCIAS INTEGER)
AS $$
BEGIN
	RETURN QUERY
	SELECT CODIGO_BARRAS, DESCRIPCION, STOCK
	FROM PRODUCTO
	WHERE STOCK < 3;
END; $$
LANGUAGE PLPGSQL;

SELECT * FROM FMENOSDETRES();

--FUNCION QUE RETORNA LA VENTA TOTAL DE UNA FECHA O UN PERIODO EN DONDE SE EMPLEÓ--
--LA SOBRECARGA DE FUNCIONES, LA PRIMER FUNCIÓN ES PARA UN FECHA EN ESPECIFICO Y--
--LA SEGUNDA PARA UN PERIODO --
CREATE OR REPLACE FUNCTION fGANANCIASPERIODO(FECHA1 DATE)
RETURNS NUMERIC
AS $$
	DECLARE GANANCIA NUMERIC:= (SELECT SUM(TOTAL_VENTA)
								FROM VENTA
								WHERE FECHA_VENTA = FECHA1);
	BEGIN
		RETURN GANANCIA;
	END; $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fGANANCIASPERIODO(FECHA1 DATE, FECHA2 DATE)
RETURNS NUMERIC
AS $$
	DECLARE GANANCIA NUMERIC:= (SELECT SUM(TOTAL_VENTA)
								FROM VENTA
								WHERE FECHA_VENTA 
								BETWEEN  FECHA1 AND FECHA2);
	BEGIN
		RETURN GANANCIA;
	END; $$
LANGUAGE PLPGSQL; 

SELECT FGANANCIASPERIODO('2021/01/24');
SELECT FGANANCIASPERIODO('2021/01/24', '2021/01/25');

--FUNCIÓN QUE PERMITE LA VALIDACIÓN DEL STOCK Y TAMBIÉN SU DECREMENTO--
--ADEMÁS DE QUE ES PARTE DEL TRIGGER QUE DESENCADENA LA ACCIÓN--
CREATE OR REPLACE FUNCTION DecrementoStock()
RETURNS TRIGGER
AS $$
DECLARE CANTIDAD INTEGER;
BEGIN
	CANTIDAD = (SELECT STOCK FROM PRODUCTO WHERE CODIGO_BARRAS = NEW.CODIGO_BARRAS);
	IF (CANTIDAD > 3) THEN
		UPDATE PRODUCTO SET STOCK = (STOCK - NEW.CANTIDAD_ARTICULO) 
		WHERE CODIGO_BARRAS = NEW.CODIGO_BARRAS;
	ELSEIF(CANTIDAD = 0) THEN
		RAISE NOTICE 'PRODUCTO AGOTADO EN EXISTENCIAS';
		ROLLBACK;
	ELSE
		UPDATE PRODUCTO SET STOCK = (STOCK - NEW.CANTIDAD_ARTICULO) 
		WHERE CODIGO_BARRAS = NEW.CODIGO_BARRAS;
		RAISE NOTICE 'PRODUCTO PROXIMO A AGOTARSE';
	END IF;
	RETURN NEW;
END; $$
LANGUAGE PLPGSQL;