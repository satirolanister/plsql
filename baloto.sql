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
    p1 NUMBER;
    p2 NUMBER;
    p3 NUMBER;
    p4 NUMBER;
    p5 NUMBER;
    p6 NUMBER;
    f_registro date;
    datos balotas%ROWTYPE; 
    
   
BEGIN

    FOR i IN 1..v_ubicacion.COUNT LOOP
    SELECT ROUND(ABS(DBMS_RANDOM.VALUE(1, 46))) INTO v_ubicacion(i) FROM DUAL; 
    END LOOP;
    
    IF v_ubicacion(1) <> v_ubicacion(2) AND v_ubicacion(1)<> v_ubicacion(3) AND v_ubicacion(1)<> v_ubicacion(4) AND v_ubicacion(1)<> v_ubicacion(5) AND v_ubicacion(1)<> v_ubicacion(6)  THEN
         
         INSERT INTO balotas (p1, p2, p3, p4, p5, p6, f_registro) 
         VALUES(v_ubicacion(1), v_ubicacion(2), v_ubicacion(3), v_ubicacion(4), v_ubicacion(5), v_ubicacion(6), SYSDATE);
         
    ELSE
    
        FOR i IN 1..v_ubicacion.COUNT LOOP
        SELECT ROUND(ABS(DBMS_RANDOM.VALUE(1, 46))) INTO v_ubicacion(i) FROM DUAL;
        END LOOP;
        
        INSERT INTO balotas (p1, p2, p3, p4, p5, p6, f_registro) 
        VALUES(v_ubicacion(1), v_ubicacion(2), v_ubicacion(3), v_ubicacion(4), v_ubicacion(5), v_ubicacion(6), SYSDATE);
        
    END IF;
        
    FOR i IN 1..v_ubicacion.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('La balota número: '||i||' es '||v_ubicacion(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    
    FOR datos IN (SELECT * FROM balotas) LOOP
        DBMS_OUTPUT.PUT_LINE(datos.p1|| ' ' ||datos.p2 || ' ' ||datos.p3|| ' ' ||datos.p4|| ' ' ||datos.p5|| ' ' ||datos.p6 || ' ' ||datos.f_registro );
    END LOOP;
    
END p_auto;

EXECUTE p_auto();

set SERVEROUTPUT ON
