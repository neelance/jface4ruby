require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ViewerSorterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Text, :Collator
    }
  end
  
  # can't use ICU - Collator used in public API
  # 
  # A viewer sorter is used by a {@link StructuredViewer} to reorder the elements
  # provided by its content provider.
  # <p>
  # The default <code>compare</code> method compares elements using two steps.
  # The first step uses the values returned from <code>category</code>.
  # By default, all elements are in the same category.
  # The second level is based on a case insensitive compare of the strings obtained
  # from the content viewer's label provider via <code>ILabelProvider.getText</code>.
  # </p>
  # <p>
  # Subclasses may implement the <code>isSorterProperty</code> method;
  # they may reimplement the <code>category</code> method to provide
  # categorization; and they may override the <code>compare</code> methods
  # to provide a totally different way of sorting elements.
  # </p>
  # <p>
  # It is recommended to use <code>ViewerComparator</code> instead.
  # </p>
  # @see IStructuredContentProvider
  # @see StructuredViewer
  class ViewerSorter < ViewerSorterImports.const_get :ViewerComparator
    include_class_members ViewerSorterImports
    
    # The collator used to sort strings.
    # 
    # @deprecated as of 3.3 Use {@link ViewerComparator#getComparator()}
    attr_accessor :collator
    alias_method :attr_collator, :collator
    undef_method :collator
    alias_method :attr_collator=, :collator=
    undef_method :collator=
    
    typesig { [] }
    # Creates a new viewer sorter, which uses the default collator
    # to sort strings.
    def initialize
      initialize__viewer_sorter(Collator.get_instance)
    end
    
    typesig { [Collator] }
    # Creates a new viewer sorter, which uses the given collator
    # to sort strings.
    # 
    # @param collator the collator to use to sort strings
    def initialize(collator)
      @collator = nil
      super(collator)
      @collator = collator
    end
    
    typesig { [] }
    # Returns the collator used to sort strings.
    # 
    # @return the collator used to sort strings
    # @deprecated as of 3.3 Use {@link ViewerComparator#getComparator()}
    def get_collator
      return @collator
    end
    
    private
    alias_method :initialize__viewer_sorter, :initialize
  end
  
end
