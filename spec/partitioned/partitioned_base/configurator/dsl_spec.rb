require 'spec_helper'

module Partitioned
  class PartitionedBase
    module Configurator
      describe Dsl do

        before(:all) do
          class Employee

          end
        end

        after(:all) do
          Partitioned::PartitionedBase::Configurator.send(:remove_const, :Employee)
        end

        let!(:dsl) { Partitioned::PartitionedBase::Configurator::Dsl.new(Employee) }

        describe "initialize" do

          let!(:data_stubs) do
            {
              "on_field" => nil,
              "indexes" => [],
              "janitorial_archives_needed" => nil,
              "janitorial_creates_needed" => nil,
              "janitorial_drops_needed" => nil,
              "foreign_keys" => [],
              "last_partitions_order_by_clause" => nil,
              "schema_name" => nil,
              "table_alias_name" => nil,
              "name_prefix" => nil,
              "base_name" => nil,
              "part_name" => nil,
              "table_name" => nil,
              "parent_table_schema_name" => nil,
              "parent_table_name" => nil,
              "check_constraint" => nil,
              "encoded_name" => nil,
              "after_partition_table_create_hooks" => [],
            }
          end

          context "when try to create the new object" do

            context "check the model name" do

              it "returns Employer" do
                expect(dsl.model).to eq(Employee)
              end

            end # check the model name

            context "check the object data" do

              it "returns data" do
                expect(dsl.data.instance_values).to eq(data_stubs)
              end

            end # check the object data

          end # when try to create a new object

        end # initialize

        describe "on" do

          context "when try to set the field which used to partition child tables" do

            it "returns data.on value" do
              dsl.on(:company_id)
              expect(dsl.data.on_field).to eq(:company_id)
            end

          end # when try to set the field which used to partition child tables

          context "when try to set the field represented as a string to be interpolated naming the field to partition child tables" do

            it "returns data.on value" do
              dsl.on('#{model.partition_field}')
              expect(dsl.data.on_field).to eq('#{model.partition_field}')
            end

          end # when try to set the field represented as a string to be interpolated naming the field to partition child tables

          context "when try to set the field(with proc) which used to partition child tables" do

            let(:lmd) do
              lambda { |model| model.partition_field }
            end

            it "returns proc" do
              dsl.on lmd
              expect(dsl.data.on_field).to eq(lmd)
            end

          end # when try to set the field which(with proc) used to partition child tables

        end # on

        describe "index" do

          context "when try to set the index to be created on all child tables" do

            it "returns index" do
              dsl.index(:id, { :unique => true })
              expect(dsl.data.indexes.first.field).to eq(:id)
              expect(dsl.data.indexes.first.options).to eq({ :unique => true })
            end

          end # when try to set the index  to be created on all child tables

          context "when try to set the index(with proc) to be created on all child tables" do

            let(:lmd) do
              lambda { |model, *partition_key_values|
                return Partitioned::PartitionedBase::Configurator::Data::Index.new(model.partition_field, {})
              }
            end

            it "returns proc" do
              dsl.index lmd
              expect(dsl.data.indexes.first).to eq(lmd)
            end

          end # when try to set the index(with proc) to be created on all child tables

        end # index

        describe "foreign_key" do

          context "when try to set the foreign key on a child table" do

            it "returns foreign_keys" do
              dsl.foreign_key(:company_id)
              expect(dsl.data.foreign_keys.first.referencing_field).to eq(:company_id)
              expect(dsl.data.foreign_keys.first.referenced_table).to eq("companies")
              expect(dsl.data.foreign_keys.first.referenced_field).to eq(:id)
            end

          end # when try to set the foreign key on a child table

          context "when try to set the foreign key(with proc) on a child table" do

            let(:lmd) do
              lambda { |model, *partition_key_values|
                return Partitioned::PartitionedBase::Configurator::Data::ForeignKey.new(model.foreign_key_field)
              }
            end

            it "returns proc" do
              dsl.index lmd
              expect(dsl.data.indexes.first).to eq(lmd)
            end

          end # when try to set the foreign key(with proc) on a child table

        end # foreign_key

        describe "check_constraint" do

          context "when try to set the check constraint for a given child table" do

            it "returns check_constraint" do
              dsl.check_constraint('company_id = #{field_value}')
              expect(dsl.data.check_constraint).to eq('company_id = #{field_value}')
            end

          end # when try to set the check constraint for a given child table

          context "when try to set the check constraint(with proc) for a given child table" do

            let(:lmd) do
              lambda {|model, value|
                return "#{model.field_to_partition} = #{value}"
              }
            end

            it "returns proc" do
              dsl.check_constraint lmd
              expect(dsl.data.check_constraint).to eq(lmd)
            end

          end # when try to set the check constraint(with proc) for a given child table

        end # check_constraint

        describe "order" do

          context "when try to set the check constraint for a given child table" do

            it "returns check_constraint" do
              dsl.order('tablename desc')
              expect(dsl.data.last_partitions_order_by_clause).to eq('tablename desc')
            end

          end # when try to set the check constraint for a given child table

        end # order

        describe "schema_name" do

          context "when try to set the name of the schema that will contain all child tables" do

            it "returns schema_name" do
              dsl.schema_name("employees_partitions")
              expect(dsl.data.schema_name).to eq("employees_partitions")
            end

          end # when try to set the name of the schema that will contain all child tables

          context "when try to set the schema name represented as a string to be interpolated at run time" do

            it "returns schema_name" do
              dsl.schema_name('#{model.table_name}_partitions')
              expect(dsl.data.schema_name).to eq('#{model.table_name}_partitions')
            end

          end # when try to set the schema name represented as a string to be interpolated at run time

          context "when try to set the name of the schema(with proc) that will contain all child tables" do

            let(:lmd) do
              lambda {|model, *value|
                return "#{model.table_name}_partitions"
              }
            end

            it "returns proc" do
              dsl.schema_name lmd
              expect(dsl.data.schema_name).to eq(lmd)
            end

          end # when try to set the name of the schema(with proc) that will contain all child tables

        end # schema_name

        describe "name_prefix" do

          context "when try to set the name prefix for the child table's name" do

            it "returns name_prefix" do
              dsl.name_prefix("p")
              expect(dsl.data.name_prefix).to eq("p")
            end

          end # when try to set the name prefix for the child table's name

          context "when try to set the name prefix represented as a string to be interpolated at run time" do

            it "returns name_prefix" do
              dsl.name_prefix('#{model.table_name}_child_')
              expect(dsl.data.name_prefix).to eq('#{model.table_name}_child_')
            end

          end # when try to set the name prefix represented as a string to be interpolated at run time

          context "when try to set the name prefix(with proc) for the child table's name" do

            let(:lmd) do
              lambda {|model, *value|
                return "#{model.table_name}_child_"
              }
            end

            it "returns proc" do
              dsl.name_prefix lmd
              expect(dsl.data.name_prefix).to eq(lmd)
            end

          end # when try to set the name prefix(with proc) for the child table's name

        end # name_prefix

        describe "base_name" do

          context "when try to set the name of the child table without the schema name or name prefix" do

            it "returns base_name" do
              dsl.base_name("25")
              expect(dsl.data.base_name).to eq("25")
            end

          end # when try to set the name of the child table without the schema name or name prefix

          context "when try to set the name of the child table represented as a string to be interpolated at run time" do

            it "returns base_name" do
              dsl.base_name('#{model.partition_normalize_key_value(field_value)}')
              expect(dsl.data.base_name).to eq('#{model.partition_normalize_key_value(field_value)}')
            end

          end # when try to set the name of the child table represented as a string to be interpolated at run time

          context "when try to set the name of the child table(with proc) without the schema name or name prefix" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return model.partition_normalize_key_value(*partition_key_values).to_s
              }
            end

            it "returns proc" do
              dsl.base_name lmd
              expect(dsl.data.base_name).to eq(lmd)
            end

          end # when try to set the name of the child table(with proc) without the schema name or name prefix

        end # base_name

        describe "part_name" do

          context "when try to set the part name of the child table without the schema name" do

            it "returns part_name" do
              dsl.part_name("p42")
              expect(dsl.data.part_name).to eq("p42")
            end

          end # when try to set the part name of the child table without the schema name

          context "when try to set the part name of the child table represented as a string to be interpolated at run time" do

            it "returns part_name" do
              dsl.part_name('#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
              expect(dsl.data.part_name).to eq('#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
            end

          end # when try to set the part name of the child table represented as a string to be interpolated at run time

          context "when try to set the part name(with proc) of the child table without the schema name" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}"
              }
            end

            it "returns proc" do
              dsl.part_name lmd
              expect(dsl.data.part_name).to eq(lmd)
            end

          end # when try to set the part name(with proc) of the child table without the schema name

        end # part_name

        describe "table_name" do

          context "when try to set the full name of a child table" do

            it "returns table_name" do
              dsl.table_name("foos_partitions.p42")
              expect(dsl.data.table_name).to eq("foos_partitions.p42")
            end

          end # when try to set the full name of a child table

          context "when try to set the table name of the child table represented as a string to be interpolated at run time" do

            it "returns table_name" do
              dsl.table_name('#{model.table_name}_partitions.#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
              expect(dsl.data.table_name).to eq('#{model.table_name}_partitions.#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
            end

          end # when try to set the table name of the child table represented as a string to be interpolated at run time

          context "when try to set the full name(with proc) of a child table" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}_partitions.#{model.table_name}_child_#{model.partition_normalize_key_value(partition_key_values.first)}"
              }
            end

            it "returns proc" do
              dsl.table_name lmd
              expect(dsl.data.table_name).to eq(lmd)
            end

          end # when try to set the full name(with proc) of a child table

        end # table_name

        describe "parent_table_name" do

          context "when try to set the table name who is the direct ancestor of a child table" do

            it "returns parent_table_name" do
              dsl.parent_table_name("employees")
              expect(dsl.data.parent_table_name).to eq("employees")
            end

          end # when try to set the table name who is the direct ancestor of a child table

          context "when try to set the parent table name represented as a string to be interpolated at run time" do

            it "returns parent_table_name" do
              dsl.parent_table_name('#{model.table_name}')
              expect(dsl.data.parent_table_name).to eq('#{model.table_name}')
            end

          end # when try to set the parent table name represented as a string to be interpolated at run time

          context "when try to set the table name(with proc) who is the direct ancestor of a child table" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}"
              }
            end

            it "returns proc" do
              dsl.parent_table_name lmd
              expect(dsl.data.parent_table_name).to eq(lmd)
            end

          end # when try to set the table name(with proc) who is the direct ancestor of a child table

        end # parent_table_name

        describe "parent_table_schema_name" do

          context "when try to set the schema name of the table who is the direct ancestor of a child table" do

            it "returns parent_table_schema_name" do
              dsl.parent_table_schema_name("public")
              expect(dsl.data.parent_table_schema_name).to eq("public")
            end

          end # when try to set the schema name of the table who is the direct ancestor of a child table

          context "when try to set the schema name represented as a string to be interpolated at run time" do

            it "returns parent_table_schema_name" do
              dsl.parent_table_schema_name('#{model.table_name}')
              expect(dsl.data.parent_table_schema_name).to eq('#{model.table_name}')
            end

          end # when try to set the schema name represented as a string to be interpolated at run time

          context "when try to set the schema name(with proc) of the table who is the direct ancestor of a child table" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}"
              }
            end

            it "returns proc" do
              dsl.parent_table_schema_name lmd
              expect(dsl.data.parent_table_schema_name).to eq(lmd)
            end

          end # when try to set the schema name(with proc) of the table who is the direct ancestor of a child table

        end # parent_table_schema_name

      end # Dsl
    end # Configurator
  end # PartitionedBase
end # Partitioned
