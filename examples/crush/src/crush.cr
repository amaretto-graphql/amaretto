require "../../../src/amaretto"
require "../../../src/amaretto/grip"

module Crush
  class Schema < Amaretto::Schema
    alias Context = Amaretto::Grip::Context

    @[Amaretto::Annotations::Query]
    def echo(context : Context, message : String) : String
      message
    end
  end

  class Application
    include Grip::Application

    def initialize
      routes
    end

    def routes
      forward "/graphql", Amaretto::Grip::GraphQL, query: Schema::Query.new
      forward "/graphiql", Amaretto::Grip::GraphiQL if environment == "development"
    end
  end
end

app = Crush::Application.new
app.run
