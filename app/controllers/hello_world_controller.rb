class HelloWorldController < ApplicationController
  def index
  	s = "Stranger"
    @hello_world_props = { name: s }
  end
end
