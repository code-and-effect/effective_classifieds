# Effective Classifieds

Submit classified ads for job openings and equipment sales.

## Getting Started

This requires Rails 6+ and Twitter Bootstrap 4 and just works with Devise.

Please first install the [effective_datatables](https://github.com/code-and-effect/effective_datatables) gem.

Please download and install the [Twitter Bootstrap4](http://getbootstrap.com)

Add to your Gemfile:

```ruby
gem 'haml-rails' # or try using gem 'hamlit-rails'
gem 'effective_classifieds'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_classifieds:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table names, manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

Please add the following to your User model:

```
effective_classifieds_user

Use the following datatables to display to your user their applicants dues:

```haml
%h2 My Classifieds
- datatable = EffectiveClassifiedsDatatable.new(self)
```

and

```
Add a link to the admin menu:

```haml
- if can? :admin, :effective_classifieds
  - if can? :index, Effective::Classified
    = nav_link_to 'Classifieds', effective_classifieds.admin_classifieds_path
```

## Configuration

## Authorization

All authorization checks are handled via the effective_resources gem found in the `config/initializers/effective_resources.rb` file.

## Effective Roles

This gem works with effective roles for the representative roles.

Configure your `config/initializers/effective_roles.rb` something like this:

```
```

## Permissions

The permissions you actually want to define are as follows (using CanCan):

```ruby
can([:index, :show], Effective::Classified) { |classified| classified.published? }
can([:show, :edit, :update], Effective::Classified) { |classified| classified.owner == user }

can(:new, EffectiveClassifieds.ClassifiedSubmission)
can([:show, :index, :destroy], EffectiveClassifieds.ClassifiedSubmission) { |submission| submission.owner == user }
can([:update], EffectiveClassifieds.ClassifiedSubmission) { |submission| submission.owner == user && !submission.was_submitted? }

if user.admin?
  can :admin, :effective_classifieds

  can(crud - [:destroy], Classified)
  can(:approve, Classified) { |classified| classified.was_submitted? && !classified.approved? }
  can(:destroy, Classified) { |classified| !classified.draft? }

  can([:index, :show], EffectiveClassifieds.ClassifiedSubmission)
end
```

## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Testing

Run tests by:

```ruby
rails test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
