module Microscope
  class MethodBrowser
    attr_reader :frame

    def initialize(scope)
      @selected_class = Object
      @selected_ancestor = Object
      @scope = scope
      @parent = scope.root
      @code_index = CodeIndex.instance

      initialize_frame
      initialize_class_method_listbox
      initialize_instance_method_listbox
      initialize_class_method_scroller
      initialize_instance_method_scroller

      refresh
      bind_events
    end

    def initialize_frame
      @frame = Tk::Tile::Notebook.new(@parent)
      @frame.padding("2 2 2 2")
      @frame.grid(:column => 0, :row => 0, :sticky => 'nwes')

      @class_frame = Tk::Tile::Frame.new(@frame)
      @instance_frame = Tk::Tile::Frame.new(@frame)
      @frame.add(@instance_frame, {:text => 'instance'})
      @frame.add(@class_frame, {:text => 'class'})
    end

    def initialize_class_method_listbox
      @cm_browser = Tk::Tile::Treeview.new(@class_frame)
      @cm_browser.height(20)
      @cm_browser.selectmode('browse')
      @cm_browser.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_instance_method_listbox
      @im_browser = Tk::Tile::Treeview.new(@instance_frame)
      @im_browser.height(20)
      @im_browser.selectmode('browse')
      @im_browser.grid(:column => 0, :row => 0, :sticky => 'nwes')
    end

    def initialize_class_method_scroller
      @cm_scroller = TkScrollbar.new(@class_frame)
      @cm_scroller.orient('vertical')
      @cm_scroller.grid(:column => 1, :row => 0, :sticky => 'nwes')
    end

    def initialize_instance_method_scroller
      @im_scroller = TkScrollbar.new(@instance_frame)
      @im_scroller.orient('vertical')
      @im_scroller.grid(:column => 1, :row => 0, :sticky => 'nwes')
    end

    def bind_events
      @cm_browser.yscrollcommand do |*args|
        @cm_scroller.set(*args)
      end
      @cm_scroller.command do |*args|
        @cm_browser.yview(*args)
      end
      @cm_browser.bind('<TreeviewSelect>', method(:on_cm_select))

      @im_browser.yscrollcommand do |*args|
        @im_scroller.set(*args)
      end
      @im_scroller.command do |*args|
        @im_browser.yview(*args)
      end
      @im_browser.bind('<TreeviewSelect>', method(:on_im_select))
    end

    def on_cm_select
    end

    def on_im_select
    end

    def select_particular_ancestor(_class, _ancestor)
      clear
      @selected_class = _class
      @selected_ancestor = _ancestor
      refresh
    end

    def refresh
      @selected_class.methods.sort.each do |method|
        @cm_browser.insert('', 'end', :id => method, :text => method)
      end
      @selected_ancestor.instance_methods.sort.each do |selector|
        @im_browser.insert('', 'end', :id => selector, :text => selector)
        @im_browser.itemconfigure(selector, 'image', image_for_selector(selector))
      end
    end

    def clear
      @cm_browser.children('').each do |child_id|
        @cm_browser.delete(child_id)
      end
      @im_browser.children('').each do |child_id|
        @im_browser.delete(child_id)
      end
    end

    def image_for_selector(selector)
      # Defined in this ancestor
      selected_ancestor_index = @selected_class.ancestors.index(@selected_ancestor)
      implementors_indices = @code_index.implementors(selector).map do |mod|
        @selected_class.ancestors.index(mod)
      end.reject do |idx|
        idx.nil?
      end
      overridden = overriding = false
      if implementors_indices.find { |i| i < selected_ancestor_index }
        overridden = true
      end
      if implementors_indices.find { |i| i > selected_ancestor_index }
        overriding = true
      end
      return Images::ARROW_UPDOWN if overridden && overriding
      return Images::ARROW_UP if overriding
      return Images::ARROW_DOWN if overridden
      return Images::EMPTY
    end
  end
end
