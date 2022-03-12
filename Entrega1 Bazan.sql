/*Crear schema y usarlo*/
CREATE DATABASE proyecto_tracker;
USE proyecto_tracker;


/*Crear tabla seniorities indicando columnas, tipo de datos y PK*/
CREATE TABLE seniorities (
	id_sry INT AUTO_INCREMENT PRIMARY KEY, 
    seniority VARCHAR(30)
);

/*Crear tabla team_members indicando columnas, tipo de datos y PK*/
CREATE TABLE team_members (
	legajo INT NOT NULL PRIMARY KEY,
	dni INT,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	id_sry INT,
    
    CONSTRAINT FK_id_sry FOREIGN KEY (id_sry)
		REFERENCES seniorities (id_sry)
    );

/*Crear tabla client_employees indicando columnas, tipo de datos y PK*/    
CREATE TABLE client_employees (
	id_c_emp INT NOT NULL PRIMARY KEY,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	puesto VARCHAR(100)
);

/*Crear tabla connect_requests indicando columnas, tipo de datos y claves*/ 
CREATE TABLE connect_requests (
	id_cr INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	nombre VARCHAR(200) NOT NULL,
	descripcion VARCHAR(2000),
	requestee INT NOT NULL,
    cr_owner INT NOT NULL,
    cr_dd DATE NOT NULL,
    
    CONSTRAINT FOREIGN KEY (requestee)
		REFERENCES team_members (legajo),
    CONSTRAINT FOREIGN KEY (cr_owner)
		REFERENCES client_employees (id_c_emp)
    );
    
/* Crear tabla P_DueDates_I_F indicando columnas, tipo de datos y claves*/    
CREATE TABLE P_DueDates_I_F (
	id_p_dd INT AUTO_INCREMENT PRIMARY KEY,
    id_cr INT,
    p_dd DATE NOT NULL, 
    
    CONSTRAINT FK_id_cr FOREIGN KEY (id_cr)
		REFERENCES connect_requests (id_cr)
);


/*Crear tabla internal_files indicando columnas, tipo de datos y claves*/    
CREATE TABLE internal_files (
	nombre VARCHAR(100) PRIMARY KEY,
	id_cr INT NOT NULL,
	preparer INT NOT NULL,
    id_p_dd INT,
    reviewer INT NOT NULL,	
    dd_r DATE NOT NULL,
	
	CONSTRAINT FK_id_cr_i_f FOREIGN KEY (id_cr)
		REFERENCES connect_requests (id_cr),
        
    CONSTRAINT FK_preparer_i_f FOREIGN KEY (preparer)
		REFERENCES team_members (legajo),
	
    CONSTRAINT FK_id_p_dd_i_f FOREIGN KEY (id_p_dd)
		REFERENCES P_DueDates_I_F (id_p_dd),
        
	CONSTRAINT FK_reviewer_i_f FOREIGN KEY (reviewer)
		REFERENCES team_members (legajo)
    );

/*Crear tabla project_status indicando columnas, tipo de datos y claves*/  
CREATE TABLE project_status (
	id_stat INT NOT NULL PRIMARY KEY,
	descripcion VARCHAR(50) NOT NULL
    );

/*Crear tabla tracker_tareas_preps indicando columnas, tipo de datos y claves*/  
CREATE TABLE tracker_tareas_preps (
	id_tareas INT PRIMARY KEY, 
	id_cr INT NOT NULL,
	nombre_i_f VARCHAR(100),
    preparer_i_f INT NOT NULL,
    id_p_dd INT NOT NULL,
    id_stat INT NOT NULL,
    desvio INT,
	
	CONSTRAINT FOREIGN KEY (id_cr)
		REFERENCES connect_requests (id_cr),
        
    CONSTRAINT FOREIGN KEY (nombre_i_f)
		REFERENCES internal_files (nombre),
        
	CONSTRAINT FOREIGN KEY (preparer_i_f)
		REFERENCES internal_files (preparer),
    
    /* Al querer agregar la FK (due_date_prep_i_f) me salto error: Missing index for constraint in the reference table 'internal_files'.
    No supe bien como arreglarlo . Termine generando la tabla 'P_DueDates_I_F' pero no se si es lo mas eficiente.*/
    
    CONSTRAINT FOREIGN KEY (id_p_dd)
		REFERENCES P_DueDates_I_F (id_p_dd),
	
    CONSTRAINT FOREIGN KEY (id_stat)
		REFERENCES project_status (id_stat)
);