require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColumnLayoutDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # An abstract column layout data describing the information needed
  # (by <code>TableLayout</code>) to properly lay out a table.
  # <p>
  # This class is not intended to be subclassed outside the framework.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ColumnLayoutData 
    include_class_members ColumnLayoutDataImports
    
    # Indicates whether the column is resizable.
    attr_accessor :resizable
    alias_method :attr_resizable, :resizable
    undef_method :resizable
    alias_method :attr_resizable=, :resizable=
    undef_method :resizable=
    
    typesig { [::Java::Boolean] }
    # Creates a new column layout data object.
    # 
    # @param resizable <code>true</code> if the column is resizable, and <code>false</code> if not
    def initialize(resizable)
      @resizable = false
      @resizable = resizable
    end
    
    private
    alias_method :initialize__column_layout_data, :initialize
  end
  
end
