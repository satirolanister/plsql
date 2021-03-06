CREATE TABLE cuentas (
   cuenta VARCHAR2(30),
   saldo NUMBER
);

CREATE TABLE movimientos(

    cuenta_Origen VARCHAR2(30),
    cuenta_Destino VARCHAR2(30),
    importe NUMBER,
    f_Movimiento TIMESTAMP(0),
    se_realizo VARCHAR2(2)
    
);

INSERT INTO cuentas 
(cuenta, saldo)
VALUES
('1234567', 1000000);

INSERT INTO cuentas 
(cuenta, saldo)
VALUES
('89012345', 2000000);

/*Creacion de procedimineto almacenado para manejo de las transacciones*/
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
    SELECT cuenta INTO cuentaO FROM cuentas
    WHERE cuenta = ctaOrigen;
    /*Uso del segundo cursos implicito para verificar cuenta origen*/
    SELECT cuenta INTO cuentaD FROM cuentas
    WHERE cuenta = ctaDestino;
    /*evalua si la cuenta origen ingresada como parametro del procedimiento 
    es igual a lo encontrado en el cursor*/
    IF (cuentaO = ctaOrigen) THEN
    /*Uso del tercer cursos implicito para verificar cuenta el saldo de la cuenta
    origen*/
        SELECT saldo INTO saldoO FROM cuentas 
        WHERE cuenta = ctaOrigen;
        /*evalua si la cuenta destino ingresada como parametro del procedimiento 
        es igual a lo encontrado en el cursor*/
        
        IF (cuentaD = ctaDestino) THEN
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
              /*Aqui realiza un rehistro de la operacion*/  
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
/*Fina de procedimiento almacenado*/

/*Permite ver los mensajes por consola*/
set SERVEROUTPUT on;
/*Ejecucion de procedimiento anteriormente creado*/
EXECUTE transaccion(100000,'89012345','1234567');






CREATE OR REPLACE PROCEDURE Transaccion1(importe NUMBER,
   ctaOrigen VARCHAR2,
   ctaDestino VARCHAR2)
AS

    saldoO NUMBER;
    saldoD NUMBER;
    cuentaO VARCHAR2(30);
    cuentaD VARCHAR2(30);
    
BEGIN

    SELECT cuenta INTO cuentaO FROM cuentas WHERE cuenta = ctaOrigen;
    
    SELECT cuenta INTO cuentaD FROM cuentas WHERE cuenta = ctaDestino;
    
    IF (cuentaO = ctaOrigen) and (cuentaD = ctaDestino) THEN
    
        SELECT saldo INTO saldoO FROM cuentas
        WHERE cuenta = ctaOrigen;
        SELECT Saldo INTO saldoD FROM cuentas
        WHERE cuenta = ctaDestino;
        
        IF (saldoO IS NOT NULL) AND (saldoD IS NOT NULL)  THEN
        
            
            UPDATE cuentas SET saldo = saldo - importe
            WHERE cuenta = ctaOrigen;
            
            UPDATE cuentas SET saldo = saldo + importe
            WHERE cuenta = ctaDestino;
            
            INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'SI');
            
            INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'SI');
            
        
        ELSE
        
            INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'NO');
            INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'NO');
            DBMS_OUTPUT.PUT_LINE('Saldos en 0');
        END IF; 
        
    ELSE
    
        INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaOrigen, ctaDestino, importe*(-1), SYSTIMESTAMP, 'NO');
        INSERT INTO MOVIMIENTOS
            (cuenta_Origen, cuenta_Destino, importe, f_Movimiento, se_realizo)
            VALUES
            (ctaDestino, ctaOrigen, importe, SYSTIMESTAMP, 'NO');
        DBMS_OUTPUT.PUT_LINE('Cuenta no existe');
    END IF;  
    
EXCEPTION 

WHEN OTHERS THEN
     dbms_output.put_line('Error en la transaccion: '||SQLERRM);
END Transaccion1;

EXECUTE transaccion1(100000,'89012345','124567');

select * from cuentas

select * from movimientos

