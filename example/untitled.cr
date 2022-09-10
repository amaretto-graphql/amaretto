require "../src/amaretto"

module Untitled
  class Input
    include Amaretto::Objects::Input

    property first_name : String
    property last_name : String

    def initialize(@first_name : String, @last_name : String)
    end
  end

  class Output
    include Amaretto::Objects::Output

    property first_name : String
    property last_name : String

    def initialize(@first_name : String, @last_name : String)
    end
  end

  class Schema
    include Amaretto::Schema

    @[Amaretto::Annotations::Query]
    def get_user : Output::Type
      Output::Type.new(first_name: "John", last_name: "Doe")
    end

    @[Amaretto::Annotations::Mutation]
    def create_user(user : Input::Type) : Output::Type
      Output::Type.new(first_name: user.first_name, last_name: user.last_name)
    end
  end
end

query = Untitled::Schema::Query.new
mutation = Untitled::Schema::Mutation.new

schema = GraphQL::Schema.new(query, mutation)
puts schema.document.to_s