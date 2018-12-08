require_relative('../db/sql_runner')
require_relative('customers')
require_relative('tickets')

require('pg')
require('pry')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1 "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map{ |film| Film.new(film)}
  end

  def self.show_all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map{ |film| p Film.new(film)}
  end

  def customers
    sql = "SELECT c.* FROM tickets t
          INNER JOIN customers c ON t.customer_id = c.id
          WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{ |customer| Customer.new(customer)}
  end

  def customer_headcount
    sql = "SELECT c.* FROM tickets t
          INNER JOIN customers c ON t.customer_id = c.id
          WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{ |customer| Customer.new(customer)}.length
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1 "
    values = [id]
    film = SqlRunner.run(sql, values)[0]
    return Film.new(film)
  end

  def update
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3 "
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end


end
