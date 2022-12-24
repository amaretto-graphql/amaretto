require "../../../src/amaretto"
require "../../../src/amaretto/kemal"

module Camel
  class Schema < Amaretto::Schema
    alias Context = Amaretto::Kemal::Context

    @[Amaretto::Annotations::Query]
    def echo(context : Context, message : String) : String
      message
    end
  end
end

add_handler Amaretto::Kemal::GraphQL.new(query: Camel::Schema::Query.new)
add_handler Amaretto::Kemal::GraphiQL.new

Kemal.run
