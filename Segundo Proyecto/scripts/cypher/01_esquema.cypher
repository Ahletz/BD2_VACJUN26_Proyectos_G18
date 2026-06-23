// =====================================================
// RESTRICCIONES DE UNICIDAD
// =====================================================

CREATE CONSTRAINT usuario_id_unique IF NOT EXISTS
FOR (n:Usuario)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT usuario_email_unique IF NOT EXISTS
FOR (n:Usuario)
REQUIRE n.email IS UNIQUE;

CREATE CONSTRAINT restaurante_id_unique IF NOT EXISTS
FOR (n:Restaurante)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT chef_id_unique IF NOT EXISTS
FOR (n:Chef)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT platillo_id_unique IF NOT EXISTS
FOR (n:Platillo)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT tipo_cocina_id_unique IF NOT EXISTS
FOR (n:TipoCocina)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT tipo_cocina_nombre_unique IF NOT EXISTS
FOR (n:TipoCocina)
REQUIRE n.nombre IS UNIQUE;


// =====================================================
// ÍNDICES DE NODOS
// =====================================================

CREATE RANGE INDEX restaurante_nombre_index IF NOT EXISTS
FOR (n:Restaurante)
ON (n.nombre);

CREATE RANGE INDEX restaurante_apertura_index IF NOT EXISTS
FOR (n:Restaurante)
ON (n.anio_apertura);

CREATE RANGE INDEX chef_nombre_index IF NOT EXISTS
FOR (n:Chef)
ON (n.nombre);

CREATE RANGE INDEX platillo_nombre_index IF NOT EXISTS
FOR (n:Platillo)
ON (n.nombre);

CREATE RANGE INDEX usuario_pais_index IF NOT EXISTS
FOR (n:Usuario)
ON (n.pais);


// =====================================================
// ÍNDICES DE RELACIONES
// =====================================================

CREATE RANGE INDEX visita_fecha_index IF NOT EXISTS
FOR ()-[r:`VISITÓ`]-()
ON (r.fecha_visita);

CREATE RANGE INDEX calificacion_puntuacion_index IF NOT EXISTS
FOR ()-[r:`CALIFICÓ`]-()
ON (r.puntuacion);

CREATE RANGE INDEX trabajo_fecha_index IF NOT EXISTS
FOR ()-[r:TRABAJA_EN]-()
ON (r.fecha_inicio);

CREATE RANGE INDEX oferta_precio_index IF NOT EXISTS
FOR ()-[r:OFRECE]-()
ON (r.precio);
