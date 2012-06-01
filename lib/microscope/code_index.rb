require 'singleton'

module Microscope
  class CodeIndex
    include Singleton

    def refresh
      reindex_classes
    end

    def classes
      @classes.keys.sort_by(&:inspect)
    end

    def resolve_class(class_name)
      @classes[class_name]
    end

    def implementors(selector)
      @method_implementors[selector]
    end

    private
    def reindex_classes
      @classes = {}
      @method_implementors = {}
      ObjectSpace.each_object(Class) do |c|
        @classes[c.name] = c
      end
      ObjectSpace.each_object(Module) do |m|
        m.instance_methods(false).each do |im|
          @method_implementors[im] ||= []
          @method_implementors[im] << m
        end
      end
    end

    def initialize
      refresh
    end
  end
end
