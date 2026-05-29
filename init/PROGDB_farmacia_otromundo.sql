-- =============================================================
-- Proyecto: Farmacia de otro mundo
-- Equipo: Añañines
-- Fundamentos de Bases de Datos, Facultad de Ciencias, UNAM 2026-II
-- =============================================================

-- Funciones

-- ============================================================
-- FUNCIÓN i: ganancias_sucursal_anio
-- Recibe el id de una sucursal y calcula las ganancias totales
-- durante el año 2026.
-- Las ganancias = suma de (precio_publico * cantidad) de cada
-- medicamento incluido en tickets de esa sucursal en 2026,
-- más el precio de cada consulta generada en la sucursal en 2026.
-- ============================================================

CREATE OR REPLACE FUNCTION ganancias_sucursal_anio(p_id_sucursal IN INT)
RETURNS NUMERIC(15,2)
AS $$
DECLARE
    v_ganancias_medicamentos NUMERIC(15,2) := 0;
    v_ganancias_consultas    NUMERIC(15,2) := 0;
    v_total                  NUMERIC(15,2) := 0;
    v_existe                 INT;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM Sucursal
    WHERE id_sucursal = p_id_sucursal;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Sucursal con id % no encontrada.', p_id_sucursal;
    END IF;

    -- Ganancias por medicamentos vendidos en tickets de la sucursal en 2026
    SELECT COALESCE(SUM(m.precio_publico * im.cantidad), 0)
    INTO v_ganancias_medicamentos
    FROM Ticket t
    JOIN IncluirMedicamento im ON t.id_ticket  = im.id_ticket
    JOIN Medicamento m         ON im.id_producto = m.id_producto
    WHERE t.id_sucursal = p_id_sucursal
      AND EXTRACT(YEAR FROM t.fecha) = 2026;

    -- Ganancias por consultas realizadas en la sucursal en 2026
    SELECT COALESCE(SUM(c.precio), 0)
    INTO v_ganancias_consultas
    FROM Ticket t
    JOIN Consulta c ON t.id_ticket = c.id_ticket
    WHERE t.id_sucursal = p_id_sucursal
      AND EXTRACT(YEAR FROM t.fecha) = 2026;

    v_total := v_ganancias_medicamentos + v_ganancias_consultas;

    RETURN v_total;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de uso:
-- SELECT ganancias_sucursal_anio(1);
-- SELECT id_sucursal, nombre, ganancias_sucursal_anio(id_sucursal) AS ganancias_2026 FROM Sucursal ORDER BY ganancias_2026 DESC LIMIT 10;

-- ============================================================
-- FUNCIÓN ii: total_medicamentos_cliente
-- Recibe el id_cliente y devuelve la cantidad total de
-- medicamentos comprados por ese cliente en todos sus tickets.
--
-- Suma las cantidades registradas en IncluirMedicamento
-- asociadas a tickets del cliente.
-- ============================================================

CREATE OR REPLACE FUNCTION total_medicamentos_cliente(p_id_cliente IN INT)
RETURNS INT
AS $$
DECLARE
    v_total  INT := 0;
    v_existe INT;
BEGIN
    -- Verificar que el cliente exista
    SELECT COUNT(*)
    INTO v_existe
    FROM Cliente
    WHERE id_cliente = p_id_cliente;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Cliente con id % no encontrado.', p_id_cliente;
    END IF;

    -- Calcular total de medicamentos comprados
    SELECT COALESCE(SUM(im.cantidad), 0)
    INTO v_total
    FROM Ticket t
    JOIN IncluirMedicamento im ON t.id_ticket = im.id_ticket
    WHERE t.id_cliente = p_id_cliente;

    RETURN v_total;
END;
$$
LANGUAGE plpgsql;

-- Ejemplos de uso:

-- Total de medicamentos comprados por un cliente
-- SELECT total_medicamentos_cliente(1);

