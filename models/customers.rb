require_relative('../db/sql_runner')
require_relative('films')
require_relative('tickets')
require_relative('screenings')

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
          INNER JOIN screenings s ON t.screening_id = s.id
          INNER JOIN films f ON s.film_id = f.id
          WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{ |film| Film.new(film)}
  end

  def ticket_count
    sql = "SELECT f.* FROM tickets t
          INNER JOIN screenings s ON t.screening_id = s.id
          INNER JOIN films f ON s.film_id = f.id
          WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{ |film| Film.new(film)}.length
  end

  def buy_ticket(screening)
    #check that the film is not already at capacity
    if screening.capacity <= screening.no_tickets_sold
       "Sorry, this film has sold out"
    else # minuses the films price from the customers wallet
       sql = "UPDATE customers SET wallet =
             (wallet-(SELECT price FROM screenings s
             INNER JOIN films f on s.film_id = f.id
             WHERE film_id = $1
             LIMIT 1))
             WHERE id = $2"
       values = [screening.film_id, @id]
       SqlRunner.run(sql, values)
       # then adds an entry to show the customer has a ticket for this film
       ticket = Ticket.new( 'customer_id' => @id, 'screening_id' => screening.id)
       ticket.save
    end
    # binding.pry
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
