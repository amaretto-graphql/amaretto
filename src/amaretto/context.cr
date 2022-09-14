module Amaretto
  module Context
    macro included
      macro finished
        __build_helpers__
      end
    end

    macro __build_helpers__
      {% ancestors = @type.ancestors.reject { |ancestor| ancestor.<=(Amaretto::Context) || ancestor.<=(Reference) || ancestor.<=(Object) } %}

      class Type < GraphQL::Context
        {% for ancestor in ancestors %}
          include {{ancestor}}
        {% end %}

        {% for method in @type.methods %}
          {{method}}
        {% end %}
      end
    end
  end
end
