require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module CategoryEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractNamedHandleEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>Category</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see ICategoryListener#categoryChanged(CategoryEvent)
  class CategoryEvent < CategoryEventImports.const_get :AbstractNamedHandleEvent
    include_class_members CategoryEventImports
    
    # The category that has changed; this value is never <code>null</code>.
    attr_accessor :category
    alias_method :attr_category, :category
    undef_method :category
    alias_method :attr_category=, :category=
    undef_method :category=
    
    typesig { [Category, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param category
    # the instance of the interface that changed.
    # @param definedChanged
    # true, iff the defined property changed.
    # @param descriptionChanged
    # true, iff the description property changed.
    # @param nameChanged
    # true, iff the name property changed.
    def initialize(category, defined_changed, description_changed, name_changed)
      @category = nil
      super(defined_changed, description_changed, name_changed)
      if ((category).nil?)
        raise NullPointerException.new
      end
      @category = category
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_category
      return @category
    end
    
    private
    alias_method :initialize__category_event, :initialize
  end
  
end
