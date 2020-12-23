require 'spec_helper'
require "#{File.dirname(__FILE__)}/../support/tables_spec_helper"
require "#{File.dirname(__FILE__)}/../support/shared_example_spec_helper_for_integer_key"

module Partitioned

  describe ById do

    include TablesSpecHelper

    module Id
      class Employee < ById
        belongs_to :company, :class_name => 'Company'

        def self.partition_table_size
          return 1
        end

        partitioned do |partition|
          partition.foreign_key :company_id
        end
      end # Employee
    end # Id

    before(:all) do
      @employee = Id::Employee
      create_tables
      @employee.create_new_partition_tables(Range.new(1, 10).step(@employee.partition_table_size))
      ActiveRecord::Base.connection.execute <<-SQL
        insert into employees_partitions.p1 (company_id,name) values (1,'Keith');
      SQL
    end

    after(:all) do
      drop_tables
    end

    let(:class_by_id) { ::Partitioned::ById }

    describe "model is abstract class" do

      it "returns true" do
        expect(class_by_id.abstract_class).to be_truthy
      end

    end # model is abstract class

    describe "#prefetch_primary_key?" do

      context "is :id set as a primary_key" do

        it "returns true" do
          expect(class_by_id.prefetch_primary_key?).to be_truthy
        end

      end # is :id set as a primary_key

    end # #prefetch_primary_key?

    describe "#partition_table_size" do

      it "returns 10000000" do
        expect(class_by_id.partition_table_size).to eq(10000000)
      end

    end # #partition_table_size

    describe "#partition_integer_field" do

      it "returns :id" do
        expect(class_by_id.partition_integer_field).to eq(:id)
      end

    end # #partition_integer_field

    describe "partitioned block" do

      context "checks if there is data in the indexes field" do

        it "returns :id" do
          expect(class_by_id.configurator_dsl.data.indexes.first.field).to eq(:id)
        end

        it "returns { :unique => true }" do
          expect(class_by_id.configurator_dsl.data.indexes.first.options).to eq({ :unique => true })
        end

      end # checks if there is data in the indexes field

    end # partitioned block

    it_should_behave_like "check that basic operations with postgres works correctly for integer key", Id::Employee

    it "runs updates correctly" do
      test_company = ::TablesSpecHelper::Company.new
      test_company.save!

      test_employee = @employee.new
      test_employee.name = "foo"
      test_employee.company_id = test_company.id
      test_employee.save!

      test_employee2 = @employee.where(:name => "foo").first
      test_employee2.salary = 1
      test_employee2.save!
    end

  end # ById

end # Partitioned
