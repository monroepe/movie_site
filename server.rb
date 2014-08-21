require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pry'

def all_movies
  movies = []
  CSV.foreach('movies.csv', headers: true,
    header_converters: :symbol) do |row|
    movies << row.to_hash
  end
  movies.sort_by{|key, value| key[:title]}
end

def get_movies_by_id(movies)
 all_movies = {}
  movies.each do |movie|
    all_movies[movie[:id]] = movie
  end
all_movies
end

def paginator(movies, page=0 )
  start = (page.to_i * 20)
  movies.slice(start, 20)
end

movies = all_movies
movie_ids = get_movies_by_id(all_movies)


get '/' do
  length = (movies.length/20)
  movies = paginator(movies, 0)
  erb :movie_list, locals: {movies: movies, length: length}
end

get '/movies/:movie_id' do
  movie = movie_ids[params[:movie_id]]
  title = movie[:title]
  year = movie[:year]
  synopsis = movie[:synopsis]
  rating = movie[:rating]
  genre = movie[:genre]
  studio = movie[:studio]

erb :'movies/movie',
locals: {title: title, year: year, synopsis: synopsis, rating: rating, genre: genre, studio: studio}
end
