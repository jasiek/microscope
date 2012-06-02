module Microscope
  class CodeViewer
    attr_reader :frame

    def initialize(scope)
      @scope = scope
      @parent = scope.root

      initialize_notebook
      initialize_source_frame
      initialize_disassembly_frame
      
      refresh
    end

    def initialize_notebook
      @frame = Tk::Tile::Notebook.new(@parent)
      @frame.padding('2 2 2 2')
      @frame.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_source_frame
      @source_frame = Tk::Tile::Frame.new(@frame)
      @source_text = Tk::Text.new(@source_frame)
      @source_text.pack(:side => 'left')
      @source_text.state('disabled')
      @frame.add(@source_frame, {:text => 'source'})
    end

    def initialize_disassembly_frame
      @disassembly_frame = Tk::Tile::Frame.new(@frame)
      @disassembly_text = TkText.new(@disassembly_frame)
      @disassembly_text.pack(:side => 'left')
      @disassembly_text.state('disabled')
      @frame.add(@disassembly_frame, {:text => 'bytecode'})
    end
    
    def select_class_and_method(_class, selector)
      @current_class = _class
      @current_selector = selector
      refresh
    end

    def refresh
      return unless @current_class && @current_selector

      @source_text.state('normal')
      @disassembly_text.state('normal')

      @source_text.delete('0.0', 'end')
      @source_text.insert('end', current_method_source)

      @disassembly_text.delete('0.0', 'end')
      @disassembly_text.insert('end', current_method_disassembly)
    rescue 
      # Do nothing, the code box will be empty.
    ensure
      @source_text.state('disabled')
      @disassembly_text.state('disabled')
    end

    def current_method_source
      @current_class.instance_method(@current_selector).source      
    end

    def current_method_disassembly
      RubyVM::InstructionSequence.new(current_method_source).disassemble
    end
  end
end
