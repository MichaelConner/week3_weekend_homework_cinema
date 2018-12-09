require_relative('../db/sql_runner')
require_relative('films')
require_relative('customers')
require_relative('tickets')

require('pg')
require('pry')

class Screening

  attr_accessor :film_id, :showtime, :capacity
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @showtime = options['showtime']
    @capacity = options['capacity']
  end

  def save
    sql = "INSERT INTO screenings (film_id, showtime, capacity) VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @showtime, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1 "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_all
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return screenings.map{ |screening| Screening.new(screening)}
  end

  def self.show_all
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return screenings.map{ |screening| p Screening.new(screening)}
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM screenings WHERE id = $1 "
    values = [id]
    screening = SqlRunner.run(sql, values)[0]
    return Screening.new(screening)
  end

  def update
    sql = "UPDATE screenings SET (film_id, showtime, capacity) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @showtime, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def no_tickets_sold
    sql = "SELECT t.* FROM tickets t
          INNER JOIN screenings s ON t.screening_id = s.id
          WHERE screening_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings.map{ |screening| Screening.new(screening)}.length
  end

end
