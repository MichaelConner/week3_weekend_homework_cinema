require_relative('../db/sql_runner')
require_relative('films')
require_relative('tickets')

require('pg')
require('pry')

class Customer

  attr_accessor :name, :wallet
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @wallet = options['wallet']
  end

  def save
    sql = "INSERT INTO customers (name, wallet) VALUES ($1, $2) RETURNING id"
    values = [@name, @wallet]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1 "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map{ |customer| Customer.new(customer)}
  end

  def self.show_all
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map{ |customer| p Customer.new(customer)}
  end

  def films
    sql = "SELECT f.* FROM tickets t
          INNER JOIN films f ON t.film_id = f.id
          WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{ |film| Film.new(film)}
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1 "
    values = [id]
    customer = SqlRunner.run(sql, values)[0]
    return Customer.new(customer)
  end

  def update
    sql = "UPDATE customers SET (name, wallet) = ($1, $2) WHERE id = $3 "
    values = [@name, @wallet, @id]
    SqlRunner.run(sql, values)
  end


end
