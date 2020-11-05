

CREATE TABLE Clientes(
pk_nu_cedula NUMBER,
var_nombre VARCHAR2(50),
var_apellido VARCHAR2(50),
var_direcci VARCHAR2(50),
nu_telefo NUMBER,
da_fe_naci DATE
);

ALTER TABLE clientes
ADD CONSTRAINT pk_clientes
PRIMARY KEY (pk_nu_cedula);

CREATE TABLE puntos_clientes(
fk_nu_cedula NUMBER,
fk_nu_ref_venta NUMBER,
nu_puntos NUMBER,
nu_puntos_venci NUMBER, 
da_puntos DATE
);


CREATE TABLE ventas(
pk_nu_ref NUMBER, 
fk_nu_cedula NUMBER, 
var_descripcion VARCHAR2(400), 
nu_valor NUMBER,
da_venta DATE
);



CREATE SEQUENCE refe 
START WITH 1000
INCREMENT BY 1 
MINVALUE 1000
MAXVALUE 2000000
NOCYCLE;

ALTER TABLE ventas
ADD CONSTRAINT pk_venttas
PRIMARY KEY (pk_nu_ref);
