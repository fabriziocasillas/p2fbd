-- =============================================================
-- Proyecto: Farmacia de otro mundo
-- Equipo: Añañines
-- Fundamentos de Bases de Datos, Facultad de Ciencias, UNAM 2026-II
-- =============================================================

-- -------------------------------------------------------------
-- i. Mostrar el nombre completo de todos los clientes,
--    junto con su nombre de usuario (en dado caso que se tenga una cuenta).
-- -------------------------------------------------------------
SELECT
    c.id_cliente,
    (c.nombre || ' ' || c.apellido_paterno || ' ' || c.apellido_materno) AS nombre_completo,
    c.usuario
FROM Cliente c
ORDER BY c.id_cliente;


-- -------------------------------------------------------------
-- ii. Calcular cuántos medicamentos ha comprado cada cliente.
--     (suma de cantidades de medicamentos en sus tickets)
-- -------------------------------------------------------------
SELECT
    c.id_cliente,
    (c.nombre || ' ' || c.apellido_paterno || ' ' || c.apellido_materno) AS cliente,
    COALESCE(SUM(im.cantidad), 0) AS total_medicamentos_comprados
FROM Cliente c
LEFT JOIN Ticket t              ON t.id_cliente = c.id_cliente
LEFT JOIN IncluirMedicamento im ON im.id_ticket = t.id_ticket
GROUP BY c.id_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
HAVING COALESCE(SUM(im.cantidad), 0) > 0
ORDER BY total_medicamentos_comprados DESC;


-- -------------------------------------------------------------
-- iii. Listar todas las enfermeras cuyo apellido materno contenga 'lo'.
-- -------------------------------------------------------------
SELECT
    p.cedula_profesional,
    p.nombre,
    p.apellido_paterno,
    p.apellido_materno,
    e.tipo_procedimiento,
    e.certificacion_reanimacion
FROM Enfermera e
JOIN Personal  p ON p.cedula_profesional = e.cedula_profesional
WHERE p.apellido_materno ILIKE '%lo%'
ORDER BY p.apellido_materno;


-- -------------------------------------------------------------
-- iv. Obtener clientes que hayan realizado al menos 2 compras.
-- -------------------------------------------------------------
SELECT
    c.id_cliente,
    (c.nombre || ' ' || c.apellido_paterno || ' ' || c.apellido_materno) AS cliente,
    COUNT(t.id_ticket) AS total_compras
FROM Cliente c
JOIN Ticket t ON t.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
HAVING COUNT(t.id_ticket) >= 2
ORDER BY total_compras DESC;


-- -------------------------------------------------------------
-- v. Calcular el precio bruto por ticket.
--    Bruto = suma de (precio_publico * cantidad) de medicamentos e insumos,
--            más el precio de la consulta (si existe).
--    Es el precio total ANTES de IVA.
-- -------------------------------------------------------------
SELECT
    t.id_ticket,
    t.id_cliente,
    t.id_sucursal,
    t.fecha,
    COALESCE(meds.subtotal, 0) AS subtotal_medicamentos,
    COALESCE(ins.subtotal , 0) AS subtotal_insumos,
    COALESCE(co.precio   , 0)  AS precio_consulta,
    (COALESCE(meds.subtotal, 0) + COALESCE(ins.subtotal, 0) + COALESCE(co.precio, 0)) AS precio_bruto
FROM Ticket t
LEFT JOIN (
    SELECT im.id_ticket, SUM(m.precio_publico * im.cantidad) AS subtotal
    FROM IncluirMedicamento im
    JOIN Medicamento m ON m.id_producto = im.id_producto
    GROUP BY im.id_ticket
) meds ON meds.id_ticket = t.id_ticket
LEFT JOIN (
    SELECT ii.id_ticket, SUM(i.precio_publico * ii.cantidad) AS subtotal
    FROM IncluirInsumo ii
    JOIN Insumo i ON i.id_producto = ii.id_producto
    GROUP BY ii.id_ticket
) ins ON ins.id_ticket = t.id_ticket
LEFT JOIN Consulta co ON co.id_ticket = t.id_ticket
ORDER BY t.id_ticket;


