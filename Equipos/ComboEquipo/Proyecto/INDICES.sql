-- Index: NOMBRE_CLIENTES

-- DROP INDEX public."NOMBRE_CLIENTES";

CREATE INDEX NOMBRE_CLIENTES
    ON public.cliente USING btree
    (nombre COLLATE pg_catalog.default ASC NULLS LAST)
    INCLUDE(apellido_paterno)
    TABLESPACE pg_default;

  -- Index: NOMBRE_PROVEEDORES

-- DROP INDEX public."NOMBRE_PROVEEDORES";

CREATE INDEX NOMBRE_PROVEEDORES
    ON public.proveedor USING btree
    (nombre COLLATE pg_catalog.default ASC NULLS LAST)
    INCLUDE(apellido_paterno)
    TABLESPACE pg_default;