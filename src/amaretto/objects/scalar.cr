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

        @[GraphQL::Scalar(name: {{name}})]
        class Type < GraphQL::BaseScalar
          {% for method in @type.methods %}
            {{method}}
          {% end %}
        end
      end
    end
  end
end