-- -------------------------------------------------------------
-- vi. Calcular el precio neto por ticket.
--     Neto = precio bruto + 16% de IVA.
-- -------------------------------------------------------------
SELECT
    t.id_ticket,
    t.id_cliente,
    t.id_sucursal,
    t.fecha,
    (COALESCE(meds.subtotal, 0) + COALESCE(ins.subtotal, 0) + COALESCE(co.precio, 0)) AS precio_bruto,
    ROUND((COALESCE(meds.subtotal, 0) + COALESCE(ins.subtotal, 0) + COALESCE(co.precio, 0)) * 1.16, 2) AS precio_neto
FROM Ticket t
LEFT JOIN (
    SELECT im.id_ticket, SUM(m.precio_publico * im.cantidad) AS subtotal
    FROM IncluirMedicamento im
    JOIN Medicamento m ON m.id_producto = im.id_producto
    GROUP BY im.id_ticket
) meds ON meds.id_ticket = t.id_ticket
LEFT JOIN (
    SELECT ii.id_ticket, SUM(i.precio_publico * ii.cantidad) AS subtotal
    FROM IncluirInsumo ii
    JOIN Insumo i ON i.id_producto = ii.id_producto
    GROUP BY ii.id_ticket
) ins ON ins.id_ticket = t.id_ticket
LEFT JOIN Consulta co ON co.id_ticket = t.id_ticket
ORDER BY t.id_ticket;


-- -------------------------------------------------------------
-- vii. Calcular el precio total que ha pagado cada cliente.
--      Total = suma de los precios netos (con IVA) de todos sus tickets.
-- -------------------------------------------------------------
WITH ticket_bruto AS (
    SELECT
        t.id_ticket,
        t.id_cliente,
        (COALESCE((SELECT SUM(m.precio_publico * im.cantidad)
                   FROM IncluirMedicamento im
                   JOIN Medicamento m ON m.id_producto = im.id_producto
                   WHERE im.id_ticket = t.id_ticket), 0)
         + COALESCE((SELECT SUM(i.precio_publico * ii.cantidad)
                     FROM IncluirInsumo ii
                     JOIN Insumo i ON i.id_producto = ii.id_producto
                     WHERE ii.id_ticket = t.id_ticket), 0)
         + COALESCE((SELECT co.precio FROM Consulta co WHERE co.id_ticket = t.id_ticket), 0)
        ) AS bruto
    FROM Ticket t
)
SELECT
    c.id_cliente,
    (c.nombre || ' ' || c.apellido_paterno || ' ' || c.apellido_materno) AS cliente,
    ROUND(SUM(tb.bruto * 1.16), 2) AS total_pagado
FROM Cliente c
JOIN ticket_bruto tb ON tb.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
ORDER BY total_pagado DESC;


-- -------------------------------------------------------------
-- viii. Listar enfermeros que atendieron consultas
--       durante mayo a octubre de 2025.
-- -------------------------------------------------------------
SELECT DISTINCT
    p.cedula_profesional,
    (p.nombre || ' ' || p.apellido_paterno || ' ' || p.apellido_materno) AS enfermero,
    e.tipo_procedimiento
FROM Consulta co
JOIN Enfermera e ON e.cedula_profesional = co.cedula_profesional_enfermera
JOIN Personal p ON p.cedula_profesional = e.cedula_profesional
WHERE co.fecha BETWEEN DATE '2025-05-01' AND DATE '2025-10-31'
ORDER BY enfermero;


-- -------------------------------------------------------------
-- ix. Mostrar a todos los proveedores junto con los productos que proveen,
--     indicando el precio unitario por producto.
--     (Se incluyen tanto medicamentos como insumos)
-- -------------------------------------------------------------
SELECT
    pr.numero_proveedor,
    pr.razon_social,
    m.id_producto,
    m.nombre        AS producto,
    'Medicamento'   AS tipo,
    m.precio_unitario
