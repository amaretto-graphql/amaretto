module Amaretto
  module Grip
    class GraphiQL
      include HTTP::Handler

      getter url : String = "/graphql"

      def initialize(@url : String = "/graphql")
      end

      def call(context : HTTP::Server::Context) : HTTP::Server::Context
        raise ::Grip::Exceptions::MethodNotAllowed.new if context.request.method != "GET"

        context.response.content_type = "text/html"
        context.response.print(ECR.render("#{__DIR__}/../templates/index.ecr"))

        context
      end
    end
  end
end
