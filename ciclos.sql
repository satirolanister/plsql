create table temporal (
contador number,
mensaje varchar2(100)
);

create or replace procedure bucle_simple
as
v_contador BINARY_INTEGER:=1;
begin
LOOP
insert into temporal
values (v_contador, 'Indice del bucle');
v_contador := v_contador + 1;
if v_contador > 50 then 
exit;
END if;
end loop;
END bucle_simple;

execute bucle_simple();

select * from temporal;

create or replace procedure bucle_simple2A
as
v_contador binary_integer:=1;

begin

loop

insert into temporal
values (v_contador, 'indice del bucle');
v_contador:=v_contador + 1;

exit when v_contador>100;
end loop;
end bucle_simple2A;

execute bucle_simple2A(); 

select * from temporal;

create or replace procedure bucle_simple3
as
v_contador BINARY_INTEGER:=10;
begin

insert into temporal
values (v_contador, 'Indice del bucle');

for contador in 20..30 loop

INSERT into temporal
values (contador, 'Indice del bucle');
v_contador := v_contador + 1;

end loop;

END bucle_simple3;

execute bucle_simple3();

select * from temporal;

create or replace procedure bucle_while
as
v_contador BINARY_INTEGER:=1;
begin
while v_contador <= 100 LOOP
Insert into temporal
Values (v_contador, 'indice del bucle');
v_contador := v_contador + 1;
END LOOP;
END bucle_while;

execute bucle_while();

select * from temporal;

create or replace procedure bucle_simple_s_reversa
as
v_contador binaty_integer:=10;
begin

insert into temporal
values (v_contador, 'indice del bucle');

for contador in reverse 20..30 loop

insert into temporal
values (contador, 'indice del bucle');
v_contador := v_contador + 1;
end loop;
end bucle_simple_s_reversa;

execute bucle_simple_s_reversa();