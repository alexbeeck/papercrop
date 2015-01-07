module Papercrop
  # Provides helper methods that can be used in migrations.
  module Schema
    COLUMNS = {
      :crop_x       => :string,
      :crop_y       => :string,
      :crop_w       => :string,
      :crop_h       => :string,
      :original_w   => :string,
      :original_h   => :string,
      :box_w        => :string
    }

    def self.included(base)
      ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements

      if defined?(ActiveRecord::Migration::CommandRecorder) # Rails 3.1+
        ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
      end
    end

    module Statements
      def add_attachment_crop(table_name, *attachment_names)
        raise ArgumentError, "Please specify attachment name in your add_attachment call in your migration." if attachment_names.empty?

        attachment_names.each do |attachment_name|
          COLUMNS.each_pair do |column_name, column_type|
            add_column(table_name, "#{attachment_name}_#{column_name}", column_type)
          end
        end
      end

      def remove_attachment_crop(table_name, *attachment_names)
        raise ArgumentError, "Please specify attachment name in your remove_attachment call in your migration." if attachment_names.empty?

        attachment_names.each do |attachment_name|
          COLUMNS.each_pair do |column_name, column_type|
            remove_column(table_name, "#{attachment_name}_#{column_name}")
          end
        end
      end
    end

    module TableDefinition
      def attachment_crop(*attachment_names)
        attachment_names.each do |attachment_name|
          COLUMNS.each_pair do |column_name, column_type|
            column("#{attachment_name}_#{column_name}", column_type)
          end
        end
      end
    end

    module CommandRecorder
      def add_attachment_crop(*args)
        record(:add_attachment_crop, args)
      end

      private

      def invert_add_attachment_crop(args)
        [:remove_attachment_crop, args]
      end
    end
  end
end
