require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module MetaDataKeeperImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Org::Eclipse::Core::Internal::Runtime, :DataArea
    }
  end
  
  # The class contains a set of utilities working platform metadata area.
  # This class can only be used if OSGi plugin is available.
  # 
  # Copied from InternalPlatform as of August 30, 2005.
  # @since org.eclipse.equinox.common 3.2
  class MetaDataKeeper 
    include_class_members MetaDataKeeperImports
    
    class_module.module_eval {
      
      def meta_area
        defined?(@@meta_area) ? @@meta_area : @@meta_area= nil
      end
      alias_method :attr_meta_area, :meta_area
      
      def meta_area=(value)
        @@meta_area = value
      end
      alias_method :attr_meta_area=, :meta_area=
      
      typesig { [] }
      # Returns the object which defines the location and organization
      # of the platform's meta area.
      def get_meta_area
        if (!(self.attr_meta_area).nil?)
          return self.attr_meta_area
        end
        self.attr_meta_area = DataArea.new
        return self.attr_meta_area
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__meta_data_keeper, :initialize
  end
  
end
