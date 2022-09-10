module Amaretto
  module Schema
    macro included
      macro finished
        __build_helpers__
      end
    end

    macro __build_helpers__
      @[GraphQL::Object]
      class Query < GraphQL::BaseQuery
        include GraphQL::ObjectType
        include GraphQL::QueryType

        {% for method in @type.methods.select(&.annotation(Amaretto::Annotations::Query)) %}
          @[GraphQL::Field]
          {{method}}
        {% end %}
      end

      @[GraphQL::Object]
      class Mutation < GraphQL::BaseMutation
        include GraphQL::ObjectType
        include GraphQL::MutationType

        {% for method in @type.methods.select(&.annotation(Amaretto::Annotations::Mutation)) %}
          @[GraphQL::Field]
          {{method}}
        {% end %}
      end
    end
  end
end