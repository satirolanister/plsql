CREATE OR REPLACE FUNCTION
hola_mensaje (lugar_in VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN 'hola '|| lugar_in;
END hola_mensaje;

SELECT hola_mensaje ('Medellin') FROM dual;

CREATE TABLE MENSAJE (
    fecha DATE,
    texto_mensaje  VARCHAR2 (50)
);


CREATE OR REPLACE FUNCTION get_creditos
(f_id in ESTUDIANTES.ID%type) RETURN NUMBER
IS
v_creditos ESTUDIANTES.ID%type;
BEGIN
SELECT creditos INTO v_creditos
FROM estudiantes
WHERE id = f_id;
RETURN v_creditos;
END get_creditos;

CREATE OR REPLACE PROCEDURE sumar_credito (p_id NUMBER)
AS
v_creditos ESTUDIANTES.creditos%type := get_creditos(p_id);
BEGIN
UPDATE ESTUDIANTES SET creditos = v_creditos+4
WHERE id = p_id;
END sumar_credito;

SELECT get_creditos(2) FROM DUAL;

EXECUTE sumar_credito(2);

CREATE TABLE ESTUDIANTES (
    id NUMBER,
    nombre VARCHAR2(30),
    creditos NUMBER
);

INSERT INTO ESTUDIANTES
(id, nombre, creditos)
VALUES
('1', 'ALEX', 2);

INSERT INTO ESTUDIANTES
(id, nombre, creditos)
VALUES
('2', 'ALEXA', 3);

SELECT * FROM ESTUDIANTES


