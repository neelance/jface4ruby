require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module AcceptAllFilterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Filter that accepts everything. Available as a singleton since having
  # more than one instance would be wasteful.
  # 
  # @since 3.1
  class AcceptAllFilter 
    include_class_members AcceptAllFilterImports
    include IFilter
    
    class_module.module_eval {
      typesig { [] }
      # Returns the singleton instance of AcceptAllFilter
      # 
      # @return the singleton instance of AcceptAllFilter
      def get_instance
        return self.attr_singleton
      end
      
      # The singleton instance
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= AcceptAllFilter.new
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
    }
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.deferred.IFilter#select(java.lang.Object)
    def select(to_test)
      return true
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(other)
      return (other).equal?(self) || other.is_a?(AcceptAllFilter)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__accept_all_filter, :initialize
  end
  
end
