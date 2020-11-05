create or replace PROCEDURE calculadora(x_1 in INTEGER, x_2 in INTEGER, operacion in VARCHAR2) IS
resultado NUMBER(20):=0;
BEGIN
  CASE operacion
    WHEN '+' THEN 
       resultado := x_1 + x_2;
           DBMS_OUTPUT.PUT_LINE(x_1||' + '||x_2||' = '||resultado);
    WHEN '-' THEN
       resultado := x_1 - x_2;
           DBMS_OUTPUT.PUT_LINE(x_1||' - '||x_2||' = '||resultado);
    WHEN '*' THEN
       resultado := x_1 * x_2;
           DBMS_OUTPUT.PUT_LINE(x_1||' * '||x_2||' = '||resultado);
    WHEN '/' THEN
       resultado := x_1 / x_2;
           DBMS_OUTPUT.PUT_LINE(x_1||' / '||x_2||' = '||resultado);
    WHEN '' THEN
       resultado := MOD(x_1,x_2);
           DBMS_OUTPUT.PUT_LINE(x_1||' % '||x_2||' = '||resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Operador invalido');
    END CASE;
END calculadora;

set SERVEROUTPUT on;

EXEC calculadora(6,2,'%')
