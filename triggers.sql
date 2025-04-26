-- =============================
--  EJERCICIO 5 (triggers)
-- =============================

-- ----------------------------------------------------------------------------
--  TRIGGER 1: BEFORE INSERT EN TABLA ARTICULO
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_stock_articulo()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el stock no sea negativo
    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'El stock del artículo no puede ser negativo';
    END IF;
    
    -- Validar que el precio no sea negativo o cero
    IF NEW.precio <= 0 THEN
        RAISE EXCEPTION 'El precio del artículo debe ser mayor que cero';
    END IF;
    
    -- Si todo está correcto, permitir la inserción
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_articulo
BEFORE INSERT ON Articulo
FOR EACH ROW
EXECUTE FUNCTION validar_stock_articulo();

/* 
DOCUMENTACIÓN TRIGGER 1:
Propósito: Validar la integridad de los datos antes de insertar un nuevo artículo.
Tipo de operación: BEFORE INSERT
Justificación: Se utiliza BEFORE INSERT porque:
1. Permite validar los datos antes de que se intenten guardar en la base de datos
2. Evita operaciones innecesarias de inserción si los datos no son válidos
3. Mantiene la integridad de los datos en la tabla Articulo desde el inicio

Alternativa: Se podría haber utilizado un CHECK CONSTRAINT en la definición de la tabla,
por ejemplo: CHECK (stock >= 0) y CHECK (precio > 0). Sin embargo, el trigger ofrece más
flexibilidad para implementar validaciones más complejas y mostrar mensajes de error
personalizados para el usuario.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 2: AFTER INSERT EN TABLA USUARIO
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_nuevo_usuario()
RETURNS TRIGGER AS $$
BEGIN
    -- Insertar registro en la tabla de auditoría
    INSERT INTO Auditoria(tabla, operacion, usuario, fecha)
    VALUES ('Usuario', 'INSERT', NEW.nombre, CURRENT_TIMESTAMP);
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_usuario
AFTER INSERT ON Usuario
FOR EACH ROW
EXECUTE FUNCTION registrar_nuevo_usuario();

/* 
DOCUMENTACIÓN TRIGGER 2:
Propósito: Registrar información de auditoría cada vez que se crea un nuevo usuario.
Tipo de operación: AFTER INSERT
Justificación: Se utiliza AFTER INSERT porque:
1. La auditoría debe realizarse después de confirmar que la inserción fue exitosa
2. Los datos ya han sido validados y son correctos
3. No interfiere con el proceso de inserción principal

Alternativa: Esta funcionalidad se podría implementar en el código de la aplicación que
interactúa con la base de datos. Sin embargo, usar un trigger asegura que la auditoría
se realice siempre, independientemente de cómo se inserte el usuario (desde la aplicación,
directamente en la base de datos, etc.), garantizando consistencia en el registro de auditoría.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 3: BEFORE UPDATE EN TABLA TRANSACCION
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_actualizacion_transaccion()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la transacción está en estado "finalizada"
    IF OLD.estado = 'finalizada' AND NEW.estado != 'finalizada' THEN
        RAISE EXCEPTION 'No se puede modificar una transacción que ya ha sido finalizada';
    END IF;
    
    -- Actualizar la fecha solo si hay cambio de estado
    IF OLD.estado != NEW.estado THEN
        NEW.fecha = CURRENT_TIMESTAMP;
    END IF;

	-- Si todo está correcto, permitir la actualización
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_transaccion
BEFORE UPDATE ON Transaccion
FOR EACH ROW
EXECUTE FUNCTION validar_actualizacion_transaccion();

/* 
DOCUMENTACIÓN TRIGGER 3:
Propósito: Validar y modificar los datos antes de actualizar una transacción existente.
Tipo de operación: BEFORE UPDATE
Justificación: Se utiliza BEFORE UPDATE porque:
1. Permite modificar los datos que se van a guardar (como actualizar la fecha)
2. Permite validar cambios de estado y prevenir modificaciones no permitidas
3. Controla la integridad del flujo de estados de la transacción

Alternativa: Se podría implementar esta lógica en el código de la aplicación o mediante
procedimientos almacenados que se llamen antes de actualizar la transacción. Sin embargo,
el trigger garantiza que estas validaciones siempre se ejecuten, independientemente
de cómo se realice la actualización, centralizando la lógica de negocio en la base de datos.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 4: AFTER UPDATE EN TABLA ARTICULO
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION notificar_cambio_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Si el stock cambia y baja de un umbral crítico
    IF NEW.stock != OLD.stock AND NEW.stock < 5 THEN
        -- Insertar en tabla de notificaciones para alertar sobre bajo stock
        INSERT INTO Notificaciones(tipo, mensaje, fecha)
        VALUES ('StockBajo', 'Artículo ' || NEW.nombre || ' con stock crítico: ' || NEW.stock, CURRENT_TIMESTAMP);
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_articulo
AFTER UPDATE ON Articulo
FOR EACH ROW
EXECUTE FUNCTION notificar_cambio_stock();

/* 
DOCUMENTACIÓN TRIGGER 4:
Propósito: Monitorear cambios en el stock de los artículos y generar notificaciones cuando
el nivel de stock es crítico.
Tipo de operación: AFTER UPDATE
Justificación: Se utiliza AFTER UPDATE porque:
1. La notificación debe ocurrir solo cuando la actualización ha sido exitosa
2. No necesitamos modificar los datos que se están actualizando
3. La operación de notificación es secundaria y no debe interferir con la actualización principal

Alternativa: Esta funcionalidad podría implementarse como un proceso de monitoreo periódico
que revise los niveles de stock independientemente de las actualizaciones. Sin embargo,
el trigger permite una respuesta inmediata cuando el stock cambia, mejorando la capacidad
de reacción ante situaciones críticas de inventario.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 5: BEFORE DELETE EN TABLA DETALLETRANSACCION
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_eliminacion_detalle()
RETURNS TRIGGER AS $$
DECLARE
    estado_transaccion VARCHAR(50);
BEGIN
    -- Obtener el estado actual de la transacción asociada
    SELECT estado INTO estado_transaccion
    FROM Transaccion
    WHERE id_transaccion = OLD.id_transaccion;
    
    -- Verificar si la transacción está en un estado que permite eliminar detalles
    IF estado_transaccion IN ('finalizada', 'procesada') THEN
        RAISE EXCEPTION 'No se puede eliminar el detalle de una transacción % o %', 
                        'finalizada', 'procesada';
    END IF;
    
    RETURN OLD; -- Permitir la eliminación si pasa las validaciones
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_delete_detalletransaccion
BEFORE DELETE ON DetalleTransaccion
FOR EACH ROW
EXECUTE FUNCTION validar_eliminacion_detalle();

/* 
DOCUMENTACIÓN TRIGGER 5:
Propósito: Validar que no se eliminen detalles de transacciones que ya están finalizadas o procesadas.
Tipo de operación: BEFORE DELETE
Justificación: Se utiliza BEFORE DELETE porque:
1. Permite cancelar la operación de eliminación si no cumple con las reglas de negocio
2. Previene la pérdida de datos históricos importantes para la integridad del sistema
3. Valida las condiciones antes de realizar cualquier cambio en la base de datos

Alternativa: Se podría usar una regla de foreign key con ON DELETE RESTRICT junto con
vistas materializadas o tablas adicionales que filtren según el estado. Sin embargo,
el trigger proporciona una solución más directa y permite mensajes de error personalizados
para explicar por qué no se permite la eliminación.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 6: AFTER DELETE EN TABLA ARTICULO
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_eliminacion_articulo()
RETURNS TRIGGER AS $$
BEGIN
    -- Registrar la eliminación en una tabla de historial
    INSERT INTO HistorialArticulos(
        id_articulo_original, 
        nombre, 
        precio, 
        fecha_eliminacion,
        accion
    )
    VALUES (
        OLD.id_articulo,
        OLD.nombre,
        OLD.precio,
        CURRENT_TIMESTAMP,
        'DELETE'
    );
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_delete_articulo
AFTER DELETE ON Articulo
FOR EACH ROW
EXECUTE FUNCTION registrar_eliminacion_articulo();

/* 
DOCUMENTACIÓN TRIGGER 6:
Propósito: Mantener un registro histórico de los artículos eliminados para fines de auditoría
y análisis.
Tipo de operación: AFTER DELETE
Justificación: Se utiliza AFTER DELETE porque:
1. La operación de registro debe ocurrir solo cuando la eliminación ha sido exitosa
2. Necesitamos capturar los datos que ya han sido eliminados de la tabla principal
3. El historial es una operación secundaria que no debe interferir con la operación principal

Alternativa: Una alternativa sería implementar borrado lógico (soft delete) añadiendo un
campo "activo" o "eliminado" a la tabla Articulo en lugar de eliminar físicamente los registros.
Sin embargo, el enfoque de trigger con tabla de historial permite mantener limpia la tabla
principal mientras se conserva un registro histórico completo.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 7: BEFORE TRUNCATE EN TABLA CATEGORIA
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_truncate_categoria()
RETURNS TRIGGER AS $$
DECLARE
    articulos_count INT;
BEGIN
    -- Verificar si hay artículos asociados a categorías
    SELECT COUNT(*) INTO articulos_count
    FROM Articulo
    WHERE id_categoria IS NOT NULL;
    
    IF articulos_count > 0 THEN
        RAISE EXCEPTION 'No se puede truncar la tabla Categoria mientras existan artículos asociados a categorías';
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_truncate_categoria
BEFORE TRUNCATE ON Categoria
FOR EACH STATEMENT
EXECUTE FUNCTION validar_truncate_categoria();

/* 
DOCUMENTACIÓN TRIGGER 7:
Propósito: Prevenir el truncado de la tabla Categoria cuando existen artículos
que hacen referencia a estas categorías.
Tipo de operación: BEFORE TRUNCATE
Justificación: Se utiliza BEFORE TRUNCATE porque:
1. Permite validar condiciones antes de ejecutar una operación destructiva
2. Protege la integridad referencial que podría perderse con un TRUNCATE
3. TRUNCATE es una operación a nivel de tabla que no respeta las restricciones de FK automáticamente

Alternativa: Se podría eliminar la restricción de clave foránea temporalmente, truncar la tabla
y luego restaurar la restricción. Sin embargo, esto sería más complejo y propenso a errores.
El trigger proporciona una capa adicional de seguridad para prevenir pérdida accidental de datos.
*/

