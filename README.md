# **Ejercicio 5: Triggers**

Universidad del Valle de Guatemala  
Facultad de Ingeniería  
Departamento de Ciencias de la Computación  
CC3088 - Base de Datos 1  

## **Instrucciones**

Una tienda en línea desea implementar un sistema para gestionar las ventas, los productos disponibles y el historial de compras de los clientes. La plataforma
debe registrar los pedidos realizados por los usuarios, el estado de cada pedido y la gestión del inventario. Además, el sistema debe mantener un registro histórico
de cambios en los datos de los productos y los usuarios.  

## **Requerimientos**

Para completar el ejercicio, se requiere:  

- El diseño de una base de datos con las tablas necesarias para productos, usuarios, pedidos y detalles de pedido.
- La implementación de **8 triggers** (uno para cada combinación de evento y tipo: `BEFORE/AFTER` × `INSERT/UPDATE/DELETE/TRUNCATE`).
- La inclusión de datos suficientes de prueba (mínimo 15 productos, 10 clientes, 30 pedidos).
- La entrega de los siguientes archivos:
  - `ddl.sql`: creación de tablas y relaciones.
  - `data.sql`: inserción de datos de prueba.
  - `triggers.sql`: implementación y documentación de triggers.
  - `ejercicio5.pdf`: respuestas a preguntas clave de diseño, rendimiento y escalabilidad.

## **Tecnologías y Configuración**

- **PostgreSQL** 13 o superior
- Cliente SQL o herramienta como **pgAdmin**
- Scripts `.sql` ejecutables desde consola o interfaz gráfica

 ## **Instrucciones de Uso**

1. Ejecutar `ddl.sql` para crear las tablas y relaciones.
2. Ejecutar `data.sql` para insertar los datos de prueba.
3. Ejecutar `triggers.sql` para crear los triggers.
4. Probar operaciones CRUD y observar los efectos generados automáticamente por los triggers.

## **Colaboradores**

> ✦ **Cristian Túnchez (231359)**

> ✦ **Javier Benitez (23405)**
