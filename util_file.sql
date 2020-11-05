
create or replace directory dir_tmp as 'c:\util';

 DECLARE
  --identificar el tipo de archivoa  a generar
  v_archivo utl_file.file_type;
begin
--usar la varuibke v archivo para crear el archivo con permiso de escritura
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_de_escritura.txt', 'w');
--escribir line acompleta
  utl_file.put_line (v_archivo, 'Prueba de escritura mayo 6');
--escribir algo mas
  utl_file.put (v_archivo, 'Texto 2 sin fin de línea');
  --nuevamente escribit linea completa
  utl_file.put_line (v_archivo, ' que sigue y termina acá.');
--cerrar el archivo
  utl_file.fclose(v_archivo); 
end;


create or replace procedure abrir_bloqueado is
  v_archivo utl_file.file_type;
begin
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_de_escritura.txt', 'w');
  utl_file.fclose(v_archivo); 
  dbms_output.put_line ('Ok');

exception
   when utl_file.invalid_operation then
    dbms_output.put_line ('Error: Operacion invalida');
end;

execute abrir_bloqueado;

create or replace procedure abrir_no_lectura is
  v_archivo utl_file.file_type;
begin
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_de_escritura.txt', 'r');
  utl_file.fclose(v_archivo); 
  dbms_output.put_line ('Ok');

exception
  when utl_file.access_denied then
    dbms_output.put_line ('Erroren la lectura del archivo');
end;

execute abrir_no_lectura;

create or replace procedure abrir_no_existe is
  v_archivo utl_file.file_type;
begin
  v_archivo := utl_file.fopen ('DIR_TMP', 'test_de_escritura.txt', 'r');
  utl_file.fclose(v_archivo); 
  dbms_output.put_line ('Ok');

exception
  when utl_file.invalid_operation then
    dbms_output.put_line ('Error: operacion invalida no existe el archivo');
end;

execute abrir_no_existe;

