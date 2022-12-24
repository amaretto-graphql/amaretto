module Amaretto
  module Grip
    class GraphQL
      include HTTP::Handler

      getter schema : ::GraphQL::Schema

      def initialize(query : ::GraphQL::BaseQuery)
        @schema = ::GraphQL::Schema.new(query)
      end

      def initialize(query : ::GraphQL::BaseQuery, mutation : ::GraphQL::BaseMutation)
        @schema = ::GraphQL::Schema.new(query, mutation)
      end

      def call(context : HTTP::Server::Context)
        raise ::Grip::Exceptions::MethodNotAllowed.new if context.request.method != "POST"

        query = context.fetch_json_params.["query"].as(String)
        variables = context.fetch_json_params.["variables"]?.as(Hash(String, JSON::Any)?)
        operation_name = context.fetch_json_params.["operationName"]?.as(String?)

        context.response.content_type = "application/json"
        context.response.print(schema.execute(query, variables, operation_name, Context.new(context)))

        context
      end
    end
  end
end
