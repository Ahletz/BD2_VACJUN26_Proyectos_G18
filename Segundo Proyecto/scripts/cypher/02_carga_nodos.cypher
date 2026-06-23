// =====================================================
// USUARIOS
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///nodos/usuarios.csv' AS row
CALL (row) {
    MERGE (n:Usuario {id: toInteger(row.id)})
    SET n.nombre = row.nombre,
        n.email = row.email,
        n.edad = toInteger(row.edad),
        n.pais = row.pais
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// RESTAURANTES
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///nodos/restaurantes.csv' AS row
CALL (row) {
    MERGE (n:Restaurante {id: toInteger(row.id)})
    SET n.nombre = row.nombre,
        n.anio_apertura = toInteger(row.anio_apertura),
        n.rango_precios = row.rango_precios,
        n.descripcion = row.descripcion
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// TIPOS DE COCINA
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///nodos/tipos_cocina.csv' AS row
CALL (row) {
    MERGE (n:TipoCocina {id: toInteger(row.id)})
    SET n.nombre = row.nombre,
        n.descripcion = row.descripcion
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// CHEFS
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///nodos/chefs.csv' AS row
CALL (row) {
    MERGE (n:Chef {id: toInteger(row.id)})
    SET n.nombre = row.nombre,
        n.fecha_nacimiento = date(row.fecha_nacimiento),
        n.nacionalidad = row.nacionalidad
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// PLATILLOS
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///nodos/platillos.csv' AS row
CALL (row) {
    MERGE (n:Platillo {id: toInteger(row.id)})
    SET n.nombre = row.nombre,
        n.precio = toFloat(row.precio),
        n.descripcion = row.descripcion
} IN TRANSACTIONS OF 500 ROWS;
