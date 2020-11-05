SELECT TRUNC(puntos/2000)*50 INTO cincuenta FROM DUAL;
SELECT puntos+cincuenta INTO valor FROM DUAL;

CREATE OR REPLACE FUNCTION calc_puntos (f_venta NUMBER)
RETURN NUMBER

IS

resultado NUMBER;
cien_mil NUMBER;

BEGIN
       
    IF f_venta > 99999 THEN
        SELECT TRUNC(f_venta/100000)*10 INTO cien_mil FROM DUAL;
        SELECT TRUNC(f_venta/1000)+cien_mil INTO resultado FROM DUAL;
        RETURN resultado;
    ELSE
       SELECT TRUNC(f_venta/1000) INTO resultado FROM DUAL;
       RETURN resultado; 
    END IF;   
    
END;

CREATE OR REPLACE FUNCTION F_DIAS(p_fecini DATE, p_fecfin DATE) 
RETURN NUMBER

IS

v_dias  NUMBER := 0;

BEGIN

SELECT TRUNC ( p_fecfin )- ADD_MONTHS (TRUNC ( p_fecini ),
FLOOR ( MONTHS_BETWEEN ( TRUNC ( p_fecfin ), 
TRUNC ( p_fecini ) ) ) )  + 1 INTO v_dias FROM DUAL;
RETURN v_dias;

EXCEPTION
   WHEN OTHERS
   THEN
   RETURN 0;
   
END F_DIAS;

CREATE OR REPLACE FUNCTION puntos_calculo_cincuenta (f_puntos NUMBER)
RETURN NUMBER
IS

cincuenta NUMBER;
valor NUMBER;
descuento NUMBER;


BEGIN

    IF f_puntos > 1999 THEN
    
    SELECT TRUNC(f_puntos/2000)*50 INTO cincuenta FROM DUAL;
    SELECT f_puntos+cincuenta INTO valor FROM DUAL;
    RETURN valor;
    
    ELSE
    
    SELECT TRUNC((f_puntos*1)/100) INTO descuento FROM DUAL;
    
    END IF;

END;

SELECT TRUNC((f_puntos*1)/100) INTO descuento FROM DUAL;