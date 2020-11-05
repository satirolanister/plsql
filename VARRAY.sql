CREATE OR REPLACE PROCEDURE p_bucle
AS
v_contador binary_integer:=1;
BEGIN

WHILE v_contador <=100 LOOP
INSERT INTO temporal
VALUES (v_contador, 'indice del bucle');
v_contador := v_contador+ 1;
END LOOP;

END p_bucle;


CREATE OR REPLACE PROCEDURE p_bucle_for
AS
v_contador binary_integer:=10;
BEGIN
INSERT INTO temporal
VALUES (v_contador, 'indice del bucle');

FOR contador in 20..30 LOOP
INSERT INTO temporal
VALUES (v_contador, 'indice del bucle');
v_contador:=v_contador+ 1;
END LOOP;

END p_bucle_for;



--VARRAYS 

/*Asi se crean VARRAY*/
TYPE nombrearreglo IS VARRAY(10) OF VACHAR2(100);

CREATE OR REPLACE PROCEDURE p_varray
AS
    TYPE nombreArray IS VARRAY(5) OF VARCHAR2(100);
    TYPE curso IS VARRAY(5) OF INTEGER;
    nombre nombreArray;
    identificador_c curso;
    total INTEGER;
BEGIN
    nombre := nombreArray('Kevin','Pinto','Alex','Juan', 'Fabio');
    identificador_c := curso(12,16,32,56,76);
    total := nombre.count;
    FOR i in 1..total LOOP
        DBMS_OUTPUT.PUT_LINE('Estudiantes: ' || nombre(i) || ' identificacion: ' || identificador_c(i));
    END LOOP;
END p_varray;

set SERVEROUTPUT on

EXECUTE p_varray();


--GENERA numeros aleatorios de 1 a 45

drop table balotas;

CREATE TABLE balotas(
    p1 NUMBER,
    p2 NUMBER,
    p3 NUMBER,
    p4 NUMBER,
    p5 NUMBER,
    p6 NUMBER,
    f_registro date
);

CREATE OR REPLACE PROCEDURE p_auto
AS
    TYPE automatico is VARRAY(6) OF INTEGER;
    v_ubicacion automatico := automatico ('','','','','','');
    
BEGIN

    FOR i IN 1..v_ubicacion.count LOOP
    SELECT ROUND(ABS(DBMS_RANDOM.VALUE(1, 45))) INTO v_ubicacion(i) FROM DUAL;
    END LOOP;
    insert into balotas 
    (p1,
    p2,
    p3,
    p4,
    p5,
    p6,
    f_registro) 
    values(
    v_ubicacion(1),
    v_ubicacion(2),
    v_ubicacion(3),
    v_ubicacion(4),
    v_ubicacion(5),
    v_ubicacion(6),
    sysdate);
    FOR i IN 1..v_ubicacion.count LOOP
    DBMS_OUTPUT.PUT_LINE('Los datos son: '||v_ubicacion(i));
    END LOOP;
    
END p_auto;

EXECUTE p_auto();



set SERVEROUTPUT ON

SAVEPOINT a;

CREATE TABLE balotas(
    p1 INTEGER,
    p2 INTEGER,
    p3 INTEGER,
    p4 INTEGER,
    p5 INTEGER,
    p6 INTEGER,
    f_registro date
);

select * from balotas

CREATE OR REPLACE PROCEDURE p_balotas
AS
    TYPE automatico is VARRAY(6) OF NUMBER;
    v_ubicacion automatico := automatico ('','','','','','');
    v_posicion NUMBER;
    
BEGIN


    
END p_balotas;  
