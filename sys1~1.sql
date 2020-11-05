 create directory dir_tmp as 'c:\temp';
 grant read, write on directory dir_tmp to public;
 
 set SERVEROUTPUT on;
 
 create or replace procedure escribir is
  v_archivo utl_file.file_type;
begin
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_utl_file.csv', 'w');

  utl_file.put_line (v_archivo, 'Prueba de escritura');

  utl_file.put (v_archivo, 'Texto sin fin de línea');
  utl_file.put_line (v_archivo, ' que sigue y termina acá.');

  utl_file.fclose(v_archivo); 
end;

EXECUTE escribir();
/
 
create or replace procedure leer is
  v_archivo utl_file.file_type;
  v_linea varchar2(1024);
begin
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_utl_file.csv', 'r');
  loop
    utl_file.get_line (v_archivo, v_linea);
    dbms_output.put_line (v_linea);
  end loop; 
 --utl_file.fclose(v_archivo);
exception
  when no_data_found then
--Debemos cerrar, el archivo aqui ya que en el momento que no encuentre lineas salta directamente a la la execpción y no lo cerraría.
  utl_file.fclose(v_archivo);
    dbms_output.put_line ('Fin del archivo');
end;
/

execute leer();

CREATE TABLE mensajes (
ms1 VARCHAR2(400),
ms2 VARCHAR2(400)
);

create or replace procedure extraer is
varchivo utl_file.file_type;
vnomarch varchar2(1000) := 'test_utl_file.txt';
vdirectorio varchar2(80) := 'c:\temp';
vexiste boolean not null := TRUE;
vcadena varchar2(1000);

begin
varchivo := utl_file.fopen(vdirectorio,vnomarch,'r');
while vexiste loop
begin 
utl_file.get_line(varchivo,vcadena);

if vcadena is not null then
dbms_output.put_line(vcadena); -- Cada linea la tienes en la
-- variable v_cadena
end if;
exception
when no_data_found then
utl_file.fclose(varchivo);
vexiste := FALSE;
end;
end loop;
end;
/ 

execute extraer()

