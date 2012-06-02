module Microscope
  class ClassBrowser
    attr_reader :frame
    
    def initialize(scope)
      @scope = scope
      @parent = scope.root

      initialize_frame
      initialize_classes_listbox
      initialize_scroller

      refresh
      bind_events
    end

    def initialize_frame
      @frame = Tk::Tile::Frame.new(@parent)
      @frame.borderwidth(2)
      @frame.padding("2 2 2 2")
      @frame.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_classes_listbox
      @cls_browser = Tk::Tile::Treeview.new(@frame)
      @cls_browser.height(TOP_BROWSER_HEIGHT)
      @cls_browser.selectmode('browse')
      @cls_browser.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_scroller
      @scroller = TkScrollbar.new(@frame)
      @scroller.orient('vertical')
      @scroller.grid(:column => 1, :row => 0, :sticky => 'nwes')
    end

    def bind_events
      @cls_browser.yscrollcommand do |*args|
        @scroller.set(*args)
      end
      @scroller.command do |*args|
        @cls_browser.yview(*args)
      end
      @cls_browser.bind('<TreeviewSelect>', method(:on_select))
    end

    def on_select
      @scope.select_class(@class_resolver[@cls_browser.focus_item.path])
    end

    def refresh
      @classes = []
      ObjectSpace.each_object(Class) do |_class|
        @classes << _class
      end
      @class_resolver = {}
      @classes.sort_by(&:inspect).each do |_class|
        @class_resolver[class_name = _class.inspect] = _class
        @cls_browser.insert('', 'end', :id => class_name, :text => class_name) unless @cls_browser.exist?(class_name)
      end
    end
  end
end
