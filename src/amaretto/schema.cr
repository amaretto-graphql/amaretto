module Amaretto
  class Schema
    macro inherited
      macro finished
        __build_helpers__
      end
    end

    macro __build_helpers__
      {% query_methods = [] of Nil %}
      {% mutation_methods = [] of Nil %}

      {% ancestors = @type.ancestors %}

      {% for parent in ancestors %}
        {% for method in parent.methods.select(&.annotation(Amaretto::Annotations::Query)) %}
          {% query_methods << method %}
        {% end %}

        {% for method in parent.methods.select(&.annotation(Amaretto::Annotations::Mutation)) %}
          {% mutation_methods << method %}
        {% end %}
      {% end %}

      {% for method in @type.methods.select(&.annotation(Amaretto::Annotations::Query)) %}
        {% query_methods << method %}
      {% end %}

      {% for method in @type.methods.select(&.annotation(Amaretto::Annotations::Mutation)) %}
        {% mutation_methods << method %}
      {% end %}

      @[GraphQL::Object]
      class Query < GraphQL::BaseQuery
        include GraphQL::ObjectType
        include GraphQL::QueryType

        {% for method in query_methods %}
          @[GraphQL::Field]
          {{method}}
        {% end %}
      end

      @[GraphQL::Object]
      class Mutation < GraphQL::BaseMutation
        include GraphQL::ObjectType
        include GraphQL::MutationType

        {% for method in mutation_methods %}
          @[GraphQL::Field]
          {{method}}
        {% end %}
      end
    end
  end
end
