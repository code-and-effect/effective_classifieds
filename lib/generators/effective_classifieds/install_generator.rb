module EffectiveMemberships
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectiveClassifieds initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_classifieds.rb', 'config/initializers/effective_classifieds.rb'
      end

      def create_migration_file
        @classifieds_table_name  = ':' + EffectiveClassifieds.classifieds_table_name.to_s
        @classified_wizards_table_name  = ':' + EffectiveClassifieds.classified_wizards_table_name.to_s

        migration_template ('../' * 3) + 'db/migrate/01_create_effective_classifieds.rb.erb', 'db/migrate/create_effective_classifieds.rb'
      end

    end
  end
end
