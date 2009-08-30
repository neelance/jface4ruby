require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Operations
  module OperationStatusImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Operations
      include_const ::Org::Eclipse::Core::Runtime, :Status
    }
  end
  
  # <p>
  # OperationStatus describes the status of a request to execute, undo, or redo
  # an operation.  This class may be instantiated by clients.
  # </p>
  # 
  # @since 3.1
  class OperationStatus < OperationStatusImports.const_get :Status
    include_class_members OperationStatusImports
    
    class_module.module_eval {
      # NOTHING_TO_REDO indicates there was no operation available for redo.
      # 
      # (value is 1).
      const_set_lazy(:NOTHING_TO_REDO) { 1 }
      const_attr_reader  :NOTHING_TO_REDO
      
      # NOTHING_TO_UNDO indicates there was no operation available for undo.
      # 
      # (value is 2).
      const_set_lazy(:NOTHING_TO_UNDO) { 2 }
      const_attr_reader  :NOTHING_TO_UNDO
      
      # OPERATION_INVALID indicates that the operation available for undo or redo
      # is not in a state to successfully perform the undo or redo.
      # 
      # (value is 3).
      const_set_lazy(:OPERATION_INVALID) { 3 }
      const_attr_reader  :OPERATION_INVALID
      
      # DEFAULT_PLUGIN_ID identifies the default plugin reporting the status.
      # 
      # (value is "org.eclipse.core.commands").
      
      def default_plugin_id
        defined?(@@default_plugin_id) ? @@default_plugin_id : @@default_plugin_id= "org.eclipse.core.commands"
      end
      alias_method :attr_default_plugin_id, :default_plugin_id
      
      def default_plugin_id=(value)
        @@default_plugin_id = value
      end
      alias_method :attr_default_plugin_id=, :default_plugin_id=
    }
    
    typesig { [::Java::Int, String, ::Java::Int, String, JavaThrowable] }
    # $NON-NLS-1$
    # 
    # Creates a new operation status, specifying all properties.
    # 
    # @param severity
    # the severity for the status
    # @param pluginId
    # the unique identifier of the relevant plug-in
    # @param code
    # the informational code for the status
    # @param message
    # a human-readable message, localized to the current locale
    # @param exception
    # a low-level exception, or <code>null</code> if not
    # applicable
    def initialize(severity, plugin_id, code, message, exception)
      super(severity, plugin_id, code, message, exception)
    end
    
    private
    alias_method :initialize__operation_status, :initialize
  end
  
end
