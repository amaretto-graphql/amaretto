module Amaretto
  module Kemal
    class Context < Context
      property context : HTTP::Server::Context

      def initialize(@context : HTTP::Server::Context)
      end

      forward_missing_to context
    end
  end
end
