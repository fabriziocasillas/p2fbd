-- =============================================================
-- Proyecto: Farmacia de otro mundo
-- Equipo: Añañines
-- Fundamentos de Bases de Datos, Facultad de Ciencias, UNAM 2026-II
-- =============================================================

-- Funciones

-- ============================================================
-- FUNCIÓN i: edad_cliente
-- Recibe el id_cliente y regresa su edad en años.
-- Se calcula como la diferencia entre la fecha actual y
-- fecha_nacimiento usando AGE(), extrayendo el campo YEAR.
-- ============================================================

CREATE OR REPLACE FUNCTION edad_cliente(p_id_cliente IN INT)
RETURNS INT
AS $$
DECLARE
    v_fecha_nac DATE;
    v_edad      INT;
BEGIN
    SELECT fecha_nacimiento
    INTO v_fecha_nac
    FROM Cliente
    WHERE id_cliente = p_id_cliente;

    IF v_fecha_nac IS NULL THEN
        RAISE EXCEPTION 'Cliente con id % no encontrado.', p_id_cliente;
    END IF;

    v_edad := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_fecha_nac));

    RETURN v_edad;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de uso:
-- SELECT edad_cliente(1);
-- SELECT nombre, apellido_paterno, edad_cliente(id_cliente) AS edad FROM Cliente ORDER BY nombre LIMIT 10;


-- ============================================================
-- FUNCIÓN ii: ganancias_sucursal_anio
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


-- Stored Procedures

-- ============================================================
-- SP i: registrar_farmaceutico
-- Registra un farmacéutico nuevo insertando primero en la tabla
-- Personal (supertipo) y luego en Farmaceutico (subtipo).
-- Valida que los campos de nombre no contengan números ni
-- símbolos usando expresiones regulares.
-- Parámetros de entrada:
--   p_cedula       : cédula profesional (solo dígitos)
--   p_id_sucursal  : sucursal donde labora
--   p_nombre       : nombre (solo letras y espacios)
--   p_ap_paterno   : apellido paterno (solo letras y espacios)
--   p_ap_materno   : apellido materno (solo letras y espacios, puede ser NULL)
--   p_rfc          : RFC del empleado
--   p_horario      : 'matutino', 'vespertino' o 'nocturno'
--   p_salario      : salario numérico
--   p_calle        : calle del domicilio
--   p_num_ext      : número exterior (puede ser NULL)
--   p_num_int      : número interior (puede ser NULL)
--   p_colonia      : colonia del domicilio
-- ============================================================

CREATE OR REPLACE PROCEDURE registrar_farmaceutico(
    p_cedula      IN VARCHAR,
    p_id_sucursal IN INT,
    p_nombre      IN VARCHAR,
    p_ap_paterno  IN VARCHAR,
    p_ap_materno  IN VARCHAR,
    p_rfc         IN VARCHAR,
    p_horario     IN VARCHAR,
    p_salario     IN NUMERIC,
    p_calle       IN VARCHAR,
    p_num_ext     IN VARCHAR,
    p_num_int     IN VARCHAR,
    p_colonia     IN VARCHAR
)
AS $$
DECLARE
    -- Regex: solo letras (incluyendo acentos y ñ) y espacios
    v_regex_nombre CONSTANT TEXT := '^[A-Za-záéíóúÁÉÍÓÚñÑüÜ ]+$';
BEGIN
    -- Validar que nombre no tenga números ni símbolos
    IF p_nombre !~ v_regex_nombre THEN
        RAISE EXCEPTION 'El nombre "%" contiene caracteres no permitidos (solo letras y espacios).', p_nombre;
    END IF;

    -- Validar apellido paterno
    IF p_ap_paterno !~ v_regex_nombre THEN
        RAISE EXCEPTION 'El apellido paterno "%" contiene caracteres no permitidos.', p_ap_paterno;
    END IF;

    -- Validar apellido materno solo si no es NULL
    IF p_ap_materno IS NOT NULL AND p_ap_materno !~ v_regex_nombre THEN
        RAISE EXCEPTION 'El apellido materno "%" contiene caracteres no permitidos.', p_ap_materno;
    END IF;

    -- Verificar que la cédula no esté ya registrada
    IF EXISTS (SELECT 1 FROM Personal WHERE cedula_profesional = p_cedula) THEN
        RAISE EXCEPTION 'Ya existe un empleado con la cédula profesional "%".', p_cedula;
    END IF;

    -- Verificar que la sucursal exista
    IF NOT EXISTS (SELECT 1 FROM Sucursal WHERE id_sucursal = p_id_sucursal) THEN
        RAISE EXCEPTION 'La sucursal con id % no existe.', p_id_sucursal;
    END IF;

    -- Insertar en la tabla supertipo Personal
    INSERT INTO Personal(
        cedula_profesional, id_sucursal, nombre,
        apellido_paterno, apellido_materno,
        RFC, horario, salario,
        calle, num_ext, num_int, colonia
    )
    VALUES (
        p_cedula, p_id_sucursal, p_nombre,
        p_ap_paterno, p_ap_materno,
        p_rfc, p_horario, p_salario,
        p_calle, p_num_ext, p_num_int, p_colonia
    );

    -- Insertar en el subtipo Farmaceutico
    INSERT INTO Farmaceutico(cedula_profesional)
    VALUES (p_cedula);

    RAISE NOTICE 'Farmacéutico "% %" registrado exitosamente con cédula %.', 
                  p_nombre, p_ap_paterno, p_cedula;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de uso:
