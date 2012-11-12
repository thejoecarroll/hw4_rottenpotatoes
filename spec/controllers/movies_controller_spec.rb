require 'spec_helper'

describe "To implement the feature 'search for movies by director'," do
  describe MoviesController do
    describe ".find_movies_with_same_director (happy path)" do
      before :each do
        @current_movie = mock("Movie", :id => 5, :director => "some director")
        @fake_results = [mock("Movie", :title => "fake 1"), mock("Movie", :title => "fake 2")]
        Movie.stub(:find_by_id).and_return(@current_movie)
      end
      it "should should call the model method that performs a search by director" do
        Movie.should_receive(:find_all_by_director).with("some director").and_return(@fake_results)
        get :find_movies_with_same_director, {:id => 5}
      end
      it "should select the 'More Movies by the Director' template" do
        Movie.stub(:find_all_by_director).with("some director").and_return(@fake_results)
        get :find_movies_with_same_director, {:id => 5}
        response.should render_template("find_movies_with_same_director")
      end
      it "should make the search results available to that template" do
        Movie.stub(:find_all_by_director).with("some director").and_return(@fake_results)
        get :find_movies_with_same_director, {:id => 5}
        assigns(:movies).should == @fake_results
      end
    end
    describe ".find_movies_with_same_director (sad path)" do
      before :each do
        @current_movie = mock("Movie", :id => 1, :director => nil, :title => "fake 1")
        @fake_results = []
        Movie.stub(:find_by_id).and_return(@current_movie)
        Movie.stub(:find_all_by_director).with(nil).and_return(@fake_results)
      end
      it "should redirect to the home page" do
        get :find_movies_with_same_director, {:id => 1}
        response.should redirect_to(movies_path)
      end
      it "should notify via flash that director info was missing" do
        get :find_movies_with_same_director, {:id => 1}
        flash[:notice].should match (/^.+ has no director info/)
      end 
    end
  end
end