-- Mostrar clientes con su total de medicamentos comprados
-- SELECT 
--     id_cliente,
--     nombre,
--     apellido_paterno,
--     total_medicamentos_cliente(id_cliente) AS total_medicamentos
-- FROM Cliente
-- ORDER BY total_medicamentos DESC
-- LIMIT 10;

-- Stored Procedures

-- ============================================================
-- SP i: eliminar_producto
-- Elimina un medicamento dado su id_producto, eliminando primero
-- todas sus referencias en tablas relacionadas para evitar
-- violaciones de integridad referencial.
-- Orden de eliminación:
--   1. CondicionAlmacenamientoMedicamento (CASCADE ya lo haría,
--      pero se hace explícito para claridad)
--   2. IncluirMedicamento  (los tickets que lo incluían)
--   3. ProveerMedicamento  (historial de provisiones)
--   4. VenderMedicamento   (relación venta-sucursal)
--   5. Preparar            (registros de preparación)
--   6. Medicamento         (el producto en sí)
-- ============================================================

CREATE OR REPLACE PROCEDURE eliminar_producto(p_id_producto IN INT)
AS $$
DECLARE
    v_nombre VARCHAR(100);
BEGIN
    -- Verificar que el medicamento exista
    SELECT nombre INTO v_nombre
    FROM Medicamento
    WHERE id_producto = p_id_producto;

    IF v_nombre IS NULL THEN
        RAISE EXCEPTION 'No existe un medicamento con id_producto = %.', p_id_producto;
    END IF;

    RAISE NOTICE 'Eliminando medicamento "%" (id=%)...', v_nombre, p_id_producto;

    -- 1. Eliminar condiciones de almacenamiento
    DELETE FROM CondicionAlmacenamientoMedicamento
    WHERE id_producto = p_id_producto;

    -- 2. Eliminar de IncluirMedicamento (compras en tickets)
    DELETE FROM IncluirMedicamento
    WHERE id_producto = p_id_producto;

    -- 3. Eliminar historial de provisiones del proveedor
    DELETE FROM ProveerMedicamento
    WHERE id_producto = p_id_producto;

    -- 4. Eliminar relación de venta con sucursales
    DELETE FROM VenderMedicamento
    WHERE id_producto = p_id_producto;

    -- 5. Eliminar registros de preparación por farmacéuticos
    DELETE FROM Preparar
    WHERE id_producto = p_id_producto;

    -- 6. Finalmente eliminar el medicamento
    DELETE FROM Medicamento
    WHERE id_producto = p_id_producto;

    RAISE NOTICE 'Medicamento "%" eliminado exitosamente junto con todas sus referencias.', v_nombre;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de uso:
-- CALL eliminar_producto(5);



-- ============================================================
-- SP ii: registrar_proveedor
-- Registra un nuevo proveedor en la tabla Proveedor.
-- Valida que:
--   - La razón social no esté vacía ni tenga caracteres extraños.
--   - El número de proveedor no esté ya registrado.
-- Parámetros:
--   p_numero_proveedor : identificador del proveedor
--   p_razon_social     : nombre o razón social de la empresa
--   p_calle            : calle del domicilio
--   p_num_int          : número interior (puede ser NULL)
--   p_num_ext          : número exterior (puede ser NULL)
--   p_colonia          : colonia del domicilio
-- ============================================================
CREATE OR REPLACE PROCEDURE registrar_proveedor(
    p_numero_proveedor IN INT,
    p_razon_social     IN VARCHAR,
    p_calle            IN VARCHAR,
    p_num_int          IN VARCHAR,
    p_num_ext          IN VARCHAR,
    p_colonia          IN VARCHAR
)
AS $$
DECLARE
    -- Permite letras, números, espacios y puntuación común de nombres de empresa
    v_regex_razon CONSTANT TEXT := '^[A-Za-záéíóúÁÉÍÓÚñÑüÜ0-9 .,&]+$';
