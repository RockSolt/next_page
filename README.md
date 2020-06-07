[![Gem Version](https://badge.fury.io/rb/next_page.svg)](https://badge.fury.io/rb/next_page)
[![RuboCop](https://github.com/RockSolt/next_page/workflows/RuboCop/badge.svg)](https://github.com/RockSolt/next_page/actions?query=workflow%3ARuboCop)

# NextPage
Basic pagination for Rails controllers.

## Usage
Module Pagination provides pagination for index methods. It assigns a limit and offset to the resource query and extends the relation with mixin NextPage::PaginationAttributes to provide helper methods for generating links.

### Include the Module
Add an include statement for the module into any controller that needs pagination:

```ruby
include NextPage::Pagination
```

There are two ways to paginate: using a before filter or by calling `paginate_resource` explicitly.

### Before Filter
Here's an example of using the before filter in a controller:

```ruby
before_action :apply_next_page_pagination, only: :index
```

This entry point uses the following conventions to apply pagination:
- the name of the instance variable is the sames as the component (for example PhotosController -> @photos)
- the name of the models is the controller name singularized (for example PhotosController -> Photo)

Either can be overridden by calling method `paginate_with` in the controller. The two override options are
`instance_variable_name` and `model_class`. For example, if the PhotosController used the model Picture and the
instance variable name @photographs, the controller declares it as follows:

```ruby
paginate_with instance_variable_name: :photographs, model_class: 'Picture'
```

If the before filter is used, it will populate an instance variable. The action should NOT reset the variable, as
that removes pagination.

### Invoking Pagination Directly
To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
resource:

```ruby
@photos = paginate_resource(@photos)
```

### Sorting
Requests can specify sort order using the parameter `sort` with an attribute name, scope, or nested attribute. Attributes and nested attributes can be prefixed with `+` or `-` to indicate ascending or descending. Multiple sorts can be specified either as a comma separated list or via bracket notation.

    /photos?sort=-created_at
    /photos?sort=location,-created_by
    /photos?sort[]=location&photos[]=-created_by

The default sort order is primary key descending. It can be overridden by using the `default_sort` option of `paginate_with`. Use a string formatted just as url parameter would be formatted.

```ruby
paginate_with default_sort: '-created_at'
```

### Default Limit
The default size limit can be overridden with the `paginate_with` method for either type of paginagion. Pass option
`default_limit` to specify an override:

```ruby
paginate_with default_limit: 25
```

All the options can be mixed and matches when calling `paginate_with`:

```ruby
paginate_with model_class: 'Photo', default_limit: 12
paginate_with default_limit: 12, instance_variable_name: 'data'
```

### Link Helpers
This gem does not do any rendering. It does provide helper methods for generating links. The resource will include the following additional methods:
- current_page
- next_page
- total_pages
- per_page

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
