module Amaretto
  module Objects
    module Output
      macro included
      macro finished
        __build_helpers__
      end
    end

      macro __build_helpers__
      {% initialize = @type.methods.select { |method| method.name.stringify == "initialize" } %}
      {% setters = @type.methods.select { |method| method.name.includes?("=") } %}
      {% getters = @type.methods.select { |method| !method.name.includes?("=") && !method.name.includes?("initialize") && method.visibility == :public } %}
      {% privates = @type.methods.select { |method| method.visibility == :private } %}
      {% name = @type.stringify.split("::").last %}

      @[GraphQL::Object(name: {{name}})]
      class Type < GraphQL::BaseObject
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
