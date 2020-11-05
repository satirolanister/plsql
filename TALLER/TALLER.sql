
CREATE TABLE PERSONAL
(
   ID NUMBER(5) PRIMARY KEY,
   NOMBRE CHAR(20),
   APELLIDO CHAR(20),
   ESPECIALIDAD CHAR(30),
   CREDITOS NUMBER
);

CREATE TABLE REGISTRO
(
MENSAJE CHAR(20)
);


INSERT INTO PERSONAL VALUES
(
   1,
   'JUAN',
   'RAMIREZ',
   'INGENIERO',
   4
);

INSERT INTO PERSONAL VALUES
(
   2,
   'MANUEL',
   'CARDENAS',
   'ECONOMISTA',
   4
);

CREATE TABLE REGISTRO2
(
  FECHA DATE,
  MENSAJE CHAR(30)
);

ALTER TABLE REGISTRO2
ADD USUARIO VARCHAR2(100);

CREATE OR REPLACE PROCEDURE CAMBIO AS
V_PERSONA NUMBER(5) := 3;
V_NOMBRE VARCHAR2(50);
V_USER VARCHAR2(50);
BEGIN
  SELECT NOMBRE
  INTO V_NOMBRE
  FROM PERSONAL
  WHERE ID = V_PERSONA;
  SELECT USER INTO V_USER FROM DUAL;  
EXCEPTION
 WHEN NO_DATA_FOUND THEN
    INSERT INTO REGISTRO2
    VALUES (SYSDATE,'NO EXISTE EL DATO', V_USER);
END CAMBIO;

set SERVEROUTPUT on

EXEC CAMBIO;

CREATE TABLE PRODUCTOS 
(
nombre VARCHAR2(60),
fabricante VARCHAR2(55),
origen VARCHAR2(30),
precio NUMBER(8,2)
);

INSERT INTO productos
(nombre, fabricante, origen, precio)
VALUES ('Soflan', 'Palmolive', 'Bogota', 132.3);

INSERT INTO productos
(nombre, fabricante, origen, precio)
VALUES ('Colgate', 'Palmolive', 'Bogota', 225.89);

INSERT INTO productos
(nombre, fabricante, origen, precio)
VALUES ('Escobas', 'eterna', 'Bogota', 456.89);

ALTER TABLE productos
  ADD precio_iva NUMBER(8,2);
   

CREATE OR REPLACE PROCEDURE incrementar_productos
AS
BEGIN
  UPDATE productos set precio = ROUND((precio + (precio*0.1))/1.19)
  WHERE fabricante = 'Palmolive';
END incrementar_productos;



exec incrementar_producto;


set serveroutput on

CREATE OR REPLACE PROCEDURE insertar_productos (v_nombre IN varchar, v_fabricante IN varchar, v_origen IN varchar, 
v_precio IN number) 
AS
BEGIN
INSERT INTO productos
(nombre, fabricante, origen, precio) VALUES (v_nombre, v_fabricante, v_origen, v_precio);

END insertar_productos;

EXEC insertar_productos ('guantes', 'eterna', 'bogota', 67)



