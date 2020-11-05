create table empleados2 (
CEDULA number,
nombre varchar(100),
apellido1 varchar(100),
fecha_nto date
);

create table pagos (
contador number(5),
salario number(20),
pais varchar2(15),
cedula number,
usuario VARCHAR2(20)
);

Insert into empleados2 values (79950240, 'Juana', 'Quevedo', '04-01-1978');
Insert into empleados2 values (79950241, 'Juan', 'Quevedon', '04-02-1979');
Insert into empleados2 values (79950242, 'Julian', 'Quevedo', '04-03-1980');
create or replace procedure n_salario (v_cedula in number, salario_hora in number, horas_trabajadas in number, bonificacion in number)
as
v_pais varchar2(120);
v_contador number:=0;
v_salario number;
v_usuario varchar2(20);
v_cedula_emp number;
validar number;

begin
    v_salario:=(horas_trabajadas * salario_hora)+ bonificacion;
    v_pais:= upper('colombia');
    

select cedula  into v_cedula_emp from empleados2 where cedula = v_cedula; 
select user into v_usuario from dual;
select count(contador) into validar from pagos;

if (validar = 0) then 
v_contador := v_contador+1;
insert into pagos values (v_contador, v_salario, v_pais, v_cedula, v_usuario);
else
select max(contador) into validar from pagos where cedula = v_cedula;
v_contador := validar+1;
insert into pagos values (v_contador, v_salario, v_pais, v_cedula, v_usuario);
end if;

DBMS_OUTPUT.PUT_LINE(v_salario);
DBMS_OUTPUT.PUT_LINE(v_pais);
DBMS_OUTPUT.PUT_LINE(v_contador);
DBMS_OUTPUT.PUT_LINE(v_usuario);
DBMS_OUTPUT.PUT_LINE(v_cedula);

end n_salario;

execute n_salario(79950240,2000,10,359);

select count(*) from pagos
