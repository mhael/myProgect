class HelloController < ApplicationController
  def index
    flash[:notise] = "Hello, world"
  end

end

