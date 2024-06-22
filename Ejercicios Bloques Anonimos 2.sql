a).Usando cursores, muestre empleados de la siguiente manera:
Para todos los casos mostrar el id y el salario.
1. Si su salario es menor a 5.000 mostrar BAJO
2. Si su salario está entre 5.000 y 10.000 mostrar NORMAL
3. Si su salario es superior a 10.000 mostrar ALTO

DECLARE
    CURSOR emp_cursor IS (SELECT employee_id, salary FROM hr.employees);
    v_emp emp_cursor%ROWTYPE;
    v_tipo_s VARCHAR2(30);
BEGIN
    FOR v_emp IN emp_cursor LOOP
    v_tipo_s :=
    CASE 
        WHEN v_emp.salary < 5000 THEN 'BAJO'
        WHEN v_emp.salary >= 5000 AND v_emp.salary <= 10000 THEN 'NORMAL'
        WHEN v_emp.salary > 10000 THEN 'ALTO'
    END;
        DBMS_OUTPUT.PUT_LINE (v_emp.employee_id || '  ' || v_emp.salary || ' ' || v_tipo_s);
    END LOOP;
END;

b).Mostrar los primeros 3 empleados con su departamento usando
cursores

DECLARE
    CURSOR emp_cursor IS(SELECT employee_id, department_id FROM hr.employees);
    v_emp emp_cursor%ROWTYPE;
BEGIN
    FOR v_emp IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE (v_emp.employee_id || '  ' || v_emp.department_id);
        EXIT WHEN emp_cursor %ROWCOUNT = 3;
    END LOOP;
END;

c).Cree un bloque anónimo con un cursor que contenga el nombre
del empleado y el salario.
Si el salario es superior a 15000 muestre el nombre del
empleado y salario.


DECLARE
    CURSOR emp_cursor IS
    SELECT first_name, salary
    FROM hr.employees;
    v_emp emp_cursor%ROWTYPE;
BEGIN
    FOR v_emp IN emp_cursor LOOP
        IF (v_emp.salary > 15000) THEN
        DBMS_OUTPUT.PUT_LINE (v_emp.first_name||' - '||v_emp.salary);
        END IF;
    END LOOP;
END;


Crear dos tablas, una para los empleados de Europa y otra para
los empleados de América.
Crear un bloque anónimo que inserte los empleados según su
país en su correspondiente tabla.

CREATE TABLE employeesAme AS SELECT * FROM hr.employees WHERE 1=0;
CREATE TABLE employeesEur AS SELECT * FROM hr.employees WHERE 1=0;

DECLARE
    CURSOR emp_cursor IS
        SELECT r.region_id, e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, e. hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, e.department_id
        FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c, hr.regions r
        WHERE e.department_id = d.department_id
        AND d.location_id = l.location_id
        AND l.country_id = c.country_id
        AND c.region_id = r.region_id;
    v_emp emp_cursor%ROWTYPE;
BEGIN 
    FOR v_emp IN emp_cursor LOOP
        IF (v_emp.region_id = 2) THEN
            INSERT INTO employeesAme VALUES(v_emp.employee_id, v_emp.first_name, v_emp.last_name, v_emp.email, 
            v_emp.phone_number, v_emp. hire_date, v_emp.job_id, v_emp.salary, v_emp.commission_pct, v_emp.manager_id, v_emp.department_id);
        ELSIF (v_emp.region_id = 1) THEN
            INSERT INTO employeesEur VALUES(v_emp.employee_id, v_emp.first_name, v_emp.last_name, v_emp.email, 
            v_emp.phone_number, v_emp. hire_date, v_emp.job_id, v_emp.salary, v_emp.commission_pct, v_emp.manager_id, v_emp.department_id);
        END IF;
    END LOOP;
END;

SELECT * FROM employeesAme;
SELECT * FROM employeesEur;

Cree un bloque anónimo al que se le ingresa el top-n de los
sueldos de los empleados.
El proceso debe llenar una tabla temporal con los sueldos de los
empleados.
Para el top-n no se deben tener en cuenta los repetidos.
El top-n se extrae de tabla temporal, la cual debe limpiarse tras
la ejecución

CREATE TABLE reportes(
    dato_num NUMBER(22) NOT NULL
);

DECLARE
    v_num_top NUMBER(3) := 10;
    v_salary hr.employees.salary%TYPE;
    CURSOR emp_cursor IS
        SELECT distinct salary
        FROM hr.employees
        ORDER BY salary DESC;
BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO v_salary;
    WHILE emp_cursor%ROWCOUNT <= v_num_top AND emp_cursor%FOUND
        LOOP
            INSERT INTO reportes (dato_num)
            VALUES (v_salary);
            FETCH emp_cursor INTO v_salary;
        END LOOP;
    CLOSE emp_cursor;
END;

SELECT * FROM reportes;

DELETE FROM reportes;
