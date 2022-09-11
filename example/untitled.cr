require "../src/amaretto"
require "uuid"

module Queries
  # You can split query definitions into countless modules
  # for readability.
  alias Context = Untitled::Context::Type
  alias Query = Amaretto::Annotations::Query

  @[Query]
  def message(context : Context) : String
    "Hi, #{context.current_user["firstName"]}!"
  end
end

module Mutations
  # You can split mutation definitions into countless modules
  # for readability.
  alias Context = Untitled::Context::Type
  alias Message = Untitled::Message::Type
  alias Mutation = Amaretto::Annotations::Mutation

  @[Mutation]
  def echo(message : Message, context : Context) : String
    "#{message.id}: #{message.text} from #{context.current_user["firstName"]}!"
  end
end

module Untitled
  # You can include modules which define queries and mutations
  # or define them in the schema class.
  class Schema
    include Amaretto::Schema

    include Queries
    include Mutations

    @[Amaretto::Annotations::Query]
    def reversed_random_id : Scalar::Type
      Scalar::Type.new(UUID.random.to_s)
    end
  end

  # Context class lets fields access global data, like database connections.
  class Context
    include Amaretto::Context

    property current_user : Hash(String, String)

    def initialize(@current_user : Hash(String, String))
    end
  end

  # Input/Output module lets you define custom input and output types.
  class Message
    include Amaretto::Objects::Input

    property id : String
    property text : String

    def initialize(@id : String, @text : String)
    end
  end

  # Scalar module lets you define custom types using to_json and from_json functions.
  class Scalar
    include Amaretto::Objects::Scalar

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

query = Untitled::Schema::Query.new
mutation = Untitled::Schema::Mutation.new

schema = GraphQL::Schema.new(query, mutation)
context = Untitled::Context::Type.new({"firstName" => "John", "lastName" => "Doe"})

puts schema.document.to_s

puts schema.execute("query{message}", nil, nil, context)
puts schema.execute("query{reversedRandomId}", nil, nil)
puts schema.execute("mutation{echo(message:{id: \"#{UUID.random}\", text: \"Hello\"})}", nil, nil, context)
