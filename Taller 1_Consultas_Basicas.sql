1. Concatenar 5 y Hola

SELECT '5' || 'Hola' AS Concatenacion FROM dual;

2. Nombre completo de cada empleado

SELECT first_name || ' ' || last_name AS full_name
FROM hr.employees;

3. Empleados con el salario mayor a 5000

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE salary > 5000;

4. Empleados que tengan el salario entre 100 y 5000

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE salary BETWEEN 100 AND 5000;

5. Empleados que tengan el salario igual a 3800 o 13000

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE salary = 3800
OR salary = 13000;

6. Empleados con los códigos 199, 200, 201, 188 y 194

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE employee_id IN(199, 200, 201, 188, 194);

7. Empleados donde el segundo nombre empiece por Ki

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE last_name LIKE 'Ki%';

8. Empleados cuyo nombre en donde su segundo caracter sea i

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE first_name LIKE '_i%';

9. Empleados que no tengan jefe

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees
WHERE manager_id IS NULL;

10. Cantidad de registros en la tabla employees

SELECT COUNT(employee_id) AS cantidad_empleados
FROM hr.employees;

11. Empleados con el nombre del departamento al que pertenecen

SELECT e.first_name || ' ' || e.last_name AS full_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;

12. Empleados con su id, primer nombre, el nombre del departamento y su id

SELECT e.employee_id, e.first_name, d.department_name, d.department_id
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;