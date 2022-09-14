require "graphql"
require "./amaretto/**"

module Amaretto
  alias Enum = GraphQL::Enum

  alias Annotations::Input = GraphQL::InputObject
  alias Annotations::Output = GraphQL::Object
  alias Annotations::Scalar = GraphQL::Scalar
  alias Annotations::Field = GraphQL::Field

  alias Objects::Input = GraphQL::BaseInputObject
  alias Objects::Output = GraphQL::BaseObject
  alias Objects::Scalar = GraphQL::BaseScalar
  alias Context = GraphQL::Context
end
