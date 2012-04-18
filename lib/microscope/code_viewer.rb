module Microscope
  class CodeViewer
    attr_reader :frame

    def initialize(scope)
      @scope = scope
      @parent = scope.root

      initialize_notebook
      
      refresh
    end

    def initialize_notebook
      @frame = Tk::Tile::Notebook.new(@parent)
      @frame.padding('2 2 2 2')
      @frame.grid(:column => 0, :row => 0, :sticky => 'nwes')

      @source_frame = Tk::Tile::Frame.new(@frame)
      @disassembly_frame = Tk::Tile::Frame.new(@frame)
      @frame.add(@source_frame, {:text => 'source'})
      @frame.add(@disassembly_frame, {:text => 'bytecode'})
    end

    def select_class_and_method(bound_method)
      @current_method = bound_method
      refresh
    end

    def refresh
    end
  end
end
