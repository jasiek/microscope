module Microscope
  class DispatchChainBrowser
    attr_reader :frame

    def initialize(scope)
      @current_module = Object
      @scope = scope
      @parent = scope.root

      initialize_frame
      initialize_dispatch_chain_listbox
      initialize_scroller

      refresh
      bind_events
    end

    def initialize_frame
      @frame = Tk::Tile::Frame.new(@parent)
      @frame.borderwidth(2)
      @frame.padding('2 2 2 2')
      @frame.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_dispatch_chain_listbox
      @dc_browser = Tk::Tile::Treeview.new(@frame)
      @dc_browser.height(TOP_BROWSER_HEIGHT)
      @dc_browser.selectmode('browse')
      @dc_browser.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_scroller
      @scroller = TkScrollbar.new(@frame)
      @scroller.orient('vertical')
      @scroller.grid(:column => 1, :row => 0, :sticky => 'nwes')
    end

    # Changes the module being inspected
    def change_module(_module)
      @current_module = _module
      refresh
    end

    def bind_events
      @dc_browser.yscrollcommand do |*args|
        @scroller.set(*args)
      end
      @scroller.command do |*args|
        @dc_browser.yview(*args)
      end
      @dc_browser.bind('<TreeviewSelect>', method(:on_select))
    end

    def on_select
      @scope.select_particular_module(@ancestors[@dc_browser.focus_item.path])
    end

    def refresh
      clear
      @ancestors = {}
      @current_module.ancestors.each do |ancestor|
        @ancestors[ancestor_name = ancestor.name] = ancestor
        @dc_browser.insert('', 0, :id => ancestor_name, :text => ancestor_name)
        @dc_browser.itemconfigure(ancestor_name, 'image', (ancestor.class == Module) ? Images::MODULE : Images::CLASS)
      end
      @dc_browser.itemconfigure('', 'open', true)
    end

    def clear
      @dc_browser.children('').each do |child_id|
        @dc_browser.delete(child_id)
      end
    end
  end
end
