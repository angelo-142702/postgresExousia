-- ESQUEMA POSTGRESQL PARA EXOUSIA
-- Este archivo es solo de referencia. Sequelize crea las tablas automáticamente.
-- Para inicializar: npm run migrate && npm run seed

-- Tabla de categorías principales
CREATE TABLE IF NOT EXISTS categorias_principales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    icono VARCHAR(50),
    color VARCHAR(50),
    descripcion TEXT,
    orden INTEGER DEFAULT 0
);

-- Tabla de subcategorías/necesidades
CREATE TABLE IF NOT EXISTS subcategorias (
    id SERIAL PRIMARY KEY,
    categoria_id INTEGER REFERENCES categorias_principales(id),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de emociones
CREATE TABLE IF NOT EXISTS emociones (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla de áreas de vida
CREATE TABLE IF NOT EXISTS areas_vida (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla principal de palabras
CREATE TABLE IF NOT EXISTS palabras (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    fecha_texto VARCHAR(100) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    titulo_principal VARCHAR(255),
    versiculo_cita VARCHAR(100) NOT NULL,
    versiculo_texto TEXT NOT NULL,
    mensaje TEXT NOT NULL,
    autor VARCHAR(100) DEFAULT 'Nuestro Apóstol',
    ministerio VARCHAR(100) DEFAULT 'Casa Gobierno Exousia',
    
    -- Estadísticas
    visitas INTEGER DEFAULT 0,
    compartidos INTEGER DEFAULT 0,
    guardados INTEGER DEFAULT 0,
    
    -- Control
    publicado BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER
);

-- Tabla de aplicaciones prácticas (viñetas)
CREATE TABLE IF NOT EXISTS aplicaciones_practicas (
    id SERIAL PRIMARY KEY,
    palabra_id INTEGER NOT NULL REFERENCES palabras(id) ON DELETE CASCADE,
    texto TEXT NOT NULL,
    orden INTEGER DEFAULT 0
);

-- Tabla de relación palabras - emociones
CREATE TABLE IF NOT EXISTS palabra_emociones (
    palabra_id INTEGER REFERENCES palabras(id) ON DELETE CASCADE,
    emocion_id INTEGER REFERENCES emociones(id) ON DELETE CASCADE,
    PRIMARY KEY (palabra_id, emocion_id)
);

-- Tabla de relación palabras - áreas de vida
CREATE TABLE IF NOT EXISTS palabra_areas_vida (
    palabra_id INTEGER REFERENCES palabras(id) ON DELETE CASCADE,
    area_vida_id INTEGER REFERENCES areas_vida(id) ON DELETE CASCADE,
    PRIMARY KEY (palabra_id, area_vida_id)
);

-- Tabla de relación palabras - subcategorías
CREATE TABLE IF NOT EXISTS palabra_subcategorias (
    palabra_id INTEGER REFERENCES palabras(id) ON DELETE CASCADE,
    subcategoria_id INTEGER REFERENCES subcategorias(id) ON DELETE CASCADE,
    PRIMARY KEY (palabra_id, subcategoria_id)
);

-- Tabla de usuarios (admin)
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(10) CHECK (rol IN ('admin', 'editor', 'lector')) DEFAULT 'lector',
    activo BOOLEAN DEFAULT TRUE,
    ultimo_acceso TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tokens (refresh tokens)
CREATE TABLE IF NOT EXISTS tokens (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    token VARCHAR(500) NOT NULL,
    tipo VARCHAR(10) CHECK (tipo IN ('access', 'refresh')) NOT NULL,
    expira_en TIMESTAMP NOT NULL,
    revocado BOOLEAN DEFAULT FALSE
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_palabras_fecha ON palabras(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_palabras_publicado ON palabras(publicado);
CREATE INDEX IF NOT EXISTS idx_palabras_destacado ON palabras(destacado);
CREATE INDEX IF NOT EXISTS idx_tokens_usuario ON tokens(usuario_id);
CREATE INDEX IF NOT EXISTS idx_tokens_token ON tokens(token);
