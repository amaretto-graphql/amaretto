module Untitled
  module Mutations
    @[Amaretto::Annotations::Mutation]
    def echo(message : String) : String
      message
    end
  end
end
