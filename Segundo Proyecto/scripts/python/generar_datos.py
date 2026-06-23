import csv
import random
from datetime import date, timedelta
from pathlib import Path

from faker import Faker


SEMILLA = 2026
random.seed(SEMILLA)
Faker.seed(SEMILLA)

fake = Faker("es_MX")

BASE_DIR = Path(__file__).resolve().parents[2]
NODOS_DIR = BASE_DIR / "datos" / "nodos"
RELACIONES_DIR = BASE_DIR / "datos" / "relaciones"

NODOS_DIR.mkdir(parents=True, exist_ok=True)
RELACIONES_DIR.mkdir(parents=True, exist_ok=True)

HOY = date.today()
FECHA_INICIO = HOY - timedelta(days=730)


def fecha_aleatoria(inicio, fin):
    diferencia = (fin - inicio).days
    return inicio + timedelta(days=random.randint(0, diferencia))


def escribir_csv(ruta, encabezados, filas):
    with open(ruta, "w", newline="", encoding="utf-8") as archivo:
        escritor = csv.DictWriter(archivo, fieldnames=encabezados)
        escritor.writeheader()
        escritor.writerows(filas)


paises = [
    "Guatemala",
    "México",
    "El Salvador",
    "Honduras",
    "Costa Rica",
    "Colombia",
    "Argentina",
    "España",
    "Perú",
    "Chile",
]

nacionalidades = [
    "Guatemalteca",
    "Mexicana",
    "Salvadoreña",
    "Hondureña",
    "Costarricense",
    "Colombiana",
    "Argentina",
    "Española",
    "Peruana",
    "Chilena",
]

tipos_cocina_nombres = [
    "Guatemalteca",
    "Mexicana",
    "Italiana",
    "Japonesa",
    "China",
    "Francesa",
    "Mediterránea",
    "India",
    "Tailandesa",
    "Coreana",
    "Peruana",
    "Argentina",
    "Vegetariana",
    "Mariscos",
    "Comida rápida",
]

platillos_nombres = [
    "Pepián",
    "Kak ik",
    "Jocón",
    "Tamales",
    "Tacos al pastor",
    "Enchiladas",
    "Burrito",
    "Quesadillas",
    "Pizza margarita",
    "Lasaña",
    "Espagueti carbonara",
    "Risotto",
    "Sushi",
    "Ramen",
    "Tempura",
    "Sashimi",
    "Arroz frito",
    "Chop suey",
    "Pato a la naranja",
    "Dim sum",
    "Croissant",
    "Ratatouille",
    "Crepas",
    "Coq au vin",
    "Paella",
    "Hummus",
    "Falafel",
    "Gyros",
    "Pollo tikka masala",
    "Curry de verduras",
    "Samosas",
    "Naan",
    "Pad thai",
    "Tom yum",
    "Curry tailandés",
    "Bibimbap",
    "Kimchi",
    "Bulgogi",
    "Ceviche",
    "Lomo saltado",
    "Ají de gallina",
    "Parrillada",
    "Empanadas argentinas",
    "Hamburguesa",
    "Hot dog",
    "Ensalada mediterránea",
    "Pasta vegetariana",
    "Camarones al ajillo",
    "Filete de pescado",
    "Sopa de mariscos",
]

comentarios = [
    "Excelente servicio y comida.",
    "Muy buena experiencia.",
    "El ambiente fue agradable.",
    "La comida estuvo deliciosa.",
    "El servicio puede mejorar.",
    "Buena relación entre precio y calidad.",
    "Regresaría nuevamente.",
    "Los platillos estuvieron bien preparados.",
    "La atención fue rápida.",
    "La experiencia fue aceptable.",
]

estilos = [
    "Tradicional",
    "Moderno",
    "Fusión",
    "Artesanal",
    "Contemporáneo",
    "Internacional",
]

especialidades = [
    "Carnes",
    "Mariscos",
    "Postres",
    "Pastas",
    "Comida vegetariana",
    "Cocina internacional",
    "Cocina tradicional",
]

