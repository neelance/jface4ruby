require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Chris Gross (schtoo@schtoo.com) - initial API and implementation for bug 16179
# IBM Corporation - revisions to initial contribution
module Org::Eclipse::Jface::Dialogs
  module PageChangingEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Util, :EventObject
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Event object describing an <code>IDialogPage</code> in the midst of changing.
  # 
  # @see IPageChangingListener
  # @since 3.3
  class PageChangingEvent < PageChangingEventImports.const_get :EventObject
    include_class_members PageChangingEventImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :current_page
    alias_method :attr_current_page, :current_page
    undef_method :current_page
    alias_method :attr_current_page=, :current_page=
    undef_method :current_page=
    
    attr_accessor :target_page
    alias_method :attr_target_page, :target_page
    undef_method :target_page
    alias_method :attr_target_page=, :target_page=
    undef_method :target_page=
    
    # Public field that dictates if the page change will successfully change.
    # 
    # Set this field to <code>false</code> to prevent the page from changing.
    # 
    # Default value is <code>true</code>.
    attr_accessor :doit
    alias_method :attr_doit, :doit
    undef_method :doit
    alias_method :attr_doit=, :doit=
    undef_method :doit=
    
    typesig { [Object, Object, Object] }
    # Creates a new event for the given source, selected (current) page and
    # direction.
    # 
    # @param source
    # the page changing provider (the source of this event)
    # @param currentPage
    # the current page. In the JFace provided dialogs this will be
    # an <code>IDialogPage</code>.
    # @param targetPage
    # the target page. In the JFace provided dialogs this will be an
    # <code>IDialogPage</code>.
    def initialize(source, current_page, target_page)
      @current_page = nil
      @target_page = nil
      @doit = false
      super(source)
      @doit = true
      Assert.is_not_null(current_page)
      Assert.is_not_null(target_page)
      @current_page = current_page
      @target_page = target_page
    end
    
    typesig { [] }
    # Returns the current page from which the page change originates.
    # 
    # @return the current page. In dialogs implemented by JFace,
    # this will be an <code>IDialogPage</code>.
    def get_current_page
      return @current_page
    end
    
    typesig { [] }
    # Returns the target page to change to.
    # 
    # @return the target page. In dialogs implemented by JFace,
    # this will be an <code>IDialogPage</code>.
    def get_target_page
      return @target_page
    end
    
    private
    alias_method :initialize__page_changing_event, :initialize
  end
  
end
