# encoding: utf-8
module Dynamoid #:nodoc:

  # This is the base module for all domain objects that need to be persisted to
  # the database as documents.
  module Document
    extend ActiveSupport::Concern
    include Dynamoid::Components
    
    included do
      Dynamoid::Config.included_models << self
    end
    
    module ClassMethods
      def create(attrs = {})
        obj = self.new(attrs)
        obj.run_callbacks(:create) do
          obj.save
        end
        obj
      end

      def create!(attrs = {})
        obj = self.new(attrs)
        obj.run_callbacks(:create) do
          obj.save!
        end
        obj
      end
      
      def build(attrs = {})
        self.new(attrs)
      end

      def exists?(id)
        !! find(id)
      end
    end
    
    def initialize(attrs = {})
      @new_record = true
      @attributes ||= {}
      attrs = self.class.undump(attrs)
      self.class.attributes.keys.each {|att| write_attribute(att, attrs[att])}
    end
    
    def ==(other)
      return false if other.nil?
      other.respond_to?(:id) && other.id == self.id
    end
    
    def reload
      self.attributes = self.class.find(self.id).attributes
      self
    end
  end
  
end