puestos = [
    "Chef ejecutivo",
    "Sous chef",
    "Chef de cocina",
    "Chef de partida",
    "Chef pastelero",
]

rangos_precio = ["$", "$$", "$$$", "$$$$"]


# =====================================================
# NODOS
# =====================================================

usuarios = []

for usuario_id in range(1, 501):
    usuarios.append(
        {
            "id": usuario_id,
            "nombre": fake.name(),
            "email": f"usuario{usuario_id}@correo.com",
            "edad": random.randint(18, 75),
            "pais": random.choice(paises),
        }
    )

restaurantes = []

for restaurante_id in range(1, 201):
    restaurantes.append(
        {
            "id": restaurante_id,
            "nombre": f"Restaurante {fake.last_name()} {restaurante_id}",
            "anio_apertura": random.randint(1980, HOY.year),
            "rango_precios": random.choice(rangos_precio),
            "descripcion": fake.sentence(nb_words=12),
        }
    )

tipos_cocina = []

for tipo_id, nombre in enumerate(tipos_cocina_nombres, start=1):
    tipos_cocina.append(
        {
            "id": tipo_id,
            "nombre": nombre,
            "descripcion": f"Restaurantes especializados en cocina {nombre.lower()}.",
        }
    )

chefs = []

for chef_id in range(1, 101):
    chefs.append(
        {
            "id": chef_id,
            "nombre": fake.name(),
            "fecha_nacimiento": fake.date_of_birth(
                minimum_age=25,
                maximum_age=70,
            ).isoformat(),
            "nacionalidad": random.choice(nacionalidades),
        }
    )

platillos = []
precios_base = {}

for platillo_id, nombre in enumerate(platillos_nombres, start=1):
    precio = round(random.uniform(25, 250), 2)
    precios_base[platillo_id] = precio

    platillos.append(
        {
            "id": platillo_id,
            "nombre": nombre,
            "precio": precio,
            "descripcion": f"Preparación especial de {nombre.lower()}.",
        }
    )


# =====================================================
# RELACIÓN PERTENECE_A
# =====================================================

pertenece_a = []

for restaurante_id in range(1, 201):
    tipos_asignados = random.sample(
        range(1, 16),
        random.randint(1, 3),
    )

    for tipo_id in tipos_asignados:
        pertenece_a.append(
            {
                "restaurante_id": restaurante_id,
                "tipo_cocina_id": tipo_id,
            }
        )


# =====================================================
# RELACIÓN OFRECE
# =====================================================

ofrece = []
ofertas_creadas = set()

for restaurante_id in range(1, 201):
    platillos_asignados = random.sample(
        range(1, 51),
        random.randint(4, 10),
    )

    for platillo_id in platillos_asignados:
        clave = (restaurante_id, platillo_id)

        if clave in ofertas_creadas:
            continue

        ofertas_creadas.add(clave)

        precio = round(
            precios_base[platillo_id] * random.uniform(0.75, 1.50),
            2,
        )

        ofrece.append(
            {
                "restaurante_id": restaurante_id,
                "platillo_id": platillo_id,
                "precio": precio,
                "disponible": str(random.random() < 0.90).lower(),
            }
        )


# =====================================================
# RELACIÓN PREPARA
# =====================================================

prepara = []
preparaciones_creadas = set()

for chef_id in range(1, 101):
    platillos_asignados = random.sample(
        range(1, 51),
        random.randint(2, 5),
    )

    for platillo_id in platillos_asignados:
        clave = (chef_id, platillo_id)

        if clave in preparaciones_creadas:
            continue

        preparaciones_creadas.add(clave)

        prepara.append(
            {
                "chef_id": chef_id,
                "platillo_id": platillo_id,
                "estilo": random.choice(estilos),
                "especialidad": random.choice(especialidades),
            }
        )


# =====================================================
# RELACIÓN TRABAJA_EN
# =====================================================

trabaja_en = []
trabajos_creados = set()

