CREATE TABLE areas (
    pk_in_id_area          INTEGER NOT NULL,
    var_descripcion_area   VARCHAR2(50) NOT NULL
);

ALTER TABLE areas ADD CONSTRAINT areas_pk PRIMARY KEY ( pk_in_id_area );

CREATE TABLE registros (
    pk_in_id_registro        INTEGER NOT NULL,
    in_nivel_satisfaccioni   INTEGER,
    areas_pk_in_id_area      INTEGER NOT NULL,
    tim_fecha_registro       TIMESTAMP 
);

ALTER TABLE registros ADD CONSTRAINT registros_pk PRIMARY KEY ( pk_in_id_registro );

CREATE TABLE usuarios (
    pk_in_id_user    INTEGER NOT NULL,
    var_username     VARCHAR2(16) NOT NULL,
    var_contrasena   VARCHAR2(20) NOT NULL
);

ALTER TABLE usuarios ADD CONSTRAINT usuarios_pk PRIMARY KEY ( pk_in_id_user );

ALTER TABLE registros
    ADD CONSTRAINT registros_areas_fk FOREIGN KEY ( areas_pk_in_id_area )
        REFERENCES areas ( pk_in_id_area );


