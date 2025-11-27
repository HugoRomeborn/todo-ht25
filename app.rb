require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'



post '/create' do
    name = params["name"]
    description = params["description"]
    db = SQLite3::Database.new("db/todos.db")

    db.execute("INSERT INTO todos (name, description) VALUES (?,?)", [name, description])
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
    @todos = db.execute("SELECT * FROM todos")

    p @datafrukt
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