BEGIN
    -- Validar que la razón social no esté vacía
    IF p_razon_social IS NULL OR TRIM(p_razon_social) = '' THEN
        RAISE EXCEPTION 'La razón social no puede estar vacía.';
    END IF;

    -- Validar formato de razón social
    IF p_razon_social !~ v_regex_razon THEN
        RAISE EXCEPTION 'La razón social "%" contiene caracteres no permitidos.', p_razon_social;
    END IF;

    -- Verificar que el número de proveedor no esté ya registrado
    IF EXISTS (SELECT 1 FROM Proveedor WHERE numero_proveedor = p_numero_proveedor) THEN
        RAISE EXCEPTION 'Ya existe un proveedor con número %.', p_numero_proveedor;
    END IF;

    -- Insertar el nuevo proveedor
    INSERT INTO Proveedor (numero_proveedor, razon_social, calle, num_int, num_ext, colonia)
    VALUES (p_numero_proveedor, TRIM(p_razon_social), p_calle, p_num_int, p_num_ext, p_colonia);

    RAISE NOTICE 'Proveedor "%" registrado exitosamente con número %.', 
                 TRIM(p_razon_social), p_numero_proveedor;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de uso:
-- CALL registrar_proveedor(
--     2000,
--     'Laboratorios García S.A.',
--     'Av. Insurgentes',
--     NULL,
--     '500',
--     'Nápoles'
-- );


    
-- Disparadores

-- ============================================================
-- TRIGGER i: actualizar_stock
--
-- El "stock" de un medicamento en este esquema se deriva de:
--   + lo que provee un proveedor   (ProveerMedicamento)
--   + lo que prepara un farmacéutico (Preparar)
--   - lo que compra un cliente      (IncluirMedicamento en Ticket)
--
-- Para registrar el stock neto por sucursal y producto se crea
-- una tabla auxiliar StockMedicamento donde el trigger mantiene
-- el conteo actualizado automáticamente.
-- ============================================================

-- Tabla auxiliar de stock (si no existe)
CREATE TABLE IF NOT EXISTS StockMedicamento (
    id_producto  INT,
    id_sucursal  INT,
    stock        INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_producto, id_sucursal),
    FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT stock_no_negativo CHECK (stock >= 0)
);

-- -------------------------------------------------------
-- Función del trigger para ProveerMedicamento
-- Al insertar una provisión, SUMA la cantidad al stock.
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_stock_proveedor()
RETURNS TRIGGER AS $$
BEGIN
    -- Intentar actualizar; si no existe la fila, insertarla
    INSERT INTO StockMedicamento(id_producto, id_sucursal, stock)
    VALUES (NEW.id_producto, NEW.id_sucursal, NEW.cantidad)
    ON CONFLICT (id_producto, id_sucursal)
    DO UPDATE SET stock = StockMedicamento.stock + NEW.cantidad;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_stock_proveedor
AFTER INSERT
ON ProveerMedicamento
FOR EACH ROW
EXECUTE PROCEDURE trg_stock_proveedor();


-- -------------------------------------------------------
-- Función del trigger para Preparar
-- Al insertar una preparación de farmacéutico, SUMA la
-- cantidad al stock de la sucursal del farmacéutico.
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_stock_farmaceutico()
RETURNS TRIGGER AS $$
DECLARE
    v_id_sucursal INT;
BEGIN
    -- Obtener la sucursal del farmacéutico que prepara
    SELECT p.id_sucursal INTO v_id_sucursal
    FROM Personal p
    WHERE p.cedula_profesional = NEW.cedula_profesional;

    IF v_id_sucursal IS NULL THEN
        RAISE EXCEPTION 'No se encontró la sucursal del farmacéutico con cédula %.', NEW.cedula_profesional;
    END IF;

    INSERT INTO StockMedicamento(id_producto, id_sucursal, stock)
    VALUES (NEW.id_producto, v_id_sucursal, NEW.cantidad)
    ON CONFLICT (id_producto, id_sucursal)
    DO UPDATE SET stock = StockMedicamento.stock + NEW.cantidad;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_stock_farmaceutico
AFTER INSERT
ON Preparar
FOR EACH ROW
EXECUTE PROCEDURE trg_stock_farmaceutico();


