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
  movies
end

def get_movies_by_id(movies)
 all_movies = {}
  movies.each do |movie|
    all_movies[movie[:id]] = movie
  end
all_movies
end


movies = all_movies.sort_by{|key, value| key[:title]}
movie_ids = get_movies_by_id(movies)



get '/' do
  erb :movie_list, locals: {movies: movies}
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