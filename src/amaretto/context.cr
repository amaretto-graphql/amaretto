module Amaretto
  module Context
    macro included
      macro finished
        __build_helpers__
      end
    end

    macro __build_helpers__
      class Type < GraphQL::Context
        {% for method in @type.methods %}
          {{method}}
        {% end %}
      end
    end
  end
end
