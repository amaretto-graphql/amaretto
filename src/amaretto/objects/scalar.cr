module Amaretto
  module Objects
    module Scalar
      macro included
        macro finished
          __build_helpers__
        end
      end

      macro __build_helpers__
        {% name = @type.stringify.split("::").last %}
        {% ancestors = @type.ancestors.reject { |ancestor| ancestor.<=(Amaretto::Objects::Scalar) || ancestor.<=(Reference) || ancestor.<=(Object) } %}

        @[GraphQL::Scalar(name: {{name}})]
        class Type < GraphQL::BaseScalar
          {% for ancestor in ancestors %}
            include {{ancestor}}
          {% end%}

          {% for method in @type.methods %}
            {{method}}
          {% end %}
        end
      end
    end
  end
end
