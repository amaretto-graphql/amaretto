module Amaretto
  module Kemal
    class GraphiQL < ::Kemal::Handler
      only ["/graphiql"]

      def call(context : HTTP::Server::Context)
        return call_next(context) unless only_match?(context)

        url = "/graphql"
        template = ECR.render("#{__DIR__}/../templates/index.ecr")

        context.response.content_type = "text/html"
        context.response.print template

        context
      end
    end
  end
end
