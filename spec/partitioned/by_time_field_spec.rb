require 'spec_helper'
require "#{File.dirname(__FILE__)}/../support/tables_spec_helper"
require "#{File.dirname(__FILE__)}/../support/shared_example_spec_helper_for_time_key"

module Partitioned

  describe ByTimeField do

    include TablesSpecHelper

    module TimeField
      class Employee < Partitioned::ByTimeField
        belongs_to :company, :class_name => 'Company'

        def self.partition_time_field
          return :created_at
        end

        partitioned do |partition|
          partition.index :id, :unique => true
          partition.foreign_key :company_id
        end
      end # Employee
    end # TimeField

    before(:all) do
      @employee = TimeField::Employee
      create_tables
      dates = @employee.partition_generate_range(DATE_NOW,
                                                 DATE_NOW + 1.day)
      @employee.create_new_partition_tables(dates)
      ActiveRecord::Base.connection.execute <<-SQL
        insert into employees_partitions.
          p#{DATE_NOW.strftime('%Y%m%d')}
          (company_id,name) values (1,'Keith');
      SQL
    end

    after(:all) do
      drop_tables
    end

    let(:class_by_time_field) { ::Partitioned::ByTimeField }

    describe "model is abstract class" do

      it "returns true" do
        expect(class_by_time_field.abstract_class).to be_truthy
      end

    end # model is abstract class

    describe "#partition_generate_range" do

      it "returns dates array" do
        expect(class_by_time_field.
            partition_generate_range(Date.parse('2011-01-05'), Date.parse('2011-01-07'))).
            to eq([Date.parse('2011-01-05'), Date.parse('2011-01-06'), Date.parse('2011-01-07')])
      end

    end # #partition_generate_range

    describe "#partition_normalize_key_value" do

      it "returns date" do
        expect(class_by_time_field.
            partition_normalize_key_value(Date.parse('2011-01-05'))).
            to eq(Date.parse('2011-01-05'))
      end

    end # #partition_normalize_key_value

    describe "#partition_table_size" do

      it "returns 1.day" do
        expect(class_by_time_field.partition_table_size).to eq(1.day)
      end

    end # #partition_table_size

    describe "#partition_time_field" do

      it "raises MethodNotImplemented" do
        expect {
          class_by_time_field.partition_time_field
        }.to raise_error(MethodNotImplemented)
      end

    end # #partition_time_field

    describe "partitioned block" do

      let(:data) do
        class_by_time_field.configurator_dsl.data
      end

      context "checks data in the on_field is Proc" do

        it "returns Proc" do
          expect(data.on_field).to be_is_a Proc
        end

      end # checks data in the on_field is Proc

      context "checks data in the indexes is Proc" do

        it "returns Proc" do
          expect(data.indexes.first).to be_is_a Proc
        end

      end # checks data in the indexes is Proc

      context "checks data in the base_name is Proc" do

        it "returns Proc" do
          expect(data.base_name).to be_is_a Proc
        end

      end # checks data in the base_name is Proc

      context "checks data in the check_constraint is Proc" do

        it "returns Proc" do
          expect(data.check_constraint).to be_is_a Proc
        end

      end # checks data in the check_constraint is Proc

      context "checks data in the on_field" do

        it "returns on_field" do
          expect(data.on_field.call(@employee)).to eq(:created_at)
        end

      end # checks data in the on_field

      context "checks data in the indexes" do

        it "returns :created_at" do
          expect(data.indexes.first.call(@employee, nil).field).to eq(:created_at)
        end

        it "returns empty options hash" do
          expect(data.indexes.first.call(@employee, nil).options).to eq({})
        end

      end # checks data in the indexes

      context "checks data in the last_partitions_order_by_clause" do

        it "returns last_partitions_order_by_clause" do
          expect(data.last_partitions_order_by_clause).to eq("tablename desc")
        end

      end # checks data in the last_partitions_order_by_clause

      context "checks data in the base_name" do

        it "returns base_name" do
          expect(data.base_name.call(@employee, Date.parse('2011-01-05'))).to eq("20110105")
        end

      end # checks data in the base_name

      context "checks data in the check_constraint" do

        it "returns check_constraint" do
          expect(data.check_constraint.
              call(@employee, Date.parse('2011-01-05'))).
              to eq("created_at >= '2011-01-05' AND created_at < '2011-01-06'")
        end

      end # checks data in the check_constraint

    end # partitioned block

    it_should_behave_like "check that basic operations with postgres works correctly for time key", TimeField::Employee

  end # ByTimeField

end # Partitioned
