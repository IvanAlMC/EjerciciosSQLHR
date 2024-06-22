13. Mostrar la fecha actual mas 5 días

SELECT sysdate+5 AS new_date FROM dual; 

14. Empleados mas comisión, donde si el salario multiplicado por 0.0003 es igual a 1
mostramos BAJO, si es igual 3 MEDIO y si es igual a 5 ALTO. 

SELECT employee_id, COALESCE(commission_pct, 0) AS comision,
CASE
    WHEN ROUND(salary*0.0003, 0) = 1
        THEN 'BAJO'
    WHEN ROUND(salary*0.0003, 0) = 3
        THEN 'MEDIO'
    WHEN ROUND(salary*0.0003, 0) = 5
        THEN 'ALTO'
    ELSE 'n/a'
END AS salary_type
FROM hr.employees;

15. Cuantos días faltan para que llegue el 30 de Novimbre de 2020

SELECT TRUNC(TO_DATE('30/11/2020','DD/MM/YYYY')) - TRUNC(sysdate) as diferencia_dias
FROM dual;

16. Primer nombre, trabajo y salario mas comisión de todos los empleados

SELECT e.employee_id, e.first_name, j.job_title, (e.salary + e.salary*COALESCE(e.commission_pct, 0)) AS nomina
FROM hr.employees e, hr.jobs j
WHERE e.job_id = j.job_id;

17. Nombre completo mas número de horas trabajadas del empleado 100

SELECT employee_id, trunc(24 * (sysdate - hire_date)) as worked_hours
FROM hr.employees
WHERE employee_id IN(100);

18. Primer nombre y nombre de la región en que trabaja cada empleado

SELECT e.employee_id, e.first_name, r.region_name
FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c, hr.regions r
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id
AND c.region_id = r.region_id;

19. Cantidad de empleados con salario

SELECT COUNT(employee_id) AS cantidad_asalariados
FROM hr.employees
WHERE salary IS NOT NULL;

20. Salario por departamento

SELECT j.job_title, ROUND(SUM(e.salary),2) AS Salario_Total
FROM hr.employees e, hr.jobs j 
WHERE e.job_id = j.job_id
GROUP BY j.job_title;

21. Cantidad de empleados por Trabajo

SELECT j.job_title, COUNT(e.job_id) AS Total_Empleados
FROM hr.employees e, hr.jobs j 
WHERE e.job_id = j.job_id
GROUP BY j.job_title;

22. Cantidad de empleados con comisión

SELECT COUNT(employee_id) AS cantidad_comisionistas
FROM hr.employees
WHERE commission_pct IS NOT NULL;

23. Promedio de salarios de empleados con job_title Programmer

SELECT AVG(e.salary) AS promedio_salarios
FROM hr.employees e, hr.jobs j 
WHERE e.job_id = j.job_id
AND UPPER(job_title) LIKE UPPER('programmer');