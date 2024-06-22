1. Sobre HR Crear un bloque anónimo que imprima la cantidad de
empleados sin comisión

DECLARE
    v_cantidad_emp NUMBER(3);
BEGIN
    SELECT COUNT(e.employee_id) INTO v_cantidad_emp
    FROM hr.employees e
    WHERE commission_pct IS NULL;
    DBMS_OUTPUT.PUT_LINE ('Cantidad empleados sin comision: ' || v_cantidad_emp);
END;

2.Escriba un bloque que imprima el número de empleados que trabajan
en un departamento ingresado por el usuario. El departamento se
identifica por el id.

DECLARE
    v_cant_empl NUMBER(3);
    v_name_dep VARCHAR(30);
BEGIN
    SELECT e.department_id, COUNT(e.employee_id) INTO v_name_dep, v_cant_empl
    FROM hr.employees e
    WHERE e.department_id = '&valor'
    GROUP BY(e.department_id);
    DBMS_OUTPUT.PUT_LINE ('Cantidad empleados en el departamento ' ||v_name_dep|| ': '|| v_cant_empl);
END;

3.Crear un bloque que imprima por consola un empleado que se
compone por unicamente las columnas obligatorias de la tabla
employees, los datos del empleado se ingresan por consola. (Usar
ROWTYPE)

DECLARE
    v_employee hr.employees%ROWTYPE;
BEGIN
    SELECT * INTO v_employee
    FROM hr.employees
    WHERE employee_id = &id_emple
    AND last_name = '&apellido'
    AND email = '&email'
    AND hire_date = TO_DATE('&fecha', 'dd-MM-yyyy')
    AND job_id = '&id_trab';
    DBMS_OUTPUT.PUT_LINE ('id: ' || v_employee.employee_id || ', apellido: ' || v_employee.last_name 
        || ', email: ' || v_employee.email || ', fecha contratacion: ' || v_employee.hire_date || ', trabajo: ' || v_employee.job_id);
END;

4.Usando VARIABLE muestre el código del departamento 130.

VARIABLE RESULT NUMBER;
BEGIN
    SELECT department_id INTO :RESULT
    FROM hr.departments
    WHERE department_id = '130';
END;
/
PRINT RESULT;

5.Cree un bloque que imprima la suma de todos los salarios de los
empleados.

DECLARE 
    v_sum_sal NUMBER(22);
BEGIN
    SELECT SUM(salary) INTO v_sum_sal
    FROM hr.employees;
    DBMS_OUTPUT.PUT_LINE ('Suma salario: ' || v_sum_sal);
END;

6.Haga un bloque que borre los empleados del departamento 270 y 10.
Nota: verificar resultados y hacer roll back.

CREATE TABLE employees2 AS SELECT *  FROM hr.employees;/*esta tabla se uso ya que no se puede modificar las de oracle live*/

BEGIN
   DELETE FROM employees2 WHERE department_id = '270' OR department_id = '10';
   DBMS_OUTPUT.PUT_LINE('Se borro: ' || SQL%ROWCOUNT || ' fila(s)');
   ROLLBACK;
END;


7.a. Cree la tabla reporte con una columna de tipo numérico.
b. Cree un bloque que inserte en la tabla , números del 1 al 10
excepto el 6 y el 8 (usar commit en el bloque).

CREATE TABLE reporte(
	dato_num	NUMBER(22)  NOT NULL
);

DECLARE
    v_x NUMBER :=1;
BEGIN
    LOOP
        INSERT INTO reporte VALUES(v_x);
    v_x := 
        CASE v_x
            WHEN 5 THEN v_x + 2
            WHEN 7 THEN v_x + 2
        ELSE v_x + 1
        END;
    EXIT WHEN v_x > 10;
    END LOOP;
    COMMIT;
END;

SELECT * FROM reporte

