-- Table TELEFONO_PROVEEDOR
CREATE TABLE TELEFONO_PROVEEDOR (
  telefono Bigint NOT NULL,
  proveedor_ID Integer NOT NULL
)
WITH (
  autovacuum_enabled=true);

ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT PK_TELEFONO_PROVEEDOR PRIMARY KEY (telefono,proveedor_ID);

-- Table PROVEEDOR
CREATE TABLE PROVEEDOR (
  proveedor_ID Integer NOT NULL,
  razon_Social Character varying(50) NOT NULL,
  nombre Character varying(30) NOT NULL,
  apellido_Paterno Character varying(30) NOT NULL,
  apellido_Materno Character varying(30),
  calle Character varying(30) NOT NULL,
  numero Integer NOT NULL,
  codigo_Postal Character varying(5) NOT NULL,
  estado Character varying(30) NOT NULL
)
WITH (
  autovacuum_enabled=true);

ALTER TABLE PROVEEDOR ADD CONSTRAINT PK_PROVEEDOR PRIMARY KEY (proveedor_ID);

-- Table CLIENTE
CREATE TABLE CLIENTE(
  cliente_ID Integer NOT NULL,
  razon_Social Character varying(50) NOT NULL,
  nombre Character varying(30) NOT NULL,
  apellido_Paterno Character varying(30) NOT NULL,
  apellido_Materno Character varying(30),
  calle Character varying(30) NOT NULL,
  numero Integer NOT NULL,
  codigo_Postal Character varying(5) NOT NULL,
  estado Character varying(30) NOT NULL
)
WITH (
  autovacuum_enabled=true);

ALTER TABLE CLIENTE ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (cliente_ID);

-- Table EMAIL_CLIENTE
CREATE TABLE EMAIL_CLIENTE (
  email Character varying(40) NOT NULL,
  cliente_ID Integer NOT NULL
)
WITH (
  autovacuum_enabled=true);

ALTER TABLE EMAIL_CLIENTE ADD CONSTRAINT PK_EMAIL_CLIENTE PRIMARY KEY (email,cliente_ID);

-- Table VENTA
CREATE TABLE VENTA (
  numero_Venta Character varying(10) NOT NULL,
  cliente_ID Integer NOT NULL,
  fecha_Venta Date NOT NULL,
  total_Venta Numeric(6,2) NOT NULL
)
WITH (
  autovacuum_enabled=true);

CREATE INDEX CLIENTEV_FK ON VENTA (cliente_ID);

ALTER TABLE VENTA ADD CONSTRAINT PK_VENTA PRIMARY KEY (numero_Venta);

-- Table DETALLES_VENTA
CREATE TABLE DETALLES_VENTA (
  numero_Venta Character varying(10) NOT NULL,
  codigo_Barras Bigint NOT NULL,
  cantidad_Articulo Integer NOT NULL,
  precio_Venta Numeric(6,2) NOT NULL
)
WITH (
  autovacuum_enabled=true);

ALTER TABLE DETALLES_VENTA ADD CONSTRAINT PK_DETALLES_VENTA PRIMARY KEY (codigo_Barras,numero_Venta);

-- Table PRODUCTO
CREATE TABLE PRODUCTO (
  codigo_Barras Bigint NOT NULL,
  marca Character varying(30) NOT NULL,
  proveedor_ID Integer NOT NULL,
  descripcion Character varying(50) NOT NULL,
  stock Integer NOT NULL,
  precio_Compra Numeric(6,2) NOT NULL,
  fecha_Adquisicion Date NOT NULL,
  regalo Boolean,
  papeleria Boolean,
  impresion Boolean,
  recarga Boolean
)
WITH (
  autovacuum_enabled=true);

CREATE INDEX PROVEEDORP_FK ON PRODUCTO (proveedor_ID);

ALTER TABLE PRODUCTO ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY (codigo_Barras);

-- Create foreign keys (relationships) section -------------------------------------------------

ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT PROVEEDORT_FK
FOREIGN KEY (proveedor_ID) REFERENCES PROVEEDOR (proveedor_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PRODUCTO ADD CONSTRAINT PROVEEDOR_FK
FOREIGN KEY (proveedor_ID) REFERENCES PROVEEDOR (proveedor_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DETALLES_VENTA ADD CONSTRAINT PRODUCTODV_FK
FOREIGN KEY (codigo_Barras) REFERENCES PRODUCTO (codigo_Barras)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DETALLES_VENTA ADD CONSTRAINT VENTADV_FK
FOREIGN KEY (numero_Venta) REFERENCES VENTA (numero_Venta)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE EMAIL_CLIENTE ADD CONSTRAINT CLIENTEEC_FK
FOREIGN KEY (cliente_ID) REFERENCES CLIENTE (cliente_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VENTA ADD CONSTRAINT CLIENTEV_FK
FOREIGN KEY (cliente_ID) REFERENCES CLIENTE (cliente_ID)
ON DELETE CASCADE ON UPDATE CASCADE;