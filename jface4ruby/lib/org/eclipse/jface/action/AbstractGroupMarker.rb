require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module AbstractGroupMarkerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Abstract superclass for group marker classes.
  # <p>
  # This class is not intended to be subclassed outside the framework.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class AbstractGroupMarker < AbstractGroupMarkerImports.const_get :ContributionItem
    include_class_members AbstractGroupMarkerImports
    
    typesig { [] }
    # Constructor for use by subclasses.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Create a new group marker with the given name.
    # The group name must not be <code>null</code> or the empty string.
    # The group name is also used as the item id.
    # 
    # @param groupName the name of the group
    def initialize(group_name)
      super(group_name)
      Assert.is_true(!(group_name).nil? && group_name.length > 0)
    end
    
    typesig { [] }
    # Returns the group name.
    # 
    # @return the group name
    def get_group_name
      return get_id
    end
    
    typesig { [] }
    # The <code>AbstractGroupMarker</code> implementation of this <code>IContributionItem</code>
    # method returns <code>true</code> iff the id is not <code>null</code>. Subclasses may override.
    def is_group_marker
      return !(get_id).nil?
    end
    
    private
    alias_method :initialize__abstract_group_marker, :initialize
  end
  
end
