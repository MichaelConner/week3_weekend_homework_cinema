require_relative('models/customers')
require_relative('models/tickets')
require_relative('models/films')
require_relative('models/screenings')

require('pg')
require('pry')

Ticket.delete_all
Screening.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new( 'name' => 'Kyle', 'wallet' => 100.00)
customer1.save
customer2 = Customer.new( 'name' => 'Laura', 'wallet' => 200.00)
customer2.save
customer3 = Customer.new( 'name' => 'Ray', 'wallet' => 70.00)
customer3.save
customer4 = Customer.new( 'name' => 'Sheryl', 'wallet' => 120.00)
customer4.save
customer5 = Customer.new( 'name' => 'Michael', 'wallet' => 50.00)
customer5.save

film1 = Film.new( 'title' => 'Eraserhead', 'price' => 8.00)
film1.save
film2 = Film.new( 'title' => 'Mullholland Drive', 'price' => 10.00)
film2.save
film3 = Film.new( 'title' => 'Fire Walk With Me', 'price' => 8.00)
film3.save
film4 = Film.new( 'title' => 'Lost Highway', 'price' => 5.00)
film4.save
film5 = Film.new( 'title' => 'Blue Velvet', 'price' => 7.00)
film5.save

screening1 = Screening.new('film_id' => film1.id, 'showtime' => 2000, 'capacity' => 1)
screening1.save
screening2 = Screening.new('film_id' => film1.id, 'showtime' => 2230, 'capacity' => 2)
screening2.save
screening3 = Screening.new('film_id' => film2.id, 'showtime' => 1800, 'capacity' => 1)
screening3.save
screening4 = Screening.new('film_id' => film2.id, 'showtime' => 2030, 'capacity' => 2)
screening4.save
screening5 = Screening.new('film_id' => film2.id, 'showtime' => 2300, 'capacity' => 3)
screening5.save

ticket1 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film1.id, 'screening_id' => screening1.id)
ticket1.save
ticket2 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film2.id, 'screening_id' => screening3.id)
ticket2.save
ticket3 = Ticket.new( 'customer_id' => customer3.id, 'film_id' => film1.id, 'screening_id' => screening2.id)
ticket3.save
ticket4 = Ticket.new( 'customer_id' => customer4.id, 'film_id' => film2.id, 'screening_id' => screening3.id)
ticket4.save
ticket5 = Ticket.new( 'customer_id' => customer5.id, 'film_id' => film2.id, 'screening_id' => screening3.id)
ticket5.save


# p Ticket.find_all
# p Customer.find_all
# p Film.find_all

# customer1.delete
# film1.delete
# ticket1.delete

# p Customer.find_by_id(63)
# p Ticket.find_by_id(67)
# p Film.find_by_id(73)

# customer1.wallet = 150.00
# customer1.update
# film1.price = 5.00
# film1.update
# ticket1.film_id = film2.id
# ticket1.update

# Ticket.show_all
# Customer.show_all
# Film.show_all

# p customer1.films
# p customer1.ticket_count
# p film1.customers
# p film1.customer_headcount

# customer1.buy_ticket(film5)

# p screening1
# p screening1.no_tickets_sold

p customer1.buy_ticket(screening1, film1)
p customer1.buy_ticket(screening1, film1)
p customer1.buy_ticket(screening1, film1)

p film2.most_popular_time
