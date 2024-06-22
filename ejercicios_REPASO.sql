1.Buscar el nombre, el apellido y el salario del empleado que fue
contratado en la organización en el mes de septiembre y actualmente
tienen el mayor salario.


SELECT e.employee_id, e.first_name, e.last_name, e.salary
FROM hr.employees e
WHERE EXTRACT(MONTH FROM hire_date) = 09
AND e.salary IN(
	SELECT MAX(salary)
        FROM hr.employees 
        WHERE EXTRACT(MONTH FROM hire_date) = 09
        AND employee_id IN (
		SELECT employee_id
                FROM hr.employees
                MINUS
                SELECT employee_id
                FROM hr.job_history
                )
       );

2.Buscar los nombres de los departamentos que tienen empleados
relacionados.

SELECT d.department_name
FROM hr.departments d
WHERE d.department_id IN(
    SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING COUNT (employee_id) > 0
    );

3.Buscar el nombre del departamento con mayor número de empleados
usando HAVING

SELECT department_id
FROM hr.employees
GROUP BY department_id
HAVING COUNT(employee_id) = (
    SELECT MAX(contador)
    FROM (
	SELECT department_id, COUNT(employee_id) contador
        FROM hr.employees
        GROUP BY department_id) T
	);

4.Comparar el valor de la nómina por departamento con el valor
promedio de la nómina. Si el valor de la nómina de un departamento
es mayor que el valor promedio de la nómina de la empresa, mostrar
el nombre del departamento y su valor

SELECT d.department_name, SUM(e.salary) AS nomina_dep
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY(d.department_id, d.department_name)
HAVING SUM(e.salary) > (
	SELECT AVG(e1.salary) AS prom_n 
        FROM hr.employees e1
        );

5.Una consulta que muestre el nombre de cada departamento,
localización (ciudad), número de empleados y promedio de salario, sin
incluir comisión, de todos los empleados de cada departamento.
Haga redondeo del promedio del salario a dos cifras decimales.

SELECT d.department_name, l.city, t.cant_emp, t.prom_sal
FROM hr.departments d, hr.locations l,
(SELECT d.department_id, d.department_name, NVL(COUNT(e.employee_id), 0) AS cant_emp, ROUND(NVL(AVG(e.salary), 0), 2) AS prom_sal
FROM hr.employees e RIGHT JOIN hr.departments d
ON e.department_id = d.department_id
GROUP BY (d.department_id, d.department_name)) t
WHERE d.department_id = t.department_id
AND d.location_id = l.location_id;


6.Proyección de incremento de la comisión con respecto a la siguiente
escala:
• Si el empleado tiene un salario menor a 5000 y lleva más de 10 años
en la compañía a la comisión actual se le sumará 0,8 a la comisión
existente.
• Si el empleado tiene un salario entre 5000 y 10000, y lleva más de 15
años en la compañía a la comisión actual se le sumará 0,4 a la
comisión existente.
• Si el empleado lleva más de 20 años en la compañía a la comisión
actual se le sumará 0,1 a la comisión existente.
• Para los demás empleados mantenga la comisión actual, si no tiene
comisión debe salir 0.
El resultado debe tener las columnas: NOMBRE COMPLETO, SALARIO,
AÑOS DE TRABAJO, COMISIÓN ACTUAL y COMISIÓN PROYECTADA

SELECT (e.first_name || e.last_name) AS full_name, 
e. salary AS salario, 
(extract(year from sysdate) - extract(year from e.hire_date)) AS anios_trab,
NVL(e.commission_pct, 0) AS c_actual, 
CASE
    WHEN (salary < 5000) AND ((extract(year from sysdate) - extract(year from e.hire_date)) > 10)
        THEN NVL(e.commission_pct,0) + 0.8
    WHEN (salary BETWEEN 5000 AND 10000) AND ((extract(year from sysdate) - extract(year from e.hire_date)) > 15)
        THEN NVL(e.commission_pct, 0) + 0.4
    WHEN ((extract(year from sysdate) - extract(year from e.hire_date)) > 20)
        THEN NVL(e.commission_pct,0) + 0.1
    ELSE NVL(e.commission_pct,0) + 0
END AS c_proyectada
FROM hr.employees e;

7.Muestre en una consulta el nombre del empleado, la fecha de
contratación, el día de la semana en que se contrató y TODA la fecha
en números romanos.

SELECT e.first_name, e.hire_date, 
(TO_CHAR(e.hire_date, 'DAY', 'nls_date_language=spanish') || TO_CHAR(e.hire_date, 'DD')) AS dia_cont,
(TO_CHAR(TO_CHAR(e.hire_date, 'DD'), 'RN')||'-'||
TO_CHAR(TO_CHAR(e.hire_date, 'MM'), 'RN')||'-'||
TO_CHAR(TO_CHAR(e.hire_date, 'YYYY'), 'RN')) AS fecha_romano
FROM hr.employees e;

8.Se necesita conocer el nombre del departamento, el empleado que lo
dirige y la ciudad en la que se encuentra.

SELECT d.department_name, m.employee_id AS manager_id, l.city 
FROM hr.employees m, hr.departments d, hr.locations l
WHERE m.employee_id = d.manager_id
AND d.location_id = l.location_id

9.Elabore una consulta que reporte todos los nombres completos de los
empleados en cuyo departamento trabajan menos de 15 personas y el
departamento tiene un promedio de salarios superior a 20000.

