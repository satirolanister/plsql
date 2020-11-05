CREATE TABLE emple (
    id NUMBER,
    nombre VARCHAR2(50),
    apellido VARCHAR(50) 
);


select * from emple;

CREATE TABLE auditaremple (
    id NUMBER,
    nombre VARCHAR2 (50),
    appellido VARCHAR2(50),
    operacion VARCHAR2(100)
);

SELECT * FROM auditaremple;
    
ALTER TABLE 
    auditaremple
ADD 
    (
    momento TIMESTAMP(0)
    );

set SERVEROUTPUT on

CREATE OR REPLACE PROCEDURE p_insert_empleados
(v_id NUMBER, v_nombre VARCHAR2, v_apellido VARCHAR2)
AS
    CURSOR v_id1 IS
        SELECT id FROM emple;
    c_id emple.id%type;            
BEGIN
OPEN v_id1;
FETCH v_id1 INTO c_id;
IF c_id <> v_id THEN
    SAVEPOINT i_emple;
    INSERT INTO emple (id, nombre, apellido) 
    VALUES (v_id, v_nombre, v_apellido);

ELSE
    DBMS_OUTPUT.PUT_LINE('ID YA SE ENCUENTRA REGISTRADO');
END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrio un error' || sqlcode);
    ROLLBACK TO  SAVEPOINT i_emple;
CLOSE v_id1;
END p_insert_empleados;

EXECUTE p_insert_empleados(2,'Alex', 'Garzon');

CREATE OR REPLACE PROCEDURE p_delete_empleados
(v_id NUMBER)
AS
p_id_v NUMBER;
BEGIN
   SELECT id INTO p_id_v FROM emple; 
   SAVEPOINT d;
   IF v_id = p_id_V THEN
   DELETE FROM emple WHERE id = v_id;
   ELSE
   DBMS_OUTPUT.PUT_LINE('Id no existe');
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('');
    ROLLBACK TO SAVEPOINT D;
END p_delete_empleados;

EXECUTE p_delete_empleados(1);

CREATE OR REPLACE PROCEDURE p_update_empleados 
(p_id NUMBER, p_name VARCHAR2, p_apellido VARCHAR2, dato NUMBER)
IS
cont NUMBER;
c_id emple.id%TYPE;
CURSOR id_cu IS 
    SELECT id FROM emple WHERE id = p_id;
BEGIN
    OPEN id_cu;
    FETCH id_cu INTO c_id;
    SELECT COUNT(*) INTO cont FROM emple;    
IF cont > 0 THEN
    IF p_id = c_id THEN
       IF DATO = 1 THEN
        UPDATE emple
            SET nombre = p_name
        WHERE id = p_id;
            ELSE IF DATO = 2 THEN
                UPDATE emple
                    SET apellido = p_apellido
                WHERE id = p_id;
                    ELSE IF DATO = 3 THEN
                        UPDATE emple
                            SET nombre = p_name,
                            apellido = p_apellido
                        WHERE id = p_id;
                    END IF;
            END IF;
      END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE ('ERROR, EL ID NO EXISTE');
    END IF;
ELSE
    DBMS_OUTPUT.PUT_LINE ('ERROR, NO HAY DATOS');
END IF;    
    CLOSE id_cu;
END p_update_empleados;

EXECUTE p_update_empleados (2,'Sonia', 'Lopez', 3);

describe EMPLE;
--TRIGGER
--Aditoria
CREATE OR REPLACE TRIGGER t_control_ia
    AFTER INSERT
    ON emple
    FOR EACH ROW
BEGIN
        INSERT INTO auditaremple
        (id, nombre, appellido, operacion, momento)
        VALUES (:new.id, :new.nombre, :new.apellido, 'insert', systimestamp);
END t_control_ia;


CREATE OR REPLACE TRIGGER t_contro_bd
-- puede ser after o before y la operacion update, insert o delete
    BEFORE DELETE
    -- nombre de la tabla
    ON emple
    -- se puede recorre por fila ROW o por orden STATEMENT
    FOR EACH ROW
    -- when para condicionar para ejecutar el trigger
BEGIN
    
-- old valores viejos se coloca en el delete
-- new valores nueva este se coloca en insert 
-- old y new se pueden usar en conjunto en un update
    INSERT INTO auditaremple
    (id, nombre, appellido, operacion, momento)
    VALUES (:old.id, :old.nombre, :old.apellido, 'Delete', systimestamp);
END t_contro_bd;

CREATE OR REPLACE TRIGGER t_control_bu
BEFORE UPDATE   
    ON emple
    FOR EACH ROW
BEGIN
    INSERT INTO auditaremple
    (id, nombre, appellido, operacion, momento)
    VALUES (:old.id, :old.nombre, :old.apellido, 'Update', systimestamp);
END t_contro_bu;

--De sustitucion
-- SOLO APLICA A LAS VISTAS
CREATE OR REPLACE TRIGGER t_ejemplo_sustitucion
    INSTEAD OF DELETE OR INSERT OR UPDATE
    ON emple_view
    FOR EACH ROW
BEGIN
-- CONDICIONAL SI ES BORRADO
IF DELETING THEN
    INSERT INTO auditaremple
    VALUES (TO_CHAR(SYSDATE, 'DD/MM/YY*HH24:MI*')||OLD.emp_no|| '*'
    || OLD.apellido||' BORRADO');
-- CONDICIONAL SI ES INSERTADO    
ELSE IF INSERTING THEN
    INSERT INTO auditaremle
    VALUES (TO_CAHR(SYSDATE, 'DD/MM/YY*HH24:MI*')||
    :NEW.emp_no || '*' || NEW.apellido || ' insertado');
END IF;
END IF;

EXCEPTION
    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Se produjo un error: '|| SQLERRM );
END t_ejemplo_sustitucion;

--DE SISTEMA

CREATE OR REPLACE TRIGGER t_empleo_sistema
-- LOGON CUANDO SE LOGUEA UN USUARIO
AFTER LOGON
-- EN LA BASE DE DATOS
ON DATABASE
BEGIN
    INSERT INTO control_conexiones (usuario, momento, evento)
    -- ORA_LOGIN_USER NOMBRE DE USUARIO CONECTADO, ORA_SYSEVENT REGISTRA EL EVENTO
    VALUES (ORA_LOGIN_USER, SYSTIMESTAMP, ORA_SYSEVENT);
END t_empleo_sistema;
