1. Elabore una consulta que reporte todos los nombres completos de los empleados en cuyo
departamento trabajan menos de 15 personas.

SELECT e.first_name, e.last_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id 
AND d.department_id IN(
    SELECT department_id
    FROM hr.employees
    GROUP BY department_id
    HAVING COUNT (employee_id) < 15)
GROUP BY e.first_name, e.last_name;

2.Elabore una consulta que muestre el top – n de salarios con el respectivo empleado que lo
devenga, teniendo en cuenta que el valor de n lo debe ingresar el usuario (Para este caso
consulte la función RANK de Oracle).

WITH temporal AS(
	SELECT employee_id, first_name, last_name, salary,
	RANK() OVER(ORDER BY salary DESC) top
	FROM hr.employees)
SELECT first_name, last_name, salary
FROM temporal
WHERE top <= &valor;


SELECT first_name, last_name, salary
FROM (
SELECT RANK() OVER(ORDER BY salary DESC)top, first_name, last_name, salary
FROM hr.employees)
WHERE top <= 10;

3.Elabore una consulta que muestre los empleados de una región ingresada por el usuario y
que fueron contratados en el mismo mes de su jefe. El reporte debe mostrar lo siguiente: 
- Nombre completo (Nombre y Apellido) 
- Nombre del trabajo
- Antigüedad (en meses) 
- Valor del primer pago (Si el empleado fue contratado antes del 15 se le pago el 80%
del sueldo, de lo contrario solo se le pago el 40%).

SELECT e.employee_id, e.first_name, e.last_name, job_title, TRUNC(MONTHS_BETWEEN(SYSDATE,e.hire_date),0) AS meses_trabajados,
CASE
    WHEN TO_CHAR(e.hire_date, 'DD') BETWEEN 01 AND 14 
        THEN e.salary * 0.8
    ELSE e.salary * 0.4
END AS primer_salario
FROM hr.employees e, hr.employees m, hr.jobs j, hr.departments d, hr.locations l, hr.countries c, hr.regions r
WHERE e.job_id = j.job_id 
AND e.department_id = d.department_id
AND d.location_id = l.location_id 
AND l.country_id = c.country_id
AND c.region_id = r.region_id
AND m.employee_id = e.manager_id
AND TO_CHAR(e.hire_date, 'MM') = TO_CHAR(m.hire_date,'MM')
AND r.region_name = '&valor';

4. Reporte la cantidad de departamentos por país que no tienen empleados asignados.

SELECT c.country_id, c.country_name, COUNT(d.department_id) AS cantidad_dep_vacios
FROM hr.departments d, hr.locations l, hr.countries c
WHERE d.location_id = l.location_id
AND l.country_id = c.country_id
AND d.department_id IN (
    SELECT department_id
    FROM hr.departments 
    MINUS
    SELECT department_id
    FROM hr.employees)
GROUP BY c.country_id, c.country_name; 

5. Cree una consulta que muestre el nombre completo de los empleados, teléfono, región a
la que pertenece y nuevo salario. Lo anterior teniendo en cuenta que el nuevo salario se
determina bajo las siguientes condiciones: 
- Si el empleado gana menos que el promedio de salario de la compañía, en el nuevo
salario se le incrementará el 10% del salario actual. 
- Si gana más que el promedio al que pertenece se le incrementará el 5%. 
- Si no cumple ninguna de las dos condiciones se le mantendrá el salario actual.



SELECT e.first_name, e.last_name, e.phone_number, r.region_name,
CASE
    WHEN salary < salario_promedio 
        THEN e.salary + (e.salary * 0.1)
    WHEN salary > salario_promedio 
        THEN e.salary + (e.salary * 0.05)
    ELSE e.salary
    END AS new_salary
FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c, hr.regions r, (
SELECT department_ID, AVG(salary) AS salario_promedio
FROM hr.employees
GROUP BY department_ID) aux
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id
AND c.region_id = r.region_id
AND e.department_id = aux.department_id;



NOTAS:

GROUP BY: se utiliza en una instrucción SELECT para recopilar datos en varios registros y agrupar los resultados por una o más columnas.
---------------------------------------------------------------
SELECT expression1, expression2, ... expression_n, 
       aggregate_function (aggregate_expression)
FROM tables
[WHERE conditions]
GROUP BY expression1, expression2, ... expression_n;
---------------------------------------------------------------


COUNT: devuelve el recuento de una expresión
----------------------------------------------------------
SELECT COUNT(aggregate_expression)
FROM tables
[WHERE conditions];
------------------------------------------------------
SELECT expression1, expression2, ... expression_n,
       COUNT(aggregate_expression)
FROM tables
[WHERE conditions]
GROUP BY expression1, expression2, ... expression_n;
-------------------------------------------------------------



HAVING: se utiliza en combinación con la cláusula GROUP BY para restringir los grupos de filas devueltas solo a aquellas cuya condición es TRUE.
----------------------------------------------------------
SELECT expression1, expression2, ... expression_n, 
       aggregate_function (aggregate_expression)
FROM tables
[WHERE conditions]
GROUP BY expression1, expression2, ... expression_n
HAVING having_condition;
--------------------------------------------------------------



WITH: es una utilidad que materializa las subconsultas(Genera una temporal)
------------------------------------------------------------------
WITH
   nommbre_subconsulta
AS
  (El sql que se materializará)
SELECT
  (SQL en el que se usará la subconsulta);
----------------------------------------------------------------------



RANK: devuelve el rango de un valor en un grupo de valores, la función de rango puede causar clasificaciones no consecutivas si los valores probados son los mismos
---------------------------------------------------------------------------------------------
RANK( expr1 [, expr2, ... expr_n ] ) WITHIN GROUP ( ORDER BY expr1 [, expr_2, ... expr_n ] )
-------------------------------------------------------------------------------------------------


CASE:  tiene la funcionalidad de una sentencia IF-THEN-ELSE. A partir de Oracle 9i, puede utilizar la instrucción CASE dentro de una instrucción SQL.
-------------------------------------------------------------
CASE [ expression ]

   WHEN condition_1 THEN result_1
   WHEN condition_2 THEN result_2
   ...
   WHEN condition_n THEN result_n

   ELSE result

END
--------------------------------------------------------------



TO_CHAR: convierte un número o fecha en una cadena
--------------------------------------------------------------
TO_CHAR( value [, format_mask] [, nls_language] )
------------------------------------------------------------



MONTHS_BETWEEN: devuelve el número de meses entre date1 y date2 
-------------------------------------------------------------------
MONTHS_BETWEEN( date1, date2 )
--------------------------------------------------------------


MINUS: se utiliza para devolver todas las filas en la primera instrucción SELECT que no son devueltas por la segunda instrucción SELECT. 
---------------------------------------------------
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions]
MINUS
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions];
-----------------------------------------------------



SYSDATE: devuelve la fecha y hora actual del sistema en su base de datos local
------------------------------------------------
SYSDATE
-----------------------------------------------

SOUNDEX: devuelve una representación fonética (como suena) de una cadena.
------------------------------------------
SOUNDEX( string1 )

SOUNDEX('TECH ON THE NET')
Result: 'T253'

SOUNDEX('apples')
Result: 'A142'
-------------------------------------

AS: Para reemplazar el nombre de un campo del encabezado por otro
---------------------------------------------------
 select columna1,
  columna2 as "alias",
  columna3
  from tabla;
---------------------------------------------















