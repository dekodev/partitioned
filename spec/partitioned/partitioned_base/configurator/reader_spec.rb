require 'spec_helper'

module Partitioned
  class PartitionedBase
    module Configurator
      describe Reader do

        before(:all) do
          class Employee < ById
            def self.partition_field
              :id
            end
            def self.foreign_key_field
              :company_id
            end
          end
        end

        after(:all) do
          Partitioned::PartitionedBase::Configurator.send(:remove_const, :Employee)
        end

        let!(:dsl) { Partitioned::PartitionedBase::Configurator::Dsl.new(Employee) }
        let!(:default_reader) { Partitioned::PartitionedBase::Configurator::Reader.new(Employee) }
        let!(:reader) do
          reader = Partitioned::PartitionedBase::Configurator::Reader.new(Employee)
          allow(reader).to receive(:configurators).and_return([dsl])
          reader
        end

        describe "configurators" do

          context "checking arrays length" do

            it "returns 3" do
              expect(default_reader.send(:configurators).length).to eq(3)
            end

          end # checking array length

          context "checking models class for each of configurators" do

            it "returns 'Partitioned::ById'" do
              expect(default_reader.send(:configurators)[0].model.to_s).to eq("Partitioned::ById")
            end

            it "returns 'Partitioned::ByIntegerField'" do
              expect(default_reader.send(:configurators)[1].model.to_s).to eq("Partitioned::ByIntegerField")
            end

            it "returns 'Partitioned::PartitionedBase'" do
              expect(default_reader.send(:configurators)[2].model.to_s).to eq("Partitioned::PartitionedBase")
            end

          end # checking models class for each of configurators

        end # configurators

        describe "schema_name" do

          context "when schema_name value is set by default" do

            it "returns 'employees_partitions'" do
              expect(default_reader.schema_name).to eq("employees_partitions")
            end

          end # when schema_name value is set by default

          context "when schema_name value is set by value" do

            it "returns 'employees_partitions'" do
              dsl.schema_name("employees_partitions")
              expect(reader.schema_name).to eq("employees_partitions")
            end

          end # when schema_name value is set by value

          context "when schema_name value is set by string" do

            it "returns 'employees_partitions'" do
              dsl.schema_name('#{model.table_name}_partitions')
              expect(reader.schema_name).to eq("employees_partitions")
            end

          end # when schema_name value is set by string

          context "when schema_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *value|
                return "#{model.table_name}_partitions"
              }
            end

            it "returns 'employees_partitions'" do
              dsl.schema_name lmd
              expect(reader.schema_name).to eq("employees_partitions")
            end

          end # when schema_name value is set by proc

        end # schema_name

        describe "on_fields" do

          context "when on_field value is set by default" do

            it "returns [:id]" do
              expect(default_reader.on_fields).to eq([:id])
            end

          end # when on_filed value is set by default

          context "when on_field value is set by symbol" do

            it "returns [:company_id]" do
              dsl.on :company_id
              expect(reader.on_fields).to eq([:company_id])
            end

          end # "when on_field value is set by symbol

          context "when on_field value is set by string" do

            it "returns [:id]" do
              dsl.on '#{model.partition_field}'
              expect(reader.on_fields).to eq([:id])
            end

          end # "when on_field value is set by string

          context "when on_field value is set by proc" do

            let(:lmd) do
              lambda { |model| model.partition_field }
            end

            it "returns [:id]" do
              dsl.on lmd
              expect(reader.on_fields).to eq([:id])
            end

          end # "when on_field value is set by proc

        end # on_fields

        describe "indexes" do

          context "when indexes value is set by default" do

            it "returns { :id => { :unique => true } }" do
              expect(default_reader.indexes).to eq({ :id => { :unique => true } })
            end

          end # when indexes value is set by default

          context "when indexes value is set by values" do

            it "returns { :id => { :unique => false } }" do
              dsl.index(:id, { :unique => false })
              expect(reader.indexes).to eq({ :id => { :unique => false } })
            end

          end # when indexes value is set by values

          context "when indexes value is set by proc" do

            let(:lmd) do
              lambda { |model, *partition_key_values|
                return Partitioned::PartitionedBase::Configurator::Data::Index.new(model.partition_field, {})
              }
            end

            it "returns { :id => {} }" do
              dsl.index lmd
              expect(reader.indexes).to eq({ :id => {} })
            end

          end # when indexes value is set by proc

        end # indexes

        describe "foreign_keys" do

          context "when foreign_keys value is set by symbol" do

            it "returns foreign_keys" do
              dsl.foreign_key(:company_id)
              expect(reader.foreign_keys.first.referenced_field).to eq(:id)
              expect(reader.foreign_keys.first.referenced_table).to eq("companies")
              expect(reader.foreign_keys.first.referencing_field).to eq(:company_id)
            end

          end # when foreign_keys value is set by symbol

          context "when foreign_keys value is set by proc" do

            let(:lmd) do
              lambda { |model, *partition_key_values|
                return Partitioned::PartitionedBase::Configurator::Data::ForeignKey.new(model.foreign_key_field)
              }
            end

            it "returns foreign_keys" do
              dsl.foreign_key lmd
              expect(reader.foreign_keys.first.referenced_field).to eq(:id)
              expect(reader.foreign_keys.first.referenced_table).to eq("companies")
              expect(reader.foreign_keys.first.referencing_field).to eq(:company_id)
            end

          end # when foreign_keys value is set by proc

        end # foreign_keys

        describe "check_constraint" do

          context "when check_constraint value is set by string" do

            it "returns 'company_id = 1'" do
              dsl.check_constraint('company_id = #{field_value}')
              expect(reader.check_constraint(1)).to eq("company_id = 1")
            end

          end # when check_constraint value is set by string

          context "when check_constraint value is set by proc" do

            let(:lmd) do
              lambda {|model, value|
                return "#{model.partition_field} = #{value}"
              }
            end

            it "returns 'id = 1'" do
              dsl.check_constraint lmd
              expect(reader.check_constraint(1)).to eq("id = 1")
            end

          end # when check_constraint value is set by proc

        end # check_constraint

        describe "parent_table_name" do

          context "when parent_table_name value is set by default" do

            it "returns employees" do
              expect(default_reader.parent_table_name).to eq("employees")
            end

          end # when parent_table_name value is set by default

          context "when parent_table_name value is set by value" do

            it "returns employees" do
              dsl.parent_table_name("employees")
              expect(reader.parent_table_name).to eq("employees")
            end

          end # when parent_table_name value is set by value

          context "when parent_table_name value is set by string" do

            it "returns employees" do
              dsl.parent_table_name('#{model.table_name}')
              expect(reader.parent_table_name).to eq("employees")
            end

          end # when parent_table_name value is set by string

          context "when parent_table_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}"
              }
            end

            it "returns employees" do
              dsl.parent_table_name lmd
              expect(reader.parent_table_name).to eq("employees")
            end

          end # when parent_table_name value is set by proc

        end # parent_table_name

        describe "parent_table_schema_name" do

          context "when parent_table_schema_name value is set by default" do

            it "returns public" do
              expect(default_reader.parent_table_schema_name).to eq("public")
            end

          end # when parent_table_schema_name value is set by default

          context "when parent_table_schema_name value is set by value" do

            it "returns employees" do
              dsl.parent_table_schema_name("employees")
              expect(reader.parent_table_schema_name).to eq("employees")
            end

          end # when parent_table_schema_name value is set by value

          context "when parent_table_schema_name value is set by string" do

            it "returns employees" do
              dsl.parent_table_schema_name('#{model.table_name}')
              expect(reader.parent_table_schema_name).to eq("employees")
            end

          end # when parent_table_schema_name value is set by string

          context "when parent_table_schema_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}"
              }
            end

            it "returns employees" do
              dsl.parent_table_schema_name lmd
              expect(reader.parent_table_schema_name).to eq("employees")
            end

          end # when parent_table_schema_name value is set by proc

        end # parent_table_schema_name

        describe "table_name" do

          context "when table_name value is set by default" do

            it "returns employees_partitions.p10000000" do
              expect(default_reader.table_name(10000000)).to eq("employees_partitions.p10000000")
            end

          end # when table_name value is set by default

          context "when table_name value is set by value" do

            it "returns employees_partitions.p42" do
              dsl.table_name("employees_partitions.p42")
              expect(reader.table_name(57)).to eq("employees_partitions.p42")
            end

          end # when table_name value is set by value

          context "when table_name value is set by string" do

            it "returns employees_partitions.employees_child_10000000" do
              dsl.table_name('#{model.table_name}_partitions.#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
              expect(reader.table_name(10000000)).to eq("employees_partitions.employees_child_10000000")
            end

          end # when table_name value is set by string

          context "when table_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}_partitions.#{model.table_name}_child_#{model.partition_normalize_key_value(partition_key_values.first)}"
              }
            end

            it "returns employees_partitions.employees_child_10000000" do
              dsl.table_name lmd
              expect(reader.table_name(10000000)).to eq("employees_partitions.employees_child_10000000")
            end

          end # when table_name value is set by proc

        end # table_name

        describe "base_name" do

          context "when base_name value is set by value" do

            it "returns 42" do
              dsl.base_name("42")
              expect(reader.base_name).to eq("42")
            end

          end # when base_name value is set by value

          context "when base_name value is set by string" do

            it "returns 10000000" do
              dsl.base_name('#{model.partition_normalize_key_value(field_value)}')
              expect(reader.base_name(10000000)).to eq("10000000")
            end

          end # when base_name value is set by string

          context "when base_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return model.partition_normalize_key_value(*partition_key_values).to_s
              }
            end

            it "returns 10000000" do
              dsl.base_name lmd
              expect(reader.base_name(10000000)).to eq("10000000")
            end

          end # when base_name value is set by proc

        end # base_name

        describe "name_prefix" do

          context "when name_prefix value is set by default" do

            it "returns 'p'" do
              expect(default_reader.name_prefix).to eq("p")
            end

          end # when name_prefix value is set by default

          context "when name_prefix value is set by value" do

            it "returns 'p'" do
              dsl.name_prefix("p")
              expect(reader.name_prefix).to eq("p")
            end

          end # when name_prefix value is set by value

          context "when name_prefix value is set by string" do

            it "returns 'employees_child_'" do
              dsl.name_prefix('#{model.table_name}_child_')
              expect(reader.name_prefix).to eq("employees_child_")
            end

          end # when name_prefix value is set by string

          context "when name_prefix value is set by proc" do

            let(:lmd) do
              lambda {|model, *value|
                return "#{model.table_name}_child_"
              }
            end

            it "returns 'employees_child_'" do
              dsl.name_prefix lmd
              expect(reader.name_prefix).to eq("employees_child_")
            end

          end # when name_prefix value is set by proc

        end # name_prefix

        describe "part_name" do

          context "when part_name value is set by value" do

            it "returns 'p42'" do
              dsl.part_name("p42")
              expect(reader.part_name).to eq("p42")
            end

          end # when part_name value is set by value

          context "when part_name value is set by string" do

            it "returns 'employees_child_10000000'" do
              dsl.part_name('#{model.table_name}_child_#{model.partition_normalize_key_value(field_value)}')
              expect(reader.part_name(10000000)).to eq("employees_child_10000000")
            end

          end # when part_name value is set by string

          context "when part_name value is set by proc" do

            let(:lmd) do
              lambda {|model, *partition_key_values|
                return "#{model.table_name}_child_#{model.partition_normalize_key_value(partition_key_values.first)}"
              }
            end

            it "returns 'employees_child_10000000'" do
              dsl.part_name lmd
              expect(reader.part_name(10000000)).to eq("employees_child_10000000")
            end

          end # when part_name value is set by proc

        end # part_name

        describe "last_partitions_order_by_clause" do

          context "when order value is set by value" do

            it "returns 'tablename desc'" do
              dsl.order('tablename desc')
              expect(reader.last_partitions_order_by_clause).to eq("tablename desc")
            end

          end # when order value is set by value

        end # last_partitions_order_by_clause

      end # Reader
    end # Configurator
  end # PartitionedBase
end # Partitioned
