module Amaretto
  module Kemal
    class GraphQL < ::Kemal::Handler
      only ["/graphql"], "POST"

      getter schema : ::GraphQL::Schema

      def initialize(query : ::GraphQL::BaseQuery)
        @schema = ::GraphQL::Schema.new(query)
      end

      def initialize(query : ::GraphQL::BaseQuery, mutation : ::GraphQL::BaseMutation)
        @schema = ::GraphQL::Schema.new(query, mutation)
      end

      def call(context : HTTP::Server::Context)
        return call_next(context) unless only_match?(context)

        query = context.params.json["query"].as(String)
        variables = context.params.json["variables"]?.as(Hash(String, JSON::Any)?)
        operation_name = context.params.json["operationName"]?.as(String?)

        context.response.content_type = "application/json"
        context.response.print(schema.execute(query, variables, operation_name, Context.new(context)))

        context
      end
    end
  end
end
