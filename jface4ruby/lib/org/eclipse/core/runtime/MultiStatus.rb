require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module MultiStatusImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # A concrete multi-status implementation,
  # suitable either for instantiating or subclassing.
  # <p>
  # This class can be used without OSGi running.
  # </p>
  class MultiStatus < MultiStatusImports.const_get :Status
    include_class_members MultiStatusImports
    
    # List of child statuses.
    attr_accessor :children
    alias_method :attr_children, :children
    undef_method :children
    alias_method :attr_children=, :children=
    undef_method :children=
    
    typesig { [String, ::Java::Int, Array.typed(IStatus), String, JavaThrowable] }
    # Creates and returns a new multi-status object with the given children.
    # 
    # @param pluginId the unique identifier of the relevant plug-in
    # @param code the plug-in-specific status code
    # @param newChildren the list of children status objects
    # @param message a human-readable message, localized to the
    # current locale
    # @param exception a low-level exception, or <code>null</code> if not
    # applicable
    def initialize(plugin_id, code, new_children, message, exception)
      initialize__multi_status(plugin_id, code, message, exception)
      Assert.is_legal(!(new_children).nil?)
      max_severity = get_severity
      i = 0
      while i < new_children.attr_length
        Assert.is_legal(!(new_children[i]).nil?)
        severity = new_children[i].get_severity
        if (severity > max_severity)
          max_severity = severity
        end
        i += 1
      end
      @children = Array.typed(IStatus).new(new_children.attr_length) { nil }
      set_severity(max_severity)
      System.arraycopy(new_children, 0, @children, 0, new_children.attr_length)
    end
    
    typesig { [String, ::Java::Int, String, JavaThrowable] }
    # Creates and returns a new multi-status object with no children.
    # 
    # @param pluginId the unique identifier of the relevant plug-in
    # @param code the plug-in-specific status code
    # @param message a human-readable message, localized to the
    # current locale
    # @param exception a low-level exception, or <code>null</code> if not
    # applicable
    def initialize(plugin_id, code, message, exception)
      @children = nil
      super(OK, plugin_id, code, message, exception)
      @children = Array.typed(IStatus).new(0) { nil }
    end
    
    typesig { [IStatus] }
    # Adds the given status to this multi-status.
    # 
    # @param status the new child status
    def add(status)
      Assert.is_legal(!(status).nil?)
      result = Array.typed(IStatus).new(@children.attr_length + 1) { nil }
      System.arraycopy(@children, 0, result, 0, @children.attr_length)
      result[result.attr_length - 1] = status
      @children = result
      new_sev = status.get_severity
      if (new_sev > get_severity)
        set_severity(new_sev)
      end
    end
    
    typesig { [IStatus] }
    # Adds all of the children of the given status to this multi-status.
    # Does nothing if the given status has no children (which includes
    # the case where it is not a multi-status).
    # 
    # @param status the status whose children are to be added to this one
    def add_all(status)
      Assert.is_legal(!(status).nil?)
      statuses = status.get_children
      i = 0
      while i < statuses.attr_length
        add(statuses[i])
        i += 1
      end
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_children
      return @children
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def is_multi_status
      return true
    end
    
    typesig { [IStatus] }
    # Merges the given status into this multi-status.
    # Equivalent to <code>add(status)</code> if the
    # given status is not a multi-status.
    # Equivalent to <code>addAll(status)</code> if the
    # given status is a multi-status.
    # 
    # @param status the status to merge into this one
    # @see #add(IStatus)
    # @see #addAll(IStatus)
    def merge(status)
      Assert.is_legal(!(status).nil?)
      if (!status.is_multi_status)
        add(status)
      else
        add_all(status)
      end
    end
    
    typesig { [] }
    # Returns a string representation of the status, suitable
    # for debugging purposes only.
    def to_s
      buf = StringBuffer.new(super)
      buf.append(" children=[") # $NON-NLS-1$
      i = 0
      while i < @children.attr_length
        if (!(i).equal?(0))
          buf.append(" ") # $NON-NLS-1$
        end
        buf.append(@children[i].to_s)
        i += 1
      end
      buf.append("]") # $NON-NLS-1$
      return buf.to_s
    end
    
    private
    alias_method :initialize__multi_status, :initialize
  end
  
end
