CREATE OR REPLACE DIRECTORY dir_archivo
AS 'c:\temp';

GRANT READ,WRITE ON DIRECTORY dir_archivo TO sys;

CREATE SEQUENCE seq_archivo
START WITH 1
INCREMENT BY 1;

DECLARE
    v_archivo  UTL_FILE.FILE_TYPE;
    v_seq NUMBER;
    v_datos VARCHAR2(500);
    v_ult_dept HR.departments.department_id%TYPE;
    v_total_sal NUMBER:=0;
    v_total_emp NUMBER:=0;
   
CURSOR c_emp_dept IS
        SELECT
        e.first_name||' '||e.last_name AS nombre,
        e.salary AS salario,
        d.department_id AS cod_dept,
        d.department_name as departamento,
        l.city AS ciudad
        FROM HR.employees e
        INNER JOIN HR.departments d ON d.department_id=e.department_id
        INNER JOIN HR.locations l ON l.location_id=d.location_id
        ORDER BY d.department_id;
BEGIN
    v_seq := seq_archivo.NEXTVAL;
    v_archivo := UTL_FILE.FOPEN('DIR_ARCHIVOS','DETALLE_EMPLEADOS'||v_seq||'.CSV','W');
    UTL_FILE.PUT_LINE(v_archivo, 'documento: empleados por departamento. '||CHR(10));
    UTL_FILE.PUT_LINE(v_archivo, 'Fecha: , lugar: ');
    UTL_FILE.PUT_LINE(v_archivo, TO_CHAR(SYSDATE, 'fmDD "de" MONTH "DEL" YYYY','nls_date_language=SPANISH')||', Bogotá D.C.'||CHR(10));
   
    FOR rec IN c_emp_dept LOOP
        IF NVL(v_ult_dept, rec.cod_dept) != rec.cod_dept THEN
            UTL_FILE.PUT_LINE(v_archivo, 'Cantidad Empleados: '||v_total_emp||',Total Salario: '||v_total_sal||CHR(10));
            v_total_emp :=0;
            v_total_sal :=0;
        END IF;
       
        v_datos :=
                    '"'||rec.nombre||
                    '","'||rec.salario||
                    '","'||rec.departamento||
                    '","'||rec.ciudad||
                    '"';
       
        v_total_emp := v_total_emp+1;
        v_ult_dept :=rec.cod_dept;
        v_total_sal :=v_total_sal+rec.salario;
       
        UTL_FILE.PUT_LINE(v_archivo,v_datos);
    END LOOP;
    UTL_FILE.PUT_LINE(v_archivo, 'Cantidad Empleados: '||v_total_emp||',Total Salario: '||v_total_sal);
    UTL_FILE.FCLOSE(v_archivo);
END;



