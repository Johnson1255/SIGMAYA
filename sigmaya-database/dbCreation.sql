CREATE TABLE tbl_paises (
    pais_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE
);

CREATE TABLE tbl_regiones (
    region_id BIGINT PRIMARY KEY,
    pais_id INTEGER REFERENCES tbl_paises(pais_id),
    nombre VARCHAR(100) UNIQUE
);

CREATE TABLE tbl_ciudades (
    ciudad_id BIGINT PRIMARY KEY,
    region_id BIGINT REFERENCES tbl_regiones(region_id),
    nombre VARCHAR(100) UNIQUE,
    rural BOOLEAN
);

CREATE TABLE tbl_grupos_etnicos (
    etnia_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    descripcion TEXT
);

CREATE TABLE tbl_identidades_genero (
    identidad_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    descripcion TEXT
);

CREATE TABLE tbl_estado_civil (
    estado_civil_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_estados (
    estado_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_tipos_documento (
    tipo_documento_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_niveles_academicos (
    nivel_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_tipos_contrato (
    tipo_contrato_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_modalidades (
    modalidad_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);


CREATE TABLE tbl_sedes (
    sede_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    UNIQUE (nombre)
);

CREATE TABLE tbl_usuarios (
    usuario_id CHAR(9) PRIMARY KEY,
    tipo_documento SMALLINT REFERENCES tbl_tipos_documento(tipo_documento_id),
    numero_documento VARCHAR(20),
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    email_institucional VARCHAR(100) UNIQUE,
    email_personal VARCHAR(100),
    telefono VARCHAR(20),
    telefono_emergencia VARCHAR(20),
    direccion VARCHAR(200),
    ciudad_origen BIGINT REFERENCES tbl_ciudades(ciudad_id),
    genero SMALLINT REFERENCES tbl_identidades_genero(identidad_id),
    etnia SMALLINT REFERENCES tbl_grupos_etnicos(etnia_id),
    fecha_nacimiento DATE,
    estado_civil SMALLINT REFERENCES tbl_estado_civil(estado_civil_id),
    estado SMALLINT REFERENCES tbl_estados(estado_id),
    fecha_creacion DATE,
    foto_perfil VARCHAR
);

CREATE TABLE tbl_cargos_administrativos (
    cargo_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    descripcion TEXT,
    nivel_jerarquico INT
);

CREATE TABLE tbl_niveles_acceso (
    nivel_acceso_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE,
    descripcion TEXT,
    permisos TEXT
);

CREATE TABLE tbl_departamentos (
    departamento_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    descripcion TEXT,
    sede_id INTEGER REFERENCES tbl_sedes(sede_id)
);


CREATE TABLE tbl_administrativos (
    administrativo_id CHAR(9) PRIMARY KEY REFERENCES tbl_usuarios(usuario_id),
    cargo_id SMALLINT REFERENCES tbl_cargos_administrativos(cargo_id),
    departamento_id SMALLINT REFERENCES tbl_departamentos(departamento_id),
    nivel_acceso_id SMALLINT REFERENCES tbl_niveles_acceso(nivel_acceso_id),
    fecha_vinculacion DATE
);

CREATE TABLE tbl_escuelas (
    escuela_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sede_id INTEGER REFERENCES tbl_sedes(sede_id),
    area_conocimiento VARCHAR(50),
    decano_id CHAR(9) REFERENCES tbl_administrativos(administrativo_id),
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    UNIQUE (nombre)
);

CREATE TABLE tbl_facultades (
    facultad_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    escuela_id SMALLINT REFERENCES tbl_escuelas(escuela_id),
    director_id CHAR(9) REFERENCES tbl_administrativos(administrativo_id),
    fecha_creacion DATE,
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    UNIQUE (nombre)
);

CREATE TABLE tbl_estados_estudiante (
    estado_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_tipos_admision (
    tipo_admision_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);

CREATE TABLE tbl_periodos_academicos (
    periodo_id INTEGER PRIMARY KEY,
    anio INT,
    semestre VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado_id SMALLINT REFERENCES tbl_estados(estado_id)
);

CREATE TABLE tbl_estudiantes (
    estudiante_id CHAR(9) PRIMARY KEY REFERENCES tbl_usuarios(usuario_id),
    estado_id SMALLINT REFERENCES tbl_estados_estudiante(estado_id),
    condicion_especial VARCHAR(100),
    tipo_admision_id SMALLINT REFERENCES tbl_tipos_admision(tipo_admision_id),
    fecha_ingreso DATE,
    cohorte_id SMALLINT REFERENCES tbl_periodos_academicos(periodo_id),
    promedio_acumulado DECIMAL(3,2)
);

CREATE TABLE tbl_profesores (
    profesor_id CHAR(9) PRIMARY KEY REFERENCES tbl_usuarios(usuario_id),
    nivel_academico_id SMALLINT REFERENCES tbl_niveles_academicos(nivel_id),
    tipo_contrato_id SMALLINT REFERENCES tbl_tipos_contrato(tipo_contrato_id),
    fecha_vinculacion DATE DEFAULT CURRENT_DATE,
    especialidad VARCHAR
);

CREATE TABLE tbl_credenciales (
    credencial_id BIGINT PRIMARY KEY,
    usuario_id CHAR(9) REFERENCES tbl_usuarios(usuario_id),
    username VARCHAR(50),
    password_hash VARCHAR(100),
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    fecha_expiracion_password DATE DEFAULT CURRENT_DATE + INTERVAL '90 days',
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    intentos_fallidos INT,
    fecha_ultimo_acceso DATE,
    ip_ultimo_acceso VARCHAR(20),
    bloqueado BOOLEAN,
    UNIQUE (username)
);

CREATE TABLE tbl_programas_academicos (
    programa_id SMALLINT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    facultad_id SMALLINT REFERENCES tbl_facultades(facultad_id),
    nivel_id SMALLINT REFERENCES tbl_niveles_academicos(nivel_id),
    duracion_semestres INT,
    director_id CHAR(9) REFERENCES tbl_profesores(profesor_id),
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    modalidad_id SMALLINT REFERENCES tbl_modalidades(modalidad_id)
);

CREATE TABLE tbl_materias (
    materia_id CHAR(4) PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    tipo_programa VARCHAR(50),
    descripcion TEXT
);

CREATE TABLE tbl_cursos (
    curso_id CHAR(4) PRIMARY KEY,
    materia_id CHAR(4) REFERENCES tbl_materias(materia_id),
    titulo VARCHAR(100),
    creditos INT,
    intensidad_horaria INT,
    contenido_tematico TEXT,
    estado_id SMALLINT REFERENCES tbl_estados(estado_id)
);

CREATE TABLE tbl_secciones (
    nrc CHAR(5) PRIMARY KEY,
    curso_id CHAR(4) REFERENCES tbl_cursos(curso_id),
    periodo_id SMALLINT REFERENCES tbl_periodos_academicos(periodo_id),
    profesor_id CHAR(9) REFERENCES tbl_profesores(profesor_id),
    sede_id INTEGER REFERENCES tbl_sedes(sede_id),
    cupo_maximo INT,
    horario TEXT,
    aula VARCHAR(50),
    modalidad_id SMALLINT REFERENCES tbl_modalidades(modalidad_id)
);

CREATE TABLE tbl_inscripciones_curso (
    inscripcion_id BIGINT PRIMARY KEY,
    estudiante_id CHAR(9) REFERENCES tbl_estudiantes(estudiante_id),
    nrc CHAR(5) REFERENCES tbl_secciones(nrc),
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    nota_final DECIMAL(3,2)
);

CREATE TABLE tbl_programas_estudiantes (
    programa_estudiante_id BIGINT PRIMARY KEY,
    estudiante_id CHAR(9) REFERENCES tbl_estudiantes(estudiante_id),
    programa_id SMALLINT REFERENCES tbl_programas_academicos(programa_id),
    sede_id INTEGER REFERENCES tbl_sedes(sede_id),
    periodo_ingreso_id SMALLINT REFERENCES tbl_periodos_academicos(periodo_id),
    creditos_aprobados INT,
    estado_id SMALLINT REFERENCES tbl_estados(estado_id),
    fecha_egreso DATE
);

CREATE TABLE tbl_detalles_calificaciones (
    detalle_calificacion_id BIGINT PRIMARY KEY,
    nrc CHAR(5) REFERENCES tbl_secciones(nrc),
    actividad VARCHAR(100),
    porcentaje DECIMAL(3,2)
);

CREATE TABLE tbl_calificaciones_parciales (
    calificacion_parcial_id BIGINT PRIMARY KEY,
    estudiante_id CHAR(9) REFERENCES tbl_estudiantes(estudiante_id),
    nota DECIMAL(3,2),
    fecha_calificacion DATE DEFAULT CURRENT_DATE,
    detalle_calificacion_id BIGINT REFERENCES tbl_detalles_calificaciones(detalle_calificacion_id),
    estado_id SMALLINT REFERENCES tbl_estados (estado_id),
    observaciones TEXT
);

CREATE TABLE tbl_calificaciones_finales (
    calificacion_final_id BIGINT PRIMARY KEY,
    nrc CHAR(5) REFERENCES tbl_secciones(nrc),
    estudiante_id CHAR(9) REFERENCES tbl_estudiantes(estudiante_id),
    nota_final DECIMAL(3,2),
    estado_id SMALLINT REFERENCES tbl_estados(estado_id)
);

CREATE TABLE tbl_prerrequisitos (
    prerrequisito_id SMALLINT PRIMARY KEY,
    materia_id CHAR(4) REFERENCES tbl_materias(materia_id),
    prerrequisito_materia_id CHAR(4) REFERENCES tbl_materias(materia_id)
);

--- Procedimientos almacenados, Trigger y funciones


CREATE SEQUENCE seq_materia_id
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION generate_materia_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.materia_id := LPAD(nextval('seq_materia_id')::text, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_materias
BEFORE INSERT ON tbl_materias
FOR EACH ROW
EXECUTE FUNCTION generate_materia_id();


CREATE SEQUENCE seq_curso_id
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION generate_curso_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.curso_id := LPAD(nextval('seq_curso_id')::text, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_cursos
BEFORE INSERT ON tbl_cursos
FOR EACH ROW
EXECUTE FUNCTION generate_curso_id();


CREATE SEQUENCE seq_nrc
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION generate_nrc()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nrc := LPAD(nextval('seq_nrc')::text, 5, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_secciones
BEFORE INSERT ON tbl_secciones
FOR EACH ROW
EXECUTE FUNCTION generate_nrc();

CREATE SEQUENCE seq_usuario_id
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION generate_usuario_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.usuario_id := LPAD(nextval('seq_usuario_id')::text, 9, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_usuarios
BEFORE INSERT ON tbl_usuarios
FOR EACH ROW
EXECUTE FUNCTION generate_usuario_id();
