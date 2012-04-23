class ToolController < ApplicationController
  layout 'slim'
  def initialize
    @page_title = String.new
    @breadcrumb = Breadcrumb.new
    @menu_section = 'none'
  end

  def spotd
    @page_title = "Spotd: a way to keep track of the site as it happens"
  end
end