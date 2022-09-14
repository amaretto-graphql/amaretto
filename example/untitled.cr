require "../src/amaretto"
require "uuid"

module Queries
  # You can split query definitions into countless modules
  # for readability.
  alias Query = Amaretto::Annotations::Query

  @[Query]
  def message(context : Context) : String
    "Hi, #{context.current_user["firstName"]}!"
  end
end

module Mutations
  # You can split mutation definitions into countless modules
  # for readability.
  alias Context = Untitled::Context
  alias Mutation = Amaretto::Annotations::Mutation

  alias Input = Untitled::Input
  alias Output = Untitled::Output

  @[Mutation]
  def echo(message : Input, context : Context) : Output
    Output.new(id: message.id, text_field: "#{message.text_field} from #{context.current_user["firstName"]}!")
  end
end

module Untitled
  # You can include modules which define queries and mutations
  # or define them in the schema class.
  class Schema < Amaretto::Schema
    include Queries
    include Mutations

    @[Amaretto::Annotations::Query]
    def reversed_random_id : Scalar
      Scalar.new(UUID.random.to_s)
    end
  end

  # Context class lets fields access global data, like database connections.
  class Context < Amaretto::Context
    property current_user : Hash(String, String)

    def initialize(@current_user : Hash(String, String))
    end
  end

  # Input/Output module lets you define custom input and output types.
  @[Amaretto::Annotations::Input]
  class Input < Amaretto::Objects::Input
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    property id : String

    @[JSON::Field(key: "textField")]
    property text_field : String

    @[Amaretto::Annotations::Field]
    def initialize(@id : String, @text_field : String)
    end
  end

  @[Amaretto::Annotations::Output(name: "Tuptuo")]
  class Output < Amaretto::Objects::Output
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    @[Amaretto::Annotations::Field]
    property id : String

    @[JSON::Field(key: "textField")]
    @[Amaretto::Annotations::Field]
    property text_field : String

    def initialize(@id : String, @text_field : String)
    end
  end

  @[Amaretto::Annotations::Scalar(name: "Scalar")]
  class Scalar < Amaretto::Objects::Scalar
    property value : String

    def initialize(@value : String)
    end

    def self.from_json(string_or_io)
      self.new(String.from_json(string_or_io).reverse)
    end

    def to_json(builder : JSON::Builder)
      builder.scalar(@value.reverse)
    end
  end
end

class QueryChain
  alias Context = Untitled::Context
  alias Schema = Untitled::Schema
  alias Input = Untitled::Input
  alias Output = Untitled::Output

  property schema : GraphQL::Schema = GraphQL::Schema.new(Schema::Query.new, Schema::Mutation.new)
  property context : Amaretto::Context = Context.new({"firstName" => "John", "lastName" => "Doe"})

  def query_simple
    schema.execute("query{message}", nil, nil, context)
  end

  def query_scalar
    schema.execute("query{reversedRandomId}", nil, nil)
  end

  def mutation_simple
    schema.execute("mutation{echo(message:{id: \"#{UUID.random}\", textField: \"Hello\"}) {id}}", nil, nil, context)
  end

  def object_from_json
    [Input.from_json("{\"id\": \"#{UUID.random}\", \"textField\": \"Hello\"}"), Output.from_json("{\"id\": \"#{UUID.random}\", \"textField\": \"Hello\"}")]
  end

  def document
    schema.document.to_s
  end
end

query_chain = QueryChain.new

puts query_chain.document
puts query_chain.query_simple
puts query_chain.query_scalar
puts query_chain.mutation_simple

input, output = query_chain.object_from_json

pp input
pp output
