[![Gem Version](https://badge.fury.io/rb/next_page.svg)](https://badge.fury.io/rb/next_page)
[![RSpec](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml/badge.svg)](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml)
[![RuboCop](https://github.com/RockSolt/next_page/workflows/RuboCop/badge.svg)](https://github.com/RockSolt/next_page/actions?query=workflow%3ARuboCop)
[![Maintainability](https://api.codeclimate.com/v1/badges/0efe1a9b66a0bf161536/maintainability)](https://codeclimate.com/github/RockSolt/next_page/maintainability)

# NextPage
Basic pagination for Rails controllers.

## Usage
Module Pagination provides pagination controllers. It assigns a limit and offset to the resource query and extends the relation with mixin NextPage::PaginationAttributes to provide helper methods for generating links.

### Include the Module
Add an include statement for the module into any controller that needs pagination:

```ruby
include NextPage::Pagination
```

### Invoking Pagination

To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
resource:

```ruby
@photos = paginate_resource(@photos)
```

The resource is decorated, so this should be the last step.

### Default Limit

The default size limit can be overridden by specifying a new default:

```ruby
@photos = paginate_resource(@photos, default_limit: 12)
```


### Sorting
Requests can specify sort order using the parameter `sort` with an attribute name or scope. Sorts can be prefixed with `+` or `-` to indicate ascending or descending. Multiple sorts can be specified either as a comma separated list or via bracket notation.

    /photos?sort=-created_at
    /photos?sort=location,-created_by
    /photos?sort[]=location&photos[]=-created_by

The default sort order is primary key descending. It can be overridden by using the `default_sort` option of `paginate_with`. Use a string formatted just as url parameter would be formatted.

```ruby
paginate_with default_sort: '-created_at'
```

#### Nested Sorts

Nested attributes and scopes can be indicated by providing the association names separated by periods.

    /photos?sort=user.name
    /photos?sort=-user.address.state

#### Directional Scope Sorts

In order to use directions (`+` or `-`) with a scope, the scope must be defined as a class method and take a single parameter. The scope will receive either `'asc'` or `'desc'`. Here is an example of a valid directional scope.

```ruby
def self.status(direction)
  order("CASE status WHEN 'new' THEN 1 WHEN 'in progress' THEN 2 ELSE 3 END #{direction}")
end
```

#### Scope Prefix / Suffix

In order to keep the peace between frontend and backend developers, scope names can include a prefix or suffix that the front end can ignore. For example, given a scope that sorts on a derived attribute (such as status in the _Direction Scope Sorts_ example), the backend developer might prefer to name the scope status_sort or sort_by_status, as a class method that shares the same name as an attribute might be unclear. However, the frontend developer does not want a query parameter that says <tt>sort=sort_by_status</tt>; it is an exception because it doesn't match the name of the attribute (and it's not pretty).

The configuration allows a prefix and or suffix to be specified. If either is specified, then in addition to looking for a scope that matches the parameter name, it will also look for a scope that matches the prefixed and/or suffixed name. Prefixes are defined by configuration option <tt>sort_scope_prefix</tt> and suffixes are defined by <tt>sort_scope_suffix</tt>.

For example, if the backend developer prefers <tt>sort_by_status</tt> then the following configuration can be used:

```ruby
NextPage.configure do |config|
  config.sort_scope_prefix = 'sort_by_'
end
``` 
This allows the query parameter to be the following:

    sort=status



### Link Helpers
This gem does not do any rendering. It does provide helper methods for generating links. The resource will include the following additional methods (when the request header Accept is `'application/vnd.api+json'`):
- current_page
- next_page
- total_pages
- per_page

#### Count Query
In some cases (such as grouping), calling count on the query does not provide an accurate representation. If that is the case, then there are two ways to override the default behavior:
- provide a count_query that can resolve the attributes
- specify the following attributes manually: current_page, total_count, and per_page


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'next_page'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install next_page
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