SELECT e.first_name || ' ' || e.last_name AS full_name
FROM hr.employees e
WHERE e.department_id IN(
    SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING COUNT (employee_id) < 15
    )
AND e.department_id IN(SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING AVG (salary) > 9999
    );

10.Se desea proyectar un cambio en las comisiones de los empleados, el
reporte que se le pide debe mostrar lo siguiente:
- Nombre Completo
- Tiempo en años trabajando para la compañía
- Salario
- Fecha de Contratación (Formato 15-Abril-15)
- Nuevo porcentaje de comisión, bajo las siguientes condiciones: Si el
empleado lleva trabajando más de 10 años será de 50%, Si el
empleado lleva trabajando entre 5 y 10 años será de 25% Para los
demás será de 5%.

SELECT (e.first_name || e.last_name) AS full_name,
(extract(year from sysdate) - extract(year from e.hire_date)) AS anios_trab,
e.salary AS salario,
(TO_CHAR(e.hire_date, 'DD "-" Month "-" YY', 'NLS_DATE_LANGUAGE=SPANISH')) AS fech_contr,
CASE
    WHEN (extract(year from sysdate) - extract(year from e.hire_date)) > 10
        THEN (NVL(e.commission_pct,0)*0) + 0.5
    WHEN (extract(year from sysdate) - extract(year from e.hire_date)) BETWEEN 5 AND 10
        THEN (NVL(e.commission_pct, 0)*0) + 0.25
    ELSE (NVL(e.commission_pct,0)*0) + 0.05
END AS new_commission
FROM hr.employees e;

11.Reporte del promedio de salario por departamento, incluyendo solo
los empleados cuyo código es par

SELECT d.department_id, NVL(AVG(t.salary),0) AS nomina_d
FROM (
SELECT * FROM hr.employees e
WHERE MOD(e.employee_id,2) = 0) t
RIGHT JOIN hr.departments d
ON t.department_id = d.department_id
GROUP BY(d.department_id);

12.Apellido más común entre los empleados

SELECT e.last_name
FROM hr.employees e
GROUP BY e.last_name
HAVING COUNT(e.last_name) =(
    SELECT MAX(i.total) FROM(
        SELECT COUNT(t.last_name) as total
        FROM hr.employees t
        GROUP BY t.last_name
        ) i
    );

13.Nombre de los empleados cuya sumatoria de los tres primeros dígitos
del teléfono es par

SELECT first_name FROM hr.employees
WHERE MOD(SUBSTR(phone_number,1,1)
+ SUBSTR(phone_number,2,1)
+ SUBSTR(phone_number,3,1)
,2) = 0;

14.Nombre de los departamentos que tienen más de 5 empleados con el
cargo IT Programmer

SELECT d.department_name 
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
AND e.employee_id IN(
    SELECT e1.employee_id
    FROM hr.employees e1, hr.jobs j
    WHERE e1.job_id = j.job_id
    AND j.job_title IN ('Programmer')
    )
GROUP BY (d.department_id, d.department_name)
HAVING COUNT(e.employee_id) > 5;

15.Nombre de los departamentos a los que pertenece al menos un
empleado que tenga más de cinco empleados a su cargo

SELECT d.department_name
FROM hr.departments d, (SELECT e.employee_id, e.department_id FROM hr.employees e
    WHERE e.employee_id IN(
        SELECT m.employee_id AS manager_id
        FROM hr.employees e1, hr.employees m
        WHERE e1.manager_id = m.employee_id
        GROUP BY (m.employee_id)
        HAVING COUNT (e1.employee_id) > 5
        )
    ) t
WHERE t.department_id = d.department_id
GROUP BY(d.department_id, d.department_name)
HAVING COUNT(t.employee_id) > 1;

16.Elabore una tabla llamada CONTRACT con los siguientes atributos:
- contract_id
- contract_date
- contract_duration
- salary
- employee_id
Determine los tipos de datos, contemple adicionalmente que el
contract_id es la llave primaria de la tabla y el employee_id debe
relacionarse con la tabla EMPLOYEES del modelo.


CREATE TABLE CONTRACTS (
	contract_id		    NUMBER(22)		NOT NULL,
	contract_date	    DATE    	            ,
	contract_duration	DATE	    	        ,
	salary			    NUMBER(8,2)				,
	employee_id		    NUMBER(22)		NOT NULL,
	CONSTRAINT CON_PK_IDCO PRIMARY KEY(contract_id)
);

ALTER TABLE CONTRACTS ADD(
	CONSTRAINT con_fk_idem FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
	CONSTRAINT con_ck_cdcd CHECK(contract_date < contract_duration)
);


17.Realice 5 inserciones en la tabla creada, con la información de los 5
top empleados, con el salario más alto.

INSERT INTO CONTRACTS
  (contract_id, contract_date, contract_duration, salary, employee_id)
  
SELECT employee_id+1, sysdate, sysdate+30, salary, employee_id FROM(
    SELECT employee_id, first_name, salary, RANK() OVER(ORDER BY salary DESC) salary_rank
    FROM hr.employees
    ) s
WHERE salary_rank <= 5;

18.Realice una consulta que permita saber la cantidad de empleados
contratados por mes

SELECT TO_CHAR(e.hire_date, 'MONTH', 'nls_date_language=spanish') AS mes_contr, COUNT (employee_id) AS canti_emp
FROM hr.employees e 
GROUP BY TO_CHAR(e.hire_date, 'MONTH', 'nls_date_language=spanish');