FROM Proveedor pr
JOIN ProveerMedicamento pm ON pm.numero_proveedor = pr.numero_proveedor
JOIN Medicamento m         ON m.id_producto      = pm.id_producto
UNION ALL
SELECT
    pr.numero_proveedor,
    pr.razon_social,
    i.id_producto,
    i.nombre        AS producto,
    'Insumo'        AS tipo,
    i.precio_unitario
FROM Proveedor pr
JOIN ProveerInsumo pi ON pi.numero_proveedor = pr.numero_proveedor
JOIN Insumo i         ON i.id_producto      = pi.id_producto
ORDER BY numero_proveedor, tipo, id_producto;


-- -------------------------------------------------------------
-- x. Mostrar las sucursales que posean al menos 2 médicos.
-- -------------------------------------------------------------
SELECT
    s.id_sucursal,
    s.nombre AS sucursal,
    COUNT(*) AS total_medicos
FROM Sucursal s
JOIN Personal p ON p.id_sucursal = s.id_sucursal
JOIN Medico  md ON md.cedula_profesional = p.cedula_profesional
GROUP BY s.id_sucursal, s.nombre
HAVING COUNT(*) >= 2
ORDER BY total_medicos DESC;


-- -------------------------------------------------------------
-- xi. Listar a los vendedores (sucursales) cuyo total de productos vendidos
--     (número de productos DISTINTOS que ofrecen) sea mayor a 3.
-- -------------------------------------------------------------
SELECT
    s.id_sucursal,
    s.nombre AS sucursal,
    COUNT(DISTINCT p.id_producto) AS productos_distintos
FROM Sucursal s
JOIN (
    SELECT id_producto, id_sucursal FROM VenderMedicamento
    UNION
    SELECT id_producto, id_sucursal FROM VenderInsumo
) p ON p.id_sucursal = s.id_sucursal
GROUP BY s.id_sucursal, s.nombre
HAVING COUNT(DISTINCT p.id_producto) > 3
ORDER BY productos_distintos DESC;


-- -------------------------------------------------------------
-- xii. Listar a los proveedores cuyo total de productos que proveen
--      (número de productos DISTINTOS que proveen) sea mayor a 3.
-- -------------------------------------------------------------
SELECT
    pr.numero_proveedor,
    pr.razon_social,
    COUNT(DISTINCT pp.id_producto) AS productos_distintos
FROM Proveedor pr
JOIN (
    SELECT numero_proveedor, id_producto FROM ProveerMedicamento
    UNION
    SELECT numero_proveedor, id_producto FROM ProveerInsumo
) pp ON pp.numero_proveedor = pr.numero_proveedor
GROUP BY pr.numero_proveedor, pr.razon_social
HAVING COUNT(DISTINCT pp.id_producto) > 3
ORDER BY productos_distintos DESC;


-- -------------------------------------------------------------
-- xiii. Obtener las ganancias y pérdidas totales por cada sucursal.
--       Ganancia = ingreso por ventas (suma del bruto de todos los tickets de la sucursal).
--       Pérdida  = costo de adquisición pagado a proveedores
--                  (precio_unitario del producto * cantidad suministrada).
-- -------------------------------------------------------------
SELECT
    s.id_sucursal,
    s.nombre AS sucursal,
    COALESCE(ganancias.total, 0) AS ganancias,
    COALESCE(perdidas.total , 0) AS perdidas,
    (COALESCE(ganancias.total, 0) - COALESCE(perdidas.total, 0)) AS utilidad