8.Se necesita un reporte que calcule la comisión de los empleados,
según los siguientes criterios:
a. Si el salario es menor a 2.200 la comisión sería del 20%
b. Si el salario esta entre 2.200 y 7.000 sería del 15%
c. Si el salario es superior a 10.000 sería del 10%
d. Si existe algún empleado sin salario sería de 0
El reporte debe mostrar, código del empleado, salario y comisión
recibida.

DECLARE
CURSOR c_employees IS (SELECT employee_id, salary, CASE 
        WHEN salary < 2200 
            THEN (NVL(commission_pct, 0)*0)+0.20 
        WHEN salary BETWEEN 2200 AND 7000
            THEN (NVL(commission_pct, 0)*0)+0.15 
        WHEN salary > 10000 
            THEN (NVL(commission_pct, 0)*0)+0.10 
        WHEN salary IS NULL 
            THEN (NVL(commission_pct, 0)*0) 
        ELSE NVL(commission_pct, 0)
        END as commission_pct
    FROM hr.employees);
BEGIN
FOR aux IN c_employees LOOP
DBMS_OUTPUT.PUT_LINE('id: ' || aux.employee_id
||' salario: '||
aux.salary||' comision: '|| aux.commission_pct);
END LOOP;
END;


9.a. Cree una tabla con la misma estructura que employees
b. Ingrese los datos de los empleados 166, 180, 192 y 206
c. En un programa PL actualice la información de esos empleados
siguiendo estos parámetros:
i. Actualizar manager_id a nulo
ii. Actualizar el salario a el mayor de la tabla employees
d. El programa debe informar el estado de actualización de los
registros.
e. Verificar de manera manual que los cambios se realizaron.
f. Borrar tabla.

CREATE TABLE employees3 AS (SELECT *  FROM hr.employees WHERE employee_id IN(166, 180, 192, 206));

SELECT * FROM employees3;

DECLARE
    v_max_sal hr.employees.salary%TYPE;
    CURSOR c_employees3 IS (SELECT * FROM employees3);
BEGIN
    SELECT MAX(salary) INTO v_max_sal FROM hr.employees;
    UPDATE employees3 SET manager_id = NULL;
    DBMS_OUTPUT.PUT_LINE('Se actualizaron: ' || SQL%ROWCOUNT || ' fila(s)');
    FOR aux IN c_employees3 LOOP
        DBMS_OUTPUT.PUT_LINE('id: ' || aux.employee_id
        ||' salario: '||
        aux.salary||' manager: '|| aux.manager_id);
    END LOOP;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------');
    UPDATE employees3 SET salary = v_max_sal;
    DBMS_OUTPUT.PUT_LINE('Se actualizaron: ' || SQL%ROWCOUNT || ' fila(s)');
    FOR aux IN c_employees3 LOOP
        DBMS_OUTPUT.PUT_LINE('id: ' || aux.employee_id
        ||' salario: '||
        aux.salary||' manager: '|| aux.manager_id);
    END LOOP;
    ROLLBACK;
END;

-----------------------------------------------------------------

DECLARE
    v_max_sal hr.employees.salary%TYPE;
    CURSOR c_employees3 IS (SELECT * FROM employees3);
BEGIN
    SELECT MAX(salary) INTO v_max_sal FROM hr.employees;
    UPDATE employees3 SET manager_id = NULL;
    DBMS_OUTPUT.PUT_LINE('Se actualizaron: ' || SQL%ROWCOUNT || ' fila(s)');
    FOR aux IN c_employees3 LOOP
        DBMS_OUTPUT.PUT_LINE('id: ' || aux.employee_id
        ||' salario: '||
        aux.salary||' manager: '|| aux.manager_id);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------');
    UPDATE employees3 SET salary = v_max_sal;
    DBMS_OUTPUT.PUT_LINE('Se actualizaron: ' || SQL%ROWCOUNT || ' fila(s)');
    FOR aux IN c_employees3 LOOP
        DBMS_OUTPUT.PUT_LINE('id: ' || aux.employee_id
        ||' salario: '||
        aux.salary||' manager: '|| aux.manager_id);
    END LOOP;
    ROLLBACK;
END;


DROP TABLE employees3;
