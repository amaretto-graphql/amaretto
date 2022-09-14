# Amaretto

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     amaretto:
       github: amaretto-graphql/amaretto
   ```

2. Run `shards install`

## Usage

```crystal
require "amaretto"

module Untitled
  class Schema < Amaretto::Schema
    @[Amaretto::Annotations::Query]
    def list_users : Array(String)
      [] of String
    end

    @[Amaretto::Annotations::Mutation]
    def create_user(string : String) : String
      raise Exception.new("User #{string} already exists!")
    end
  end
end

query = Untitled::Schema::Query.new
mutation = Untitled::Schema::Mutation.new

schema = GraphQL::Schema.new(query, mutation)
puts schema.document.to_s
```

## Contributing

1. Fork it (<https://github.com/amaretto-graphql/amaretto/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Giorgi Kavrelishvili](https://github.com/grkek) - creator and maintainer
