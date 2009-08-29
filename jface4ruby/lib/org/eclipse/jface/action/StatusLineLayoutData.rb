require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module StatusLineLayoutDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Swt, :SWT
    }
  end
  
  # Represents the layout data object for <code>Control</code> within the status line.
  # To set a <code>StatusLineLayoutData</code> object into a <code>Control</code>, use
  # the <code>setLayoutData()</code> method.
  # <p>
  # NOTE: Do not reuse <code>StatusLineLayoutData</code> objects. Every control in the
  # status line must have a unique <code>StatusLineLayoutData</code> instance or
  # <code>null</code>.
  # </p>
  # 
  # @since 2.1
  class StatusLineLayoutData 
    include_class_members StatusLineLayoutDataImports
    
    # The <code>widthHint</code> specifies a minimum width for
    # the <code>Control</code>. A value of <code>SWT.DEFAULT</code>
    # indicates that no minimum width is specified.
    # 
    # The default value is <code>SWT.DEFAULT</code>.
    attr_accessor :width_hint
    alias_method :attr_width_hint, :width_hint
    undef_method :width_hint
    alias_method :attr_width_hint=, :width_hint=
    undef_method :width_hint=
    
    # The <code>heightHint</code> specifies a minimum height for
    # the <code>Control</code>. A value of <code>SWT.DEFAULT</code>
    # indicates that no minimum height is specified.
    # 
    # The default value is <code>SWT.DEFAULT</code>.
    attr_accessor :height_hint
    alias_method :attr_height_hint, :height_hint
    undef_method :height_hint
    alias_method :attr_height_hint=, :height_hint=
    undef_method :height_hint=
    
    typesig { [] }
    # Creates an initial status line layout data object.
    def initialize
      @width_hint = SWT::DEFAULT
      @height_hint = SWT::DEFAULT
    end
    
    private
    alias_method :initialize__status_line_layout_data, :initialize
  end
  
end
