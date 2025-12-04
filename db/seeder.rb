require 'sqlite3'

db = SQLite3::Database.new("todos.db")


def seed!(db)
  puts "Using db file: db/todos.db"
  puts "🧹 Dropping old tables..."
  drop_tables(db)
  puts "🧱 Creating tables..."
  create_tables(db)
  puts "🍎 Populating tables..."
  populate_tables(db)
  puts "✅ Done seeding the database!"
end

def drop_tables(db)
  db.execute('DROP TABLE IF EXISTS todos')
  db.execute('DROP TABLE IF EXISTS categories')
end

def create_tables(db)
  db.execute('CREATE TABLE todos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL, 
              description TEXT,
              done INTEGER, 
              category_id INT, 
              FOREIGN KEY (category_id) REFERENCES categories)')
  db.execute('CREATE TABLE categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              category TEXT NOT NULL)')
end

def populate_tables(db)
  db.execute('INSERT INTO todos (name, description, done, category_id) VALUES ("Köp mjölk", "3 liter mellanmjölk, eko", 0, 1)')
  db.execute('INSERT INTO todos (name, description, done, category_id) VALUES ("Köp julgran", "En rödgran", 0, 1)')
  db.execute('INSERT INTO todos (name, description, done, category_id) VALUES ("Pynta gran", "Glöm inte lamporna i granen och tomten", 0, 4)')

  db.execute('INSERT INTO categories (category) VALUES ("Köp")')
  db.execute('INSERT INTO categories (category) VALUES ("Privat")')
  db.execute('INSERT INTO categories (category) VALUES ("Publikt")')
  db.execute('INSERT INTO categories (category) VALUES ("Städa")')
end

seed!(db)