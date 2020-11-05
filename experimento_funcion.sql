CREATE OR REPLACE FUNCTION puntos_fecha_valor (f_cedula NUMBER)
RETURN NUMBER

IS

puntos NUMBER;
dias NUMBER;
valor NUMBER;
descuento NUMBER;
cincuenta NUMBER;
contador NUMBER;
valor_venta NUMBER;
cal_puntos NUMBER;
refe_factura NUMBER;
total_puntos NUMBER;


BEGIN

    SELECT COUNT(fk_nu_cedula) INTO contador FROM ventas 
    WHERE fk_nu_cedula = f_cedula;
    
    SELECT PK_NU_REF, nu_valor INTO refe_factura, valor_venta  FROM ventas 
    WHERE fk_nu_cedula = f_cedula;

    IF contador > 0 THEN 
    
        SELECT nu_puntos, TRUNC(TO_DATE(SYSDATE)) - TRUNC(TO_DATE(da_puntos))  
        INTO puntos, dias FROM puntos_clientes WHERE fk_nu_cedula = f_cedula;
        
        IF dias < 30 THEN
        
            IF puntos > 1999 THEN
                 SELECT TRUNC(puntos/2000)*50 INTO cincuenta FROM DUAL;
                 SELECT puntos+cincuenta INTO valor FROM DUAL;
                 SELECT calc_puntos(valor_venta) INTO cal_puntos FROM DUAL;
                 total_puntos := valor+cal_puntos+puntos;
                --listo para actualizar puntos
                UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, da_puntos = SYSDATE
                WHERE fk_nu_cedula = f_cedula;
                RETURN total_puntos;
            ELSE
                SELECT calc_puntos(puntos) INTO cal_puntos FROM DUAL;
                total_puntos :=cal_puntos+puntos;
                --listo para actualizar puntos
                UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, da_puntos = SYSDATE
                WHERE fk_nu_cedula = f_cedula;
                RETURN total_puntos;
            END IF;
            
         ELSE 
         
            SELECT TRUNC((puntos*1)/100) INTO descuento FROM DUAL;
            SELECT calc_puntos(puntos) INTO cal_puntos FROM DUAL;
            total_puntos := (puntos + cal_puntos) - descuento;
            --actualizados datos
            UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, nu_puntos_venci = descuento, da_puntos = SYSDATE
            WHERE fk_nu_cedula = f_cedula;
            RETURN total_puntos; 
            
         END IF;
         
    ELSE
        SELECT TRUNC((puntos*1)/100) INTO descuento FROM DUAL;
        SELECT calc_puntos(puntos) INTO cal_puntos FROM DUAL;
        total_puntos := (puntos + cal_puntos) - descuento;
        --Insertar datos
        INSERT INTO puntos_clientes
        VALUES (f_cedula, refe_factura, total_puntos, 0, SYSDATE);
        RETURN total_puntos;
    END IF;
    
END;