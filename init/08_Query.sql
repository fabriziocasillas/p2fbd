-- Query.sql

-- i. Clientes cuyo nombre empiece con la letra R.

SELECT *
FROM cliente
WHERE nombre LIKE 'R%'; 

-- ii. Medicamentos que hayan caducado después del 20 de abril del 2026 pero antes del 07 de mayo del 2026.

SELECT *
FROM medicamento
WHERE fecha_caducidad BETWEEN '2026-04-20' AND '2026-05-07';

-- iii. Farmacéuticos que hayan nacido en el mes de noviembre.

SELECT *
FROM (
    SELECT 
        p.*,
        CASE 
            WHEN p.rfc ~ '^[A-Za-z]{3}[0-9]{6}' THEN -- El formato esperado del RFC
                TO_DATE(
                    (
                        CASE 
                            WHEN SUBSTRING(p.rfc FROM 4 FOR 2)::int >= 50 THEN '19' -- se decidió que si el año de nacimiento era 50 o mayor, era una persona nacida en el siglo XX
                            ELSE '20' -- de lo contrario se asume que nació en el siglo XXI
                        END
                    ) || SUBSTRING(p.rfc FROM 4 FOR 6),
                    'YYYYMMDD'
                )
        END AS fecha_nacimiento_calc -- Se calcula la fecha de nacimiento a partir del RFC ya que no se incluye fecha de nacimiento como atributo
    FROM farmaceutico f
    JOIN personal p 
      ON f.cedula_profesional = p.cedula_profesional
) t
WHERE EXTRACT(MONTH FROM fecha_nacimiento_calc) = 11; --nacida en noviembre

-- iv. Medicamentos cuya forma física sea gel y vía de administración sea oral.

SELECT *
FROM medicamento
WHERE forma_farmaceutica ILIKE '%gel%'
  AND via_administracion ILIKE '%oral%';

-- v. Todos los proveedores registrados en la base de datos.

SELECT *
FROM proveedor;