-- ----------------------------------------------------------------------------
--  TRIGGER 8: AFTER TRUNCATE EN TABLA TEMATICA
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_truncate_tematica()
RETURNS TRIGGER AS $$
BEGIN
    -- Registrar el evento de truncado en la tabla de auditoría
    INSERT INTO Auditoria(tabla, operacion, usuario, fecha)
    VALUES ('Tematica', 'TRUNCATE', current_user, CURRENT_TIMESTAMP);
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_truncate_tematica
AFTER TRUNCATE ON Tematica
FOR EACH STATEMENT
EXECUTE FUNCTION registrar_truncate_tematica();

/* 
DOCUMENTACIÓN TRIGGER 8:
Propósito: Registrar en la auditoría cuando se realiza un TRUNCATE en la tabla Tematica.
Tipo de operación: AFTER TRUNCATE
Justificación: Se utiliza AFTER TRUNCATE porque:
1. La operación de registro debe ocurrir solo cuando el truncado ha sido exitoso
2. No necesitamos modificar o prevenir la operación de truncado
3. Es importante mantener un registro de operaciones masivas que afectan los datos

Alternativa: Se podría implementar un procedimiento almacenado específico que registre
la auditoría y luego ejecute el TRUNCATE, obligando a los usuarios a usar este procedimiento
en lugar del comando TRUNCATE directo. Sin embargo, el trigger garantiza que siempre
se registre la operación independientemente de cómo se ejecute.
*/
