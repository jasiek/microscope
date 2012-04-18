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

    private
    def reindex_classes
      @classes = {}
      ObjectSpace.each_object(Class) do |c|
        @classes[c.name] = c
      end
    end

    def initialize
      refresh
    end
  end
end
