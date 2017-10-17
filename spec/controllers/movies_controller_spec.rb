require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    
    it 'should flash error message if no movies match search' do
      fake_results = []
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'starstarstar'}
      expect(flash[:warning]).to eq("No matching movies were found on TMDb")
    end
    
    it 'should flash error message if search bar is blank' do
      post :search_tmdb, {:search_terms => ''}
      expect(flash[:warning]).to eq("Invalid search term")
    end
  end

  describe 'Adding movies' do
    it 'should flash a message that says no options were selected' do
      post :add_tmdb, {:tmdb_movies => {}}
      expect(flash[:warning]).to eq('No movies selected')
    end
  end
    
end
