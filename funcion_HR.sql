describe HR.employees

select * from departments
select * from jobs

CREATE OR REPLACE FUNCTION low_high_salary(
/*P_DEPT id del departamento */
p_dept NUMBER ,
/*P_JOB_ID id del cargo */
p_job_id VARCHAR2,
/*P_SAL dato para condicionar la salida de la funcion de acuerdo a L: mas bajo, H: mas bajo, B: ambos*/
p_sal IN CHAR DEFAULT'B'
)
RETURN VARCHAR2

IS
/*Recoje el salario mas alto y mas bajo de acuerdo a las condiciones despues del where*/
CURSOR c_high_low IS
    SELECT 
        MIN(salary) AS bajo,
        MAX(salary) AS alto
    FROM employees
        WHERE department_id = p_dept
        AND job_id = p_job_id;
        
v_high_low_rec c_high_low%ROWTYPE;

e_wrong_entry EXCEPTION;

BEGIN
    OPEN c_high_low;
    FETCH c_high_low INTO v_high_low_rec;
    CLOSE c_high_low;

/*validad que el salario bajo es nulo*/    
IF v_high_low_rec.bajo IS NULL THEN
    RAISE e_wrong_entry;
END IF;

CASE
    WHEN UPPER(p_sal)='B'THEN
    RETURN 'Salario mas alto: '||v_high_low_rec.alto||
            ', salario mas bajo: '||v_high_low_rec.bajo;
    WHEN UPPER(p_sal)='L'THEN
    RETURN 'Salario mas bajo: '||v_high_low_rec.bajo;
    WHEN UPPER(p_sal)='H'THEN
    RETURN 'Salario mas alto: '||v_high_low_rec.alto;
    ELSE
    RETURN 'Valores validos para p_sal: B, L, H.';
    END CASE;
    
    EXCEPTION
    /*Error de ingreso de datos*/
        WHEN e_wrong_entry THEN
            RETURN 'Debe introducir un departamento/empleo valido';
END low_high_salary;   


select low_high_salary(50,'ST_MAN','H') FROM dual;