# Caso controlado para probar recomendaciones.
for restaurante_id in [1, 2, 3]:
    trabajos_creados.add((1, restaurante_id))

    trabaja_en.append(
        {
            "chef_id": 1,
            "restaurante_id": restaurante_id,
            "fecha_inicio": fecha_aleatoria(
                date(2018, 1, 1),
                HOY,
            ).isoformat(),
            "puesto": "Chef ejecutivo",
        }
    )

for chef_id in range(2, 101):
    restaurantes_asignados = random.sample(
        range(1, 201),
        random.randint(1, 4),
    )

    for restaurante_id in restaurantes_asignados:
        clave = (chef_id, restaurante_id)

        if clave in trabajos_creados:
            continue

        trabajos_creados.add(clave)

        trabaja_en.append(
            {
                "chef_id": chef_id,
                "restaurante_id": restaurante_id,
                "fecha_inicio": fecha_aleatoria(
                    date(2015, 1, 1),
                    HOY,
                ).isoformat(),
                "puesto": random.choice(puestos),
            }
        )


# =====================================================
# RELACIÓN LE_GUSTA
# =====================================================

le_gusta = []

for usuario_id in range(1, 501):
    tipos_preferidos = random.sample(
        range(1, 16),
        random.randint(2, 6),
    )

    for tipo_id in tipos_preferidos:
        le_gusta.append(
            {
                "usuario_id": usuario_id,
                "tipo_cocina_id": tipo_id,
                "nivel_interes": random.randint(1, 5),
            }
        )


# =====================================================
# RELACIÓN ES_AMIGO_DE
# =====================================================

amistades = []
amistades_creadas = set()

while len(amistades) < 1500:
    usuario_1, usuario_2 = random.sample(range(1, 501), 2)
    clave = tuple(sorted((usuario_1, usuario_2)))

    if clave in amistades_creadas:
        continue

    amistades_creadas.add(clave)

    amistades.append(
        {
            "usuario_id_1": clave[0],
            "usuario_id_2": clave[1],
            "fecha_amistad": fecha_aleatoria(
                date(2018, 1, 1),
                HOY,
            ).isoformat(),
        }
    )


# =====================================================
# RELACIÓN VISITÓ
# =====================================================

visitas = []
visitas_creadas = set()

# El usuario 1 visita y valora bien el restaurante 1.
# No se generarán visitas del usuario 1 al restaurante 2.
for dias, consumo, reserva in [
    (30, 380.00, True),
    (90, 295.50, False),
    (180, 425.75, True),
]:
    fecha_visita = HOY - timedelta(days=dias)
    clave = (1, 1, fecha_visita.isoformat())
    visitas_creadas.add(clave)

    visitas.append(
        {
            "usuario_id": 1,
            "restaurante_id": 1,
            "fecha_visita": fecha_visita.isoformat(),
            "consumo": consumo,
            "con_reserva": str(reserva).lower(),
        }
    )

while len(visitas) < 3500:
    usuario_id = random.randint(1, 500)

    if random.random() < 0.95:
        restaurante_id = random.randint(1, 190)
        fecha_visita = fecha_aleatoria(FECHA_INICIO, HOY)
    else:
        restaurante_id = random.randint(191, 200)
        fecha_visita = fecha_aleatoria(
            FECHA_INICIO,
            HOY - timedelta(days=200),
        )

    if usuario_id == 1 and restaurante_id == 2:
        continue

    clave = (
        usuario_id,
        restaurante_id,
        fecha_visita.isoformat(),
    )

    if clave in visitas_creadas:
        continue

    visitas_creadas.add(clave)

    visitas.append(
        {
            "usuario_id": usuario_id,
            "restaurante_id": restaurante_id,
            "fecha_visita": fecha_visita.isoformat(),
            "consumo": round(random.uniform(35, 650), 2),
            "con_reserva": str(random.random() < 0.58).lower(),
        }
    )


# =====================================================
# RELACIÓN CALIFICÓ
# =====================================================

calificaciones = [
    {
        "usuario_id": 1,
        "restaurante_id": 1,
        "puntuacion": 5,
        "fecha": (HOY - timedelta(days=25)).isoformat(),
        "comentario": "Excelente restaurante y gran trabajo del chef.",
    }
]

calificaciones_creadas = {(1, 1)}

