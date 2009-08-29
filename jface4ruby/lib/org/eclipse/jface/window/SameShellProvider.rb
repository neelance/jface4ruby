require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Window
  module SameShellProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # Standard shell provider that always returns the shell containing the given
  # control. This will always return the correct shell for the control, even if
  # the control is reparented.
  # 
  # @since 3.1
  class SameShellProvider 
    include_class_members SameShellProviderImports
    include IShellProvider
    
    attr_accessor :target_control
    alias_method :attr_target_control, :target_control
    undef_method :target_control
    alias_method :attr_target_control=, :target_control=
    undef_method :target_control=
    
    typesig { [Control] }
    # Returns a shell provider that always returns the current
    # shell for the given control.
    # 
    # @param targetControl control whose shell will be tracked, or null if getShell() should always
    # return null
    def initialize(target_control)
      @target_control = nil
      @target_control = target_control
    end
    
    typesig { [] }
    # (non-javadoc)
    # @see IShellProvider#getShell()
    def get_shell
      if (@target_control.is_a?(Shell))
        return @target_control
      end
      return (@target_control).nil? ? nil : @target_control.get_shell
    end
    
    private
    alias_method :initialize__same_shell_provider, :initialize
  end
  
end
