CREATE OR REPLACE PROCEDURE puntos_por_mil (p_cedula_cliente IN NUMBER, p_valor_venta IN NUMBER)

IS

validar_cedula NUMBER;
--------------------
puntos NUMBER;
dias NUMBER;
valor NUMBER;
descuento NUMBER;
cincuenta NUMBER;
contador NUMBER;
cal_puntos NUMBER;
refe_factura NUMBER;
total_puntos NUMBER;
fecha DATE;

BEGIN

    SELECT COUNT(*) INTO validar_cedula FROM clientes WHERE pk_nu_cedula=p_cedula_cliente;     
    
    IF validar_cedula < 1 THEN
    
        INSERT INTO clientes 
        VALUES (p_cedula_cliente, 'cliente' , 'nuevo', 'sin dato', 'sin dato','31/12/1999');
        
        INSERT INTO ventas
        VALUES (refe.NEXTVAL, p_cedula_cliente, 'productos canasta familiar', p_valor_venta, SYSDATE);
        

    ELSE
    
        INSERT INTO ventas
        VALUES (refe.NEXTVAL, p_cedula_cliente, 'productos canasta familiar', p_valor_venta, SYSDATE);
        
        
    END IF;
    
    SELECT COUNT(*) INTO contador FROM puntos_clientes 
    WHERE FK_NU_CEDULA = p_cedula_cliente;
    
    SELECT PK_NU_REF INTO refe_factura
    from (SELECT * FROM ventas WHERE fk_nu_cedula = p_cedula_cliente
    ORDER BY PK_NU_REF DESC )
    WHERE ROWNUM = 1 ; 

    IF contador > 0 THEN 
        
        SELECT DA_PUNTOS INTO fecha FROM puntos_clientes
        WHERE fk_nu_cedula = p_cedula_cliente;
        
        SELECT NU_PUNTOS INTO puntos FROM puntos_clientes 
        WHERE fk_nu_cedula = p_cedula_cliente;
        
        SELECT F_DIAS(TO_DATE(fecha), SYSDATE) INTO dias FROM DUAL;
                
        IF dias > 30 OR dias IS NOT NULL THEN
        
        
             IF puntos > 1999 THEN
                 SELECT TRUNC(puntos/2000)*50 INTO cincuenta FROM DUAL;
                 SELECT puntos+cincuenta INTO valor FROM DUAL;
                 SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
                 SELECT TRUNC((puntos*1)/100) INTO descuento FROM DUAL;
                 total_puntos := (valor+cal_puntos+puntos)-descuento;              
                --listo para actualizar puntos
                 UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, nu_puntos_venci = descuento, da_puntos = SYSDATE
                 WHERE fk_nu_cedula = p_cedula_cliente;
                 
                ELSE IF puntos < 1999 THEN 
                    SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
                    SELECT TRUNC((puntos*1)/100) INTO descuento FROM DUAL;
                    total_puntos :=(cal_puntos+puntos)- descuento;
                    --listo para actualizar puntos
                    UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, nu_puntos_venci = descuento, da_puntos = SYSDATE
                    WHERE fk_nu_cedula = p_cedula_cliente;
                ELSE 
                    SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
                    total_puntos := puntos + cal_puntos;
                    --Insertar datos
                    UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, nu_puntos_venci = descuento, da_puntos = SYSDATE
                    WHERE fk_nu_cedula = p_cedula_cliente;
               END IF;
               
            END IF;
            
         ELSE 
         
            IF puntos > 1999 THEN
                 SELECT TRUNC(puntos/2000)*50 INTO cincuenta FROM DUAL;
                 SELECT puntos+cincuenta INTO valor FROM DUAL;
                 SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
                 total_puntos := valor+cal_puntos+puntos;              
                --listo para actualizar puntos
                 UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, da_puntos = SYSDATE
                 WHERE fk_nu_cedula = p_cedula_cliente;
             ELSE
                SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
                total_puntos :=cal_puntos+puntos;
                --listo para actualizar puntos
                UPDATE puntos_clientes SET fk_nu_ref_venta = refe_factura, nu_puntos = total_puntos, da_puntos = SYSDATE
                WHERE fk_nu_cedula = p_cedula_cliente;
            END IF;
            
         END IF;
         
    ELSE
        SELECT calc_puntos(p_valor_venta) INTO cal_puntos FROM DUAL;
        total_puntos := cal_puntos;
        --Insertar datos
        INSERT INTO puntos_clientes
        VALUES (p_cedula_cliente, refe_factura, total_puntos, 0, SYSDATE);
    END IF;

END;

EXECUTE PUNTOS_POR_MIL (105430168,100000);

select * from clientes;
select * from ventas;
select * from puntos_clientes;

INSERT INTO VENTAS 
VALUES (refe.nextval, 105430168, 'canasta familiar', 200000, '01/04/20' );

INSERT INTO puntos_clientes
VALUES (105430168, 1003, 220, 0, '01/04/20')