while len(calificaciones) < 2200:
    usuario_id = random.randint(1, 500)
    restaurante_id = random.randint(1, 200)

    if usuario_id == 1 and restaurante_id == 2:
        continue

    clave = (usuario_id, restaurante_id)

    if clave in calificaciones_creadas:
        continue

    calificaciones_creadas.add(clave)

    calificaciones.append(
        {
            "usuario_id": usuario_id,
            "restaurante_id": restaurante_id,
            "puntuacion": random.randint(1, 5),
            "fecha": fecha_aleatoria(
                FECHA_INICIO,
                HOY,
            ).isoformat(),
            "comentario": random.choice(comentarios),
        }
    )


# =====================================================
# ESCRITURA DE ARCHIVOS
# =====================================================

escribir_csv(
    NODOS_DIR / "usuarios.csv",
    ["id", "nombre", "email", "edad", "pais"],
    usuarios,
)

escribir_csv(
    NODOS_DIR / "restaurantes.csv",
    [
        "id",
        "nombre",
        "anio_apertura",
        "rango_precios",
        "descripcion",
    ],
    restaurantes,
)

escribir_csv(
    NODOS_DIR / "tipos_cocina.csv",
    ["id", "nombre", "descripcion"],
    tipos_cocina,
)

escribir_csv(
    NODOS_DIR / "chefs.csv",
    [
        "id",
        "nombre",
        "fecha_nacimiento",
        "nacionalidad",
    ],
    chefs,
)

escribir_csv(
    NODOS_DIR / "platillos.csv",
    ["id", "nombre", "precio", "descripcion"],
    platillos,
)

escribir_csv(
    RELACIONES_DIR / "califico.csv",
    [
        "usuario_id",
        "restaurante_id",
        "puntuacion",
        "fecha",
        "comentario",
    ],
    calificaciones,
)

escribir_csv(
    RELACIONES_DIR / "visito.csv",
    [
        "usuario_id",
        "restaurante_id",
        "fecha_visita",
        "consumo",
        "con_reserva",
    ],
    visitas,
)

escribir_csv(
    RELACIONES_DIR / "amistades.csv",
    [
        "usuario_id_1",
        "usuario_id_2",
        "fecha_amistad",
    ],
    amistades,
)

escribir_csv(
    RELACIONES_DIR / "pertenece_a.csv",
    ["restaurante_id", "tipo_cocina_id"],
    pertenece_a,
)

escribir_csv(
    RELACIONES_DIR / "ofrece.csv",
    [
        "restaurante_id",
        "platillo_id",
        "precio",
        "disponible",
    ],
    ofrece,
)

escribir_csv(
    RELACIONES_DIR / "prepara.csv",
    [
        "chef_id",
        "platillo_id",
        "estilo",
        "especialidad",
    ],
    prepara,
)

escribir_csv(
    RELACIONES_DIR / "trabaja_en.csv",
    [
        "chef_id",
        "restaurante_id",
        "fecha_inicio",
        "puesto",
    ],
    trabaja_en,
)

escribir_csv(
    RELACIONES_DIR / "le_gusta.csv",
    [
        "usuario_id",
        "tipo_cocina_id",
        "nivel_interes",
    ],
    le_gusta,
)

print("Archivos CSV generados correctamente.")
print()
print("NODOS")
print(f"Usuarios: {len(usuarios)}")
print(f"Restaurantes: {len(restaurantes)}")
print(f"Tipos de cocina: {len(tipos_cocina)}")
print(f"Chefs: {len(chefs)}")
print(f"Platillos: {len(platillos)}")
print()
print("RELACIONES")
print(f"CALIFICÓ: {len(calificaciones)}")
print(f"VISITÓ: {len(visitas)}")
print(f"ES_AMIGO_DE: {len(amistades)}")
print(f"PERTENECE_A: {len(pertenece_a)}")
print(f"OFRECE: {len(ofrece)}")
print(f"PREPARA: {len(prepara)}")
print(f"TRABAJA_EN: {len(trabaja_en)}")
print(f"LE_GUSTA: {len(le_gusta)}")