-- -------------------------------------------------------
-- Función del trigger para IncluirMedicamento
-- Al insertar una compra en un ticket, RESTA la cantidad
-- del stock de la sucursal donde se generó el ticket.
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_stock_compra()
RETURNS TRIGGER AS $$
DECLARE
    v_id_sucursal INT;
    v_stock_actual INT;
BEGIN
    -- Obtener la sucursal del ticket
    SELECT id_sucursal INTO v_id_sucursal
    FROM Ticket
    WHERE id_ticket = NEW.id_ticket;

    -- Verificar que haya stock suficiente
    SELECT stock INTO v_stock_actual
    FROM StockMedicamento
    WHERE id_producto = NEW.id_producto
      AND id_sucursal = v_id_sucursal;

    IF v_stock_actual IS NULL OR v_stock_actual < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el medicamento % en la sucursal %. Stock disponible: %.',
            NEW.id_producto, v_id_sucursal, COALESCE(v_stock_actual, 0);
    END IF;

    UPDATE StockMedicamento
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto
      AND id_sucursal = v_id_sucursal;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_stock_compra
AFTER INSERT
ON IncluirMedicamento
FOR EACH ROW
EXECUTE PROCEDURE trg_stock_compra();


-- ============================================================
-- TRIGGER ii: auditar_cambios_precio
-- Se dispara AFTER UPDATE sobre precio_publico o precio_unitario
-- en la tabla Medicamento.
-- Por cada campo que cambie, inserta un registro en
-- AuditoriaPrecioMedicamento con: el producto, qué campo
-- cambió, el valor anterior, el nuevo, el usuario de BD
-- y la fecha/hora del cambio.
-- Sirve para rastrear el historial de precios a lo largo
-- del tiempo.
-- ============================================================

-- Tabla de auditoría
CREATE TABLE IF NOT EXISTS AuditoriaPrecioMedicamento (
    id_auditoria     INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_producto      INT           NOT NULL,
    nombre_producto  VARCHAR(100),
    campo_modificado VARCHAR(20)   NOT NULL,  -- 'precio_publico' o 'precio_unitario'
    precio_anterior  NUMERIC(10,2),
    precio_nuevo     NUMERIC(10,2),
    usuario          VARCHAR(100),
    fecha_cambio     TIMESTAMP     NOT NULL DEFAULT NOW()
);

-- Función del trigger
CREATE OR REPLACE FUNCTION trg_auditar_precio_fn()
RETURNS TRIGGER AS $$
BEGIN
    -- Registrar cambio en precio_publico
    IF OLD.precio_publico IS DISTINCT FROM NEW.precio_publico THEN
        INSERT INTO AuditoriaPrecioMedicamento
            (id_producto, nombre_producto, campo_modificado,
             precio_anterior, precio_nuevo, usuario)
        VALUES
            (OLD.id_producto, OLD.nombre, 'precio_publico',
             OLD.precio_publico, NEW.precio_publico, CURRENT_USER);
    END IF;

    -- Registrar cambio en precio_unitario
    IF OLD.precio_unitario IS DISTINCT FROM NEW.precio_unitario THEN
        INSERT INTO AuditoriaPrecioMedicamento
            (id_producto, nombre_producto, campo_modificado,
             precio_anterior, precio_nuevo, usuario)
        VALUES
            (OLD.id_producto, OLD.nombre, 'precio_unitario',
             OLD.precio_unitario, NEW.precio_unitario, CURRENT_USER);
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger sobre Medicamento, solo se activa si cambian los precios
CREATE OR REPLACE TRIGGER trg_auditar_precio
    AFTER UPDATE OF precio_publico, precio_unitario
    ON Medicamento
    FOR EACH ROW
    EXECUTE PROCEDURE trg_auditar_precio_fn();

-- Ejemplo de uso:
-- Cambiar precio de un medicamento:
-- UPDATE Medicamento SET precio_publico = 199.99 WHERE id_producto = 1;
-- Ver auditoría:
-- SELECT * FROM AuditoriaPrecioMedicamento ORDER BY fecha_cambio DESC;