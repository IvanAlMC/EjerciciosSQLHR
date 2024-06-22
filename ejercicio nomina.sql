4.Comparar el valor de la nómina por departamento con el valor
promedio de la nómina de los departamentos. Si el valor de la nómina de un departamento
es mayor que el valor promedio de la nómina del los departamentos, mostrar
el nombre del departamento y su valor

SELECT d.department_name, SUM(e.salary) AS nomina_dep
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id
GROUP BY(d.department_id, d.department_name)
HAVING SUM(e.salary) > (SELECT AVG(t.nomina_d) AS prom_n FROM (SELECT SUM(e2.salary) AS nomina_d
                    FROM hr.employees e2, hr.departments d2
                    WHERE e2.department_id = d2.department_id
                    GROUP BY(d2.department_id)
                    ) t
                )