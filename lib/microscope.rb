require 'tk'
require 'tkextlib/tile'
require "microscope/version"

module Microscope
  autoload :Scope                , 'microscope/scope'
  autoload :ClassBrowser         , 'microscope/class_browser'
  autoload :DispatchChainBrowser , 'microscope/dispatch_chain_browser'
  autoload :MethodBrowser        , 'microscope/method_browser'
  autoload :CodeViewer           , 'microscope/code_viewer'
  autoload :Images               , 'microscope/images'
  autoload :CodeIndex            , 'microscope/code_index'
  
  def self.run
    Scope.new.run
  end
end
