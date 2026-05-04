-- Games table (sourced from RAWG API)
CREATE TABLE IF NOT EXISTS GAMES (
    id            INTEGER PRIMARY KEY,
    name          TEXT    NOT NULL,
    released      TEXT,                  -- YYYY-MM-DD format
    rating        REAL,                  -- Average rating (0–5)
    ratings_count INTEGER
);

-- Developers
CREATE TABLE IF NOT EXISTS DEVELOPERS (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL                   -- Company name
);

-- Platforms
CREATE TABLE IF NOT EXISTS PLATFORMS (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL                   -- e.g. PC, PlayStation 5
);

-- Genres
CREATE TABLE IF NOT EXISTS GENRES (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL                   -- e.g. Action, RPG
);

-- Junction: Game ↔ Developer (many-to-many)
CREATE TABLE IF NOT EXISTS GAME_DEVELOPERS (
    game_id      INTEGER NOT NULL REFERENCES GAMES(id),
    developer_id INTEGER NOT NULL REFERENCES DEVELOPERS(id),
    PRIMARY KEY (game_id, developer_id)
);

-- Junction: Game ↔ Platform (many-to-many)
CREATE TABLE IF NOT EXISTS GAME_PLATFORMS (
    game_id     INTEGER NOT NULL REFERENCES GAMES(id),
    platform_id INTEGER NOT NULL REFERENCES PLATFORMS(id),
    PRIMARY KEY (game_id, platform_id)
);

-- Junction: Game ↔ Genre (many-to-many)
CREATE TABLE IF NOT EXISTS GAME_GENRES (
    game_id  INTEGER NOT NULL REFERENCES GAMES(id),
    genre_id INTEGER NOT NULL REFERENCES GENRES(id),
    PRIMARY KEY (game_id, genre_id)
);

-- Users
CREATE TABLE IF NOT EXISTS USERS (
    id         INTEGER  PRIMARY KEY AUTOINCREMENT,
    first_name TEXT     NOT NULL,
    last_name  TEXT     NOT NULL,
    username   TEXT     NOT NULL UNIQUE,
    password   TEXT     NOT NULL,        -- Stored as hashed value
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    pfp        TEXT,                     -- Profile picture URL
    is_admin   BOOLEAN  DEFAULT 0
);

-- Favourites (User ↔ Game, many-to-many)
CREATE TABLE IF NOT EXISTS FAVOURITES (
    user_id INTEGER NOT NULL REFERENCES USERS(id),
    game_id INTEGER NOT NULL REFERENCES GAMES(id),
    PRIMARY KEY (user_id, game_id)
);

-- Categories
CREATE TABLE IF NOT EXISTS CATEGORIES (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url   TEXT NOT NULL,
    icon  TEXT
);

-- Junction: Game ↔ Category (many-to-many)
CREATE TABLE IF NOT EXISTS GAME_CATEGORIES (
    game_id     INTEGER NOT NULL REFERENCES GAMES(id),
    category_id INTEGER NOT NULL REFERENCES CATEGORIES(id),
    PRIMARY KEY (game_id, category_id)
);

/*
  Add some sample data to the tables you create.
*/

-- Sample users
INSERT INTO USERS (first_name, last_name, username, password, pfp, is_admin) VALUES
('Joe', 'Smith', 'joesmith', 'hashed_password_1', NULL, 0),
('Stephanie', 'Lane', 'steph_lane', 'hashed_password_2', NULL, 0),
('Admin', 'User', 'admin', 'hashed_password_3', NULL, 1);

-- Sample categories
INSERT INTO CATEGORIES (title, url, icon) VALUES
('Action', 'action', 'action-icon'),
('RPG', 'rpg', 'rpg-icon'),
('Multiplayer', 'multiplayer', 'multiplayer-icon'),
('Indie', 'indie', 'indie-icon');

-- Sample favourites
INSERT INTO FAVOURITES (user_id, game_id) VALUES
(1, 12),
(1, 21),
(2, 24),
(2, 29),
(3, 39);

-- Sample game categories
INSERT INTO GAME_CATEGORIES (game_id, category_id) VALUES
(12, 1),
(21, 3),
(24, 3),
(29, 1),
(39, 2);