FROM Sucursal s
LEFT JOIN (
    -- INGRESOS: suma del bruto (medicamentos + insumos + consultas) por sucursal
    SELECT
        t.id_sucursal,
        SUM(
            COALESCE((SELECT SUM(m.precio_publico * im.cantidad)
                      FROM IncluirMedicamento im
                      JOIN Medicamento m ON m.id_producto = im.id_producto
                      WHERE im.id_ticket = t.id_ticket), 0)
          + COALESCE((SELECT SUM(i.precio_publico * ii.cantidad)
                      FROM IncluirInsumo ii
                      JOIN Insumo i ON i.id_producto = ii.id_producto
                      WHERE ii.id_ticket = t.id_ticket), 0)
          + COALESCE((SELECT co.precio FROM Consulta co
                      WHERE co.id_ticket = t.id_ticket), 0)
        ) AS total
    FROM Ticket t
    GROUP BY t.id_sucursal
) ganancias ON ganancias.id_sucursal = s.id_sucursal
LEFT JOIN (
    -- COSTOS: suministros pagados a proveedores
    SELECT id_sucursal, SUM(costo) AS total FROM (
        SELECT pm.id_sucursal, (m.precio_unitario * pm.cantidad) AS costo
        FROM ProveerMedicamento pm
        JOIN Medicamento m ON m.id_producto = pm.id_producto
        UNION ALL
        SELECT pi.id_sucursal, (i.precio_unitario * pi.cantidad) AS costo
        FROM ProveerInsumo pi
        JOIN Insumo i ON i.id_producto = pi.id_producto
    ) t
    GROUP BY id_sucursal
) perdidas ON perdidas.id_sucursal = s.id_sucursal
ORDER BY utilidad DESC;

-- -------------------------------------------------------------
-- xiv. Mostrar clientes cuyo gasto total
--      sea superior al promedio general.
-- -------------------------------------------------------------
WITH ticket_bruto AS (
    SELECT
        t.id_ticket,
        t.id_cliente,
        (
            COALESCE(
                (SELECT SUM(m.precio_publico * im.cantidad)
                 FROM IncluirMedicamento im
                 JOIN Medicamento m ON m.id_producto = im.id_producto
                 WHERE im.id_ticket = t.id_ticket), 0
            )
            +
            COALESCE(
                (SELECT SUM(i.precio_publico * ii.cantidad)
                 FROM IncluirInsumo ii
                 JOIN Insumo i ON i.id_producto = ii.id_producto
                 WHERE ii.id_ticket = t.id_ticket), 0
            )
            +
            COALESCE(
                (SELECT co.precio
                 FROM Consulta co
                 WHERE co.id_ticket = t.id_ticket), 0
            )
        ) * 1.16 AS total_ticket
    FROM Ticket t
),
gasto_cliente AS (
    SELECT
        c.id_cliente,
        (c.nombre || ' ' || c.apellido_paterno || ' ' || c.apellido_materno) AS cliente,
        SUM(tb.total_ticket) AS gasto_total
    FROM Cliente c
    JOIN ticket_bruto tb ON tb.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nombre, c.apellido_paterno, c.apellido_materno
)
SELECT
    id_cliente,
    cliente,
    ROUND(gasto_total, 2) AS gasto_total
FROM gasto_cliente
WHERE gasto_total > (
    SELECT AVG(gasto_total)
    FROM gasto_cliente
)
ORDER BY gasto_total DESC;

-- -------------------------------------------------------------
-- xv. Mostrar productos vendidos
--     por más de una sucursal.
-- -------------------------------------------------------------
SELECT
    p.id_producto,
    p.nombre,
    p.tipo,
    COUNT(DISTINCT p.id_sucursal) AS sucursales_distintas
FROM (
    SELECT
        vm.id_producto,
        m.nombre,
        'Medicamento' AS tipo,
        vm.id_sucursal
    FROM VenderMedicamento vm
    JOIN Medicamento m ON m.id_producto = vm.id_producto

    UNION ALL

    SELECT
        vi.id_producto,
        i.nombre,
        'Insumo' AS tipo,
        vi.id_sucursal
    FROM VenderInsumo vi
    JOIN Insumo i ON i.id_producto = vi.id_producto
) p
GROUP BY p.id_producto, p.nombre, p.tipo
HAVING COUNT(DISTINCT p.id_sucursal) > 1
ORDER BY sucursales_distintas DESC, p.nombre;
