module Amaretto
  module Objects
    module Output
      macro included
        macro finished
          __build_helpers__
        end
      end

      macro __build_helpers__
        {% initialize = @type.methods.select(&.name.stringify.==("initialize")) %}
        {% setters = @type.methods.select(&.name.includes?("=")) %}
        {% getters = @type.methods.select { |method| !method.name.includes?("=") && !method.name.==("initialize") && method.visibility == :public } %}
        {% privates = @type.methods.select(&.visibility.==(:private)) %}
        {% name = @type.stringify.split("::").last %}
        {% ancestors = @type.ancestors.reject { |ancestor| ancestor.<=(Amaretto::Objects::Output) || ancestor.<=(Reference) || ancestor.<=(Object) } %}

        @[GraphQL::Object(name: {{name}})]
        class Type < GraphQL::BaseObject
          {% for ancestor in ancestors %}
            include {{ancestor}}
          {% end %}

          {% for method in initialize %}
            {{method}}
          {% end %}

          {% for method in getters %}
            @[GraphQL::Field]
            {{method}}
          {% end %}

          {% for method in setters %}
            {{method}}
          {% end %}

          {% for method in privates %}
            {{method}}
          {% end %}
        end
      end
    end
  end
end
