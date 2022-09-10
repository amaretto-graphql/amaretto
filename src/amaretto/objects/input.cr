module Amaretto
  module Objects
    module Input
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

      @[GraphQL::InputObject(name: {{name}})]
      class Type < GraphQL::BaseInputObject
        {% for method in initialize %}
          @[GraphQL::Field]
          {{method}}
        {% end %}

        {% for method in getters %}
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
