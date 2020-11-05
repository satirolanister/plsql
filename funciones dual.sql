declare 
letras varchar2(100) := ' HOLA ESTO ES UN MENSAJE ';
Numeros Number := 12345.67;
fechas date := sysdate;

Begin

DBMS_OUTPUT.PUT_LINE('funciones caracteres: '|| 'Lower ' || Lower(letras)|| 
', length '|| length(letras) || ', replace ' || replace(letras,'HOLA') 
|| ', lpad ' || lpad(letras,20) || ', rpad ' || rpad(letras,5) ||
', ascii ' || ascii('hola') || ', instr ' || instr(letras,'MENSAJE') || 
', substr ' || substr(letras,2,6)
|| ', translate ' || TRANSLATE(letras,'HOLA', 'hell') 
|| ', trim ' || trim(LEADING '1' from '111hola'));

DBMS_OUTPUT.PUT_LINE('Funciones numericas: ' || 'round ' || round(numeros) 
|| ', trunc ' || trunc(numeros) || ', power '|| power(numeros, 2 )|| ', sqrt ' || sqrt(numeros) 
|| ', abs ' || abs(numeros)|| ', ln ' || ln(numeros) || ',mod ' || mod(4,2) || ', sin '
|| sin(numeros) || ', cos ' || cos(numeros) || ', tan ' || tan(numeros));

DBMS_OUTPUT.PUT_LINE('funciones fecha: ' || 'add_months ' || add_months(fechas,2) || ', months_between ' || months_between(fechas,add_months(fechas,2))
|| ', sysdate ' || fechas || ', last_day ' || last_day(fechas) || 
', extract '||extract(year from fechas) || ', greatest ' || greatest(fechas,add_months(fechas,365),add_months(fechas,800))||
', least ' || least(fechas,add_months(fechas,365),add_months(fechas,800))
|| ', round '|| round(to_date (fechas), 'MONTH') || ', trunc ' || trunc(fechas,'YEAR')) ;

DBMS_OUTPUT.PUT_LINE('mi edad es: ' || trunc(months_between(sysdate,'08/08/1993')/12) );
END;
