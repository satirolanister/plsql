CREATE OR REPLACE PROCEDURE Transaccion(importe NUMBER,
   ctaOrigen VARCHAR2,
   ctaDestino VARCHAR2)
AS
/*Declaracion de variables para incluirlos en los cursores implicitos*/
    saldoO NUMBER;
    saldoD NUMBER;
    cuentaO VARCHAR2(30);
    cuentaD VARCHAR2(30);
/*Begin inicio de lo que va a realizar el procedimiento almacenado*/    
BEGIN
    /*Uso del primer cursos implicito para verificar cuenta origen*/
    SELECT count(*) INTO cuentaO FROM cuentas
    WHERE cuenta = ctaOrigen;
    /*Uso del segundo cursos implicito para verificar cuenta origen*/
    SELECT count(*) INTO cuentaD FROM cuentas
    WHERE cuenta = ctaDestino;
    /*evalua si la cuenta origen ingresada como parametro del procedimiento 
    es igual a lo encontrado en el cursor*/
    IF (cuentaO = 1) THEN
    /*Uso del tercer cursos implicito para verificar cuenta el saldo de la cuenta
    origen*/
        SELECT saldo INTO saldoO FROM cuentas 
        WHERE cuenta = ctaOrigen;
        /*evalua si la cuenta destino ingresada como parametro del procedimiento 
        es igual a lo encontrado en el cursor*/
        
        IF (cuentaD = 1) THEN
        /*Uso del cuarto cursos implicito para verificar cuenta el saldo de la cuenta
         origen*/
            SELECT saldo INTO saldoD FROM cuentas 
            WHERE cuenta = ctaDestino;
            /*verifica si el importe es menor que el saldo de la cuenta origen*/
            IF (saldoO>importe) THEN
            /*Si la condicion anterior se cumple realiza la transaccion*/
                UPDATE cuentas SET saldo = saldo - importe
                WHERE cuenta = ctaOrigen;
                
                UPDATE cuentas SET saldo = saldo + importe
                WHERE cuenta = ctaDestino;
              /*Aqui realiza un registro de la operacion*/  
                INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                    VALUES
                    (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'SI');
                
                INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                    VALUES
                    (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'SI');
               /*Si se realiza esta correctamente la transaccion arroja el 
               siguiente mensaje*/     
                DBMS_OUTPUT.PUT_LINE('Transaccion Realizada con exito');    
            
            ELSE
            /*Si la operacion no es exitosa arroja el siguiente mensaje*/
                DBMS_OUTPUT.PUT_LINE('Saldos insuficiente para esta transacción');
                /*Ingresa el movimiento que se intento realizar e indicara que no 
                fue posible realizarlo*/
                INSERT INTO MOVIMIENTOS
                    (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                    VALUES
                    (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'NO');
                
                INSERT INTO MOVIMIENTOS
                    (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                    VALUES
                    (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'NO');
            END IF;
        ELSE
        /*Si la cuenta destino no existe entonces arroja el siguiente mensaje */
            DBMS_OUTPUT.PUT_LINE('La cuenta destino no existe');
        /*Ingresa el movimiento que se intento realizar*/    
            INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                VALUES
                (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'NO');
                
            INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                VALUES
                (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'NO');
        END IF;
    ELSE
    /*Si la cuenta origen no existe arroja el siguiente mensaje*/
        DBMS_OUTPUT.PUT_LINE('La cuenta origen no existe');
     /*Ingresa el movimiento que se intento realizar*/     
        INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                VALUES
                (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'NO');
                
        INSERT INTO MOVIMIENTOS
                (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
                VALUES
                (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'NO');
    END IF;
    
EXCEPTION 


/*Si algun error inesperado sucede arroja el siguiente mensaje*/
WHEN OTHERS THEN

     dbms_output.put_line('Error en la transaccion: '||SQLERRM);
     
END Transaccion;

/*Permite ver los mensajes por consola*/
set SERVEROUTPUT on;
/*Ejecucion de procedimiento anteriormente creado*/
EXECUTE transaccion(1700000,'89012345','1234567');

EXECUTE transaccion(170000,'1234567','89012345');

EXECUTE transaccion(1700000,'1234567','89012345');

EXECUTE transaccion(1700000,'1234567','890123456');

select * from cuentas;
