require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module PageChangedEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Util, :EventObject
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Event object describing a page selection change. The source of these events
  # is a page change provider.
  # 
  # @see IPageChangeProvider
  # @see IPageChangedListener
  # 
  # @since 3.1
  class PageChangedEvent < PageChangedEventImports.const_get :EventObject
    include_class_members PageChangedEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # 
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3835149545519723574 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The selected page.
    attr_accessor :selected_page
    alias_method :attr_selected_page, :selected_page
    undef_method :selected_page
    alias_method :attr_selected_page=, :selected_page=
    undef_method :selected_page=
    
    typesig { [IPageChangeProvider, Object] }
    # Creates a new event for the given source and selected page.
    # 
    # @param source
    # the page change provider
    # @param selectedPage
    # the selected page. In the JFace provided dialogs this
    # will be an <code>IDialogPage</code>.
    def initialize(source, selected_page)
      @selected_page = nil
      super(source)
      Assert.is_not_null(selected_page)
      @selected_page = selected_page
    end
    
    typesig { [] }
    # Returns the selected page.
    # 
    # @return the selected page. In dialogs implemented by JFace,
    # this will be an <code>IDialogPage</code>.
    def get_selected_page
      return @selected_page
    end
    
    typesig { [] }
    # Returns the page change provider that is the source of this event.
    # 
    # @return the originating page change provider
    def get_page_change_provider
      return get_source
    end
    
    private
    alias_method :initialize__page_changed_event, :initialize
  end
  
end
