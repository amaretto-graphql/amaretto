require "graphql"

require "./amaretto/annotations/**"
require "./amaretto/schema"

module Amaretto
  alias Context = GraphQL::Context

  alias Annotations::Input = GraphQL::InputObject
  alias Annotations::Output = GraphQL::Object
  alias Annotations::Scalar = GraphQL::Scalar
  alias Annotations::Field = GraphQL::Field

  alias Objects::Enum = GraphQL::Enum
  alias Objects::Input = GraphQL::BaseInputObject
  alias Objects::Output = GraphQL::BaseObject
  alias Objects::Scalar = GraphQL::BaseScalar
end
