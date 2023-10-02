class Movie < ActiveRecord::Base
  def self.all_ratings
    ratings=[]
    Movie.select(:rating).distinct.each do |m|
      ratings << m.rating
    end
    ratings
  end

  def self.with_ratings(ratings_list,sort_key)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    if ratings_list==nil or ratings_list==[]
      Movie.all
    else
      ratings_list=ratings_list.map(&:upcase)
      Movie.where(rating:ratings_list)
      if sort_key!=nil
        Movie.where(rating:ratings_list)
      else
        Movie.where(rating:ratings_list).order(sort_key)
      end
    end
  end
end
