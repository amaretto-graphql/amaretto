require "../src/amaretto"
require "./mutations"
require "./queries"

module Untitled
  class Schema
    include Amaretto::Schema

    include Queries
    include Mutations
  end
end

query = Untitled::Schema::Query.new
mutation = Untitled::Schema::Mutation.new

schema = GraphQL::Schema.new(query, mutation)
puts schema.document.to_s
