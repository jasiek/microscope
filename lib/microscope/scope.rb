module Microscope
  class Scope
    attr_reader :root

    def initialize
      initialize_root
      initialize_split_pane1
      initialize_split_pane2

      initialize_class_browser
      initialize_dispatch_chain_browser
      initialize_method_browser
      initialize_code_viewer
    end

    def initialize_root
      @root = TkRoot.new('title' => 'Microscope')
    end

    def initialize_split_pane1
      @split_pane1 = TkPanedWindow.new(@root)
      @split_pane1.orient('vertical')
      @split_pane1.pack
    end

    def initialize_split_pane2
      @split_pane2 = TkPanedWindow.new(@root) do
        orient('horizontal')
      end
      @split_pane2.pack
      @split_pane1.add(@split_pane2, {})
    end

    def initialize_class_browser
      @class_browser = ClassBrowser.new(self)
      @split_pane2.add(@class_browser.frame, {})
    end

    def initialize_dispatch_chain_browser
      @dc_browser = DispatchChainBrowser.new(self)
      @split_pane2.add(@dc_browser.frame, {})
    end

    def initialize_method_browser
      @method_browser = MethodBrowser.new(self)
      @split_pane2.add(@method_browser.frame, {})
    end

    def initialize_code_viewer
      @code_viewer = CodeViewer.new(self)
      @split_pane1.add(@code_viewer.frame, {})
    end

    def select_class(_class)
      @dc_browser.change_module(@_class = _class)
    end

    def select_particular_module(_ancestor)
      @method_browser.select_particular_ancestor(@_class, _ancestor)
    end

    def select_instance_method(selector)
      @code_viewer.select_class_and_method(@_class, selector)
    end

    def run
      Tk.mainloop
    end
  end
end
