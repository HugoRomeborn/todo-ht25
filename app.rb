require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

post '/:id/done' do
    id = params["id"].to_i
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true

    todo = db.execute("SELECT done FROM todos WHERE id = ?", id)
    if todo[0]["done"] == 0
        done = 1
    else    
        done = 0
    end
    
    db.execute("UPDATE todos SET done=? WHERE id = ?", [done, id])

    redirect('/')
end

post '/create' do
    name = params["name"]
    description = params["description"]
    category_id = params["category"]
    db = SQLite3::Database.new("db/todos.db")

    db.execute("INSERT INTO todos (name, description, done, category_id) VALUES (?,?,?,?)", [name, description, 0, category_id])
    redirect('/')
end

post '/create_category' do 
    category = params["category_name"]

    db = SQLite3::Database.new("db/todos.db")

    db.execute("INSERT INTO categories (category) VALUES (?)", [category])
    redirect('/')
end

post '/:id/delete' do
    id = params["id"]
    db = SQLite3::Database.new("db/todos.db")

    db.execute("DELETE FROM todos WHERE id LIKE ?", id)
    redirect('/')
end

post '/:id/update' do
    id = params["id"]
    name = params["name"]
    description = params["description"]

    db = SQLite3::Database.new("db/todos.db")

    db.execute("UPDATE todos SET name=?,description=? WHERE id=?",[name,description,id])

    redirect('/')
end

# Routen 
get '/' do
    #Koppling till db
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true

    #hämta från db
    @todos = db.execute("SELECT todos.*, categories.category FROM todos INNER JOIN categories ON todos.category_id = categories.id")
    
    @categories = db.execute("SELECT * FROM categories")

    #visa med slim
    slim(:index)
end

get '/:id/update' do
    id = params[:id].to_i

    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @todo = db.execute("SELECT * FROM todos WHERE id = ?",id).first


    slim(:update)
end



