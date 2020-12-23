require 'spec_helper'
require "#{File.dirname(__FILE__)}/../support/tables_spec_helper"
require "#{File.dirname(__FILE__)}/../support/shared_example_spec_helper_for_integer_key"

module Partitioned

  describe ByForeignKey do

    include TablesSpecHelper

    module ForeignKey
      class Employee < ByForeignKey
        belongs_to :company, :class_name => 'Company'

        def self.partition_foreign_key
          return :company_id
        end

        partitioned do |partition|
          partition.foreign_key :company_id
        end
      end # Employee
    end # ForeignKey

    before(:all) do
      @employee =  ForeignKey::Employee
      create_tables
      @employee.create_new_partition_tables(Range.new(1, 3).step(@employee.partition_table_size))
      ActiveRecord::Base.connection.execute <<-SQL
        insert into employees_partitions.p1 (company_id,name) values (1,'Keith');
      SQL
    end

    after(:all) do
      drop_tables
    end

    let(:class_by_foreign_key) { ::Partitioned::ByForeignKey }

    describe "model is abstract class" do

      it "returns true" do
        expect(class_by_foreign_key.abstract_class).to be_truthy
      end

    end # model is abstract class

    describe "#partition_foreign_key" do

      it "raises MethodNotImplemented" do
        expect {
          class_by_foreign_key.partition_foreign_key
        }.to raise_error(MethodNotImplemented)
      end

    end # #partition_foreign_key

    describe "partitioned block" do

      context "checks data in the foreign_keys is Proc" do

        it "returns Proc" do
          expect(class_by_foreign_key.configurator_dsl.data.foreign_keys.first).to be_is_a Proc
        end

      end # checks data in the foreign_keys is Proc

      context "checks if there is data in the foreign_keys" do

        let(:proc) do
          class_by_foreign_key.configurator_dsl.data.foreign_keys.first.call(@employee, :id)
        end

        it "returns referencing_field" do
          expect(proc.referencing_field).to eq(:company_id)
        end

        it "returns referenced_field" do
          expect(proc.referenced_field).to eq(:id)
        end

        it "returns referencing_field" do
          expect(proc.referenced_table).to eq("companies")
        end

      end # checks if there is data in the foreign_keys

    end # partitioned block

    it_should_behave_like "check that basic operations with postgres works correctly for integer key", ForeignKey::Employee

  end # ByForeignKey

end # Partitioned
