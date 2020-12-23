# -*- encoding: utf-8 -*-
# stub: partitioned 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "partitioned".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Keith Gabryelski".freeze, "Aleksandr Dembskiy".freeze, "Edward Slavich".freeze]
  s.date = "2015-10-02"
  s.description = "A gem providing support for table partitioning in ActiveRecord. Support is available for postgres and AWS RedShift databases. Other features include child table management (creation and deletion) and bulk data creating and updating.".freeze
  s.email = "keith@fiksu.com".freeze
  s.files = [".gitignore".freeze, ".rspec".freeze, ".travis.yml".freeze, "Gemfile".freeze, "LICENSE".freeze, "PARTITIONING_EXPLAINED.txt".freeze, "README.md".freeze, "Rakefile".freeze, "examples/README".freeze, "examples/company_id.rb".freeze, "examples/company_id_and_created_at.rb".freeze, "examples/created_at.rb".freeze, "examples/created_at_referencing_awards.rb".freeze, "examples/id.rb".freeze, "examples/lib/by_company_id.rb".freeze, "examples/lib/command_line_tool_mixin.rb".freeze, "examples/lib/company.rb".freeze, "examples/lib/get_options.rb".freeze, "examples/lib/roman.rb".freeze, "examples/start_date.rb".freeze, "init.rb".freeze, "lib/monkey_patch_activerecord.rb".freeze, "lib/monkey_patch_postgres.rb".freeze, "lib/monkey_patch_redshift.rb".freeze, "lib/partitioned.rb".freeze, "lib/partitioned/active_record_overrides.rb".freeze, "lib/partitioned/by_created_at.rb".freeze, "lib/partitioned/by_daily_time_field.rb".freeze, "lib/partitioned/by_foreign_key.rb".freeze, "lib/partitioned/by_id.rb".freeze, "lib/partitioned/by_integer_field.rb".freeze, "lib/partitioned/by_monthly_time_field.rb".freeze, "lib/partitioned/by_time_field.rb".freeze, "lib/partitioned/by_weekly_time_field.rb".freeze, "lib/partitioned/by_yearly_time_field.rb".freeze, "lib/partitioned/multi_level.rb".freeze, "lib/partitioned/multi_level/configurator/data.rb".freeze, "lib/partitioned/multi_level/configurator/dsl.rb".freeze, "lib/partitioned/multi_level/configurator/reader.rb".freeze, "lib/partitioned/multi_level/partition_manager.rb".freeze, "lib/partitioned/partitioned_base.rb".freeze, "lib/partitioned/partitioned_base/configurator.rb".freeze, "lib/partitioned/partitioned_base/configurator/data.rb".freeze, "lib/partitioned/partitioned_base/configurator/dsl.rb".freeze, "lib/partitioned/partitioned_base/configurator/reader.rb".freeze, "lib/partitioned/partitioned_base/partition_manager.rb".freeze, "lib/partitioned/partitioned_base/redshift_sql_adapter.rb".freeze, "lib/partitioned/partitioned_base/sql_adapter.rb".freeze, "lib/partitioned/version.rb".freeze, "lib/tasks/desirable_tasks.rake".freeze, "partitioned.gemspec".freeze, "spec/dummy/.gitignore".freeze, "spec/dummy/.rspec".freeze, "spec/dummy/README.rdoc".freeze, "spec/dummy/Rakefile".freeze, "spec/dummy/app/assets/javascripts/application.js".freeze, "spec/dummy/app/assets/stylesheets/application.css".freeze, "spec/dummy/app/controllers/application_controller.rb".freeze, "spec/dummy/app/helpers/application_helper.rb".freeze, "spec/dummy/app/views/layouts/application.html.erb".freeze, "spec/dummy/bin/bundle".freeze, "spec/dummy/bin/rails".freeze, "spec/dummy/bin/rake".freeze, "spec/dummy/config.ru".freeze, "spec/dummy/config/application.rb".freeze, "spec/dummy/config/boot.rb".freeze, "spec/dummy/config/database.yml".freeze, "spec/dummy/config/environment.rb".freeze, "spec/dummy/config/environments/development.rb".freeze, "spec/dummy/config/environments/production.rb".freeze, "spec/dummy/config/environments/test.rb".freeze, "spec/dummy/config/initializers/backtrace_silencers.rb".freeze, "spec/dummy/config/initializers/filter_parameter_logging.rb".freeze, "spec/dummy/config/initializers/inflections.rb".freeze, "spec/dummy/config/initializers/mime_types.rb".freeze, "spec/dummy/config/initializers/secret_token.rb".freeze, "spec/dummy/config/initializers/session_store.rb".freeze, "spec/dummy/config/initializers/wrap_parameters.rb".freeze, "spec/dummy/config/locales/en.yml".freeze, "spec/dummy/config/routes.rb".freeze, "spec/dummy/db/seeds.rb".freeze, "spec/dummy/public/404.html".freeze, "spec/dummy/public/422.html".freeze, "spec/dummy/public/500.html".freeze, "spec/dummy/public/favicon.ico".freeze, "spec/dummy/public/robots.txt".freeze, "spec/dummy/test/test_helper.rb".freeze, "spec/monkey_patch_postgres_spec.rb".freeze, "spec/partitioned/by_created_at_spec.rb".freeze, "spec/partitioned/by_daily_time_field_spec.rb".freeze, "spec/partitioned/by_foreign_key_spec.rb".freeze, "spec/partitioned/by_id_spec.rb".freeze, "spec/partitioned/by_integer_field_spec.rb".freeze, "spec/partitioned/by_monthly_time_field_spec.rb".freeze, "spec/partitioned/by_time_field_spec.rb".freeze, "spec/partitioned/by_weekly_time_field_spec.rb".freeze, "spec/partitioned/by_yearly_time_field_spec.rb".freeze, "spec/partitioned/multi_level/configurator/dsl_spec.rb".freeze, "spec/partitioned/multi_level/configurator/reader_spec.rb".freeze, "spec/partitioned/partitioned_base/configurator/dsl_spec.rb".freeze, "spec/partitioned/partitioned_base/configurator/reader_spec.rb".freeze, "spec/partitioned/partitioned_base/sql_adapter_spec.rb".freeze, "spec/partitioned/partitioned_base_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/support/shared_example_spec_helper_for_integer_key.rb".freeze, "spec/support/shared_example_spec_helper_for_time_key.rb".freeze, "spec/support/tables_spec_helper.rb".freeze, "travis/before.sh".freeze]
  s.homepage = "http://github.com/fiksu/partitioned".freeze
  s.licenses = ["New BSD License".freeze]
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Postgres table partitioning support for ActiveRecord.".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jquery-rails>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<pg>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<bulk_data_methods>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activerecord-redshift-adapter>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>.freeze, ["~> 4.2.1"])
      s.add_development_dependency(%q<rails>.freeze, ["~> 4.2.1"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
    else
      s.add_dependency(%q<jquery-rails>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<bulk_data_methods>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord-redshift-adapter>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord>.freeze, ["~> 4.2.1"])
      s.add_dependency(%q<rails>.freeze, ["~> 4.2.1"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<jquery-rails>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<bulk_data_methods>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord-redshift-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, ["~> 4.2.1"])
    s.add_dependency(%q<rails>.freeze, ["~> 4.2.1"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
  end
end