-- CALL registrar_farmaceutico(
--     '12345678', 1, 'Carlos', 'García', 'López',
--     'GALC900101ABC', 'matutino', 18000.00,
--     'Av. Universidad', '100', NULL, 'Copilco'
-- );


-- ============================================================
-- SP ii: eliminar_producto
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
-- TRIGGER ii: calcular_precio_ticket
--
-- Cada vez que se genera un ticket, calcula:
--   precio_bruto = suma de (precio_publico * cantidad) de todos
--                  los medicamentos incluidos en ese ticket
--   descuento    = según cuántos tickets haya generado el cliente
--                  en el año 2026 ANTES del ticket actual:
--                    0  tickets previos → 0% descuento
--                    1-2 tickets previos → 5% descuento
--                    3-5 tickets previos → 10% descuento
--                    6+ tickets previos → 15% descuento
--   precio_neto  = precio_bruto * (1 - descuento/100)
--
-- Se crea una tabla auxiliar ResumenTicket para almacenar
-- los montos calculados.
-- ============================================================

-- Tabla auxiliar para precios del ticket
CREATE TABLE IF NOT EXISTS ResumenTicket (
    id_ticket     INT PRIMARY KEY,
    precio_bruto  NUMERIC(12,2) NOT NULL DEFAULT 0,
    porcentaje_descuento INT NOT NULL DEFAULT 0,
    precio_neto   NUMERIC(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- -------------------------------------------------------
-- Función del trigger para Ticket
-- Se dispara AFTER INSERT en Ticket.
-- En ese momento el ticket aún no tiene medicamentos
-- (esos llegan después vía IncluirMedicamento), por lo que
-- calcula el descuento y deja precio_bruto = 0.
-- El trigger de IncluirMedicamento actualiza el bruto/neto.
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_calcular_precio_ticket()
RETURNS TRIGGER AS $$
DECLARE
    v_tickets_previos INT;
    v_descuento       INT;
BEGIN
    -- Contar tickets previos del cliente en el año 2026
    SELECT COUNT(*) INTO v_tickets_previos
    FROM Ticket
    WHERE id_cliente = NEW.id_cliente
      AND EXTRACT(YEAR FROM fecha) = 2026
      AND id_ticket <> NEW.id_ticket;  -- excluir el ticket recién insertado

    -- Determinar porcentaje de descuento
    IF v_tickets_previos = 0 THEN
        v_descuento := 0;
    ELSIF v_tickets_previos BETWEEN 1 AND 2 THEN
        v_descuento := 5;
    ELSIF v_tickets_previos BETWEEN 3 AND 5 THEN
        v_descuento := 10;
    ELSE
        v_descuento := 15;
    END IF;

    -- Insertar en ResumenTicket (precio_bruto y neto se actualizan
    -- cuando se agreguen medicamentos al ticket)
    INSERT INTO ResumenTicket(id_ticket, precio_bruto, porcentaje_descuento, precio_neto)
    VALUES (NEW.id_ticket, 0, v_descuento, 0);

    RAISE NOTICE 'Ticket % creado. Tickets previos del cliente en 2026: %. Descuento asignado: %%%.',
                  NEW.id_ticket, v_tickets_previos, v_descuento;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_precio_ticket
AFTER INSERT
ON Ticket
FOR EACH ROW
EXECUTE PROCEDURE trg_calcular_precio_ticket();


-- -------------------------------------------------------
-- Función complementaria: recalcular precio al agregar
-- medicamentos al ticket (IncluirMedicamento).
-- Actualiza precio_bruto y precio_neto en ResumenTicket.
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_recalcular_precio_ticket()
RETURNS TRIGGER AS $$
DECLARE
    v_nuevo_bruto   NUMERIC(12,2);
    v_descuento     INT;
    v_nuevo_neto    NUMERIC(12,2);
BEGIN
    -- Recalcular el precio bruto total del ticket
    SELECT COALESCE(SUM(m.precio_publico * im.cantidad), 0)
    INTO v_nuevo_bruto
    FROM IncluirMedicamento im
    JOIN Medicamento m ON im.id_producto = m.id_producto
    WHERE im.id_ticket = NEW.id_ticket;

    -- Obtener el descuento ya calculado para este ticket
    SELECT porcentaje_descuento INTO v_descuento
    FROM ResumenTicket
    WHERE id_ticket = NEW.id_ticket;

    v_nuevo_neto := v_nuevo_bruto * (1.0 - v_descuento / 100.0);

    -- Actualizar ResumenTicket
    UPDATE ResumenTicket
    SET precio_bruto = v_nuevo_bruto,
        precio_neto  = v_nuevo_neto
    WHERE id_ticket = NEW.id_ticket;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_recalcular_precio
AFTER INSERT
ON IncluirMedicamento
FOR EACH ROW
EXECUTE PROCEDURE trg_recalcular_precio_ticket();
