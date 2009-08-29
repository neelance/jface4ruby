require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module AbstractVirtualTableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Wrapper for a virtual-table-like widget. Contains all methods needed for lazy updates.
  # The JFace algorithms for deferred or lazy content providers should talk to this class
  # instead of directly to a TableViewer. This will allow them to be used with other virtual
  # viewers and widgets in the future.
  # 
  # <p>
  # For example, if SWT starts to support virtual Lists in the future, it should be possible
  # to create an adapter from <code>AbstractVirtualTable</code> to <code>ListViewer</code> in
  # order to reuse the existing algorithms for deferred updates.
  # </p>
  # 
  # <p>
  # This is package visiblity by design. It would only need to be made public if there was
  # a demand to use the deferred content provider algorithms like
  # <code>BackgroundContentProvider</code> with non-JFace viewers.
  # </p>
  # 
  # @since 3.1
  class AbstractVirtualTable 
    include_class_members AbstractVirtualTableImports
    
    typesig { [::Java::Int] }
    # Tells the receiver that the item at given row has changed. This may indicate
    # that a different element is now at this row, but does not necessarily indicate
    # that the element itself has changed. The receiver should request information for
    # this row the next time it becomes visibile.
    # 
    # @param index row to clear
    def clear(index)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Int] }
    # Notifies the receiver that the given element is now located at the given index.
    # 
    # @param element object located at the row
    # @param itemIndex row number
    def replace(element, item_index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets the item count for this table
    # 
    # @param total new total number of items
    def set_item_count(total)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the index of the top item visible in the table
    # 
    # @return the index of the top item visible in the table
    def get_top_index
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of items currently visible in the table. This is
    # the size of the currently visible window, not the total size of the table.
    # 
    # @return the number of items currently visible in the table
    def get_visible_item_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the total number of items in the table
    # 
    # @return the total number of items in the table
    def get_item_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the SWT control that this API is wrappering.
    # @return Control.
    def get_control
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__abstract_virtual_table, :initialize
  end
  
end
