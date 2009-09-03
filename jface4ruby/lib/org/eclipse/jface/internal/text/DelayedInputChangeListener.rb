require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module DelayedInputChangeListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Jface::Text, :IDelayedInputChangeProvider
      include_const ::Org::Eclipse::Jface::Text, :IInputChangedListener
    }
  end
  
  # A delayed input change listener that forwards delayed input changes to an information control replacer.
  # 
  # @since 3.4
  class DelayedInputChangeListener 
    include_class_members DelayedInputChangeListenerImports
    include IInputChangedListener
    
    attr_accessor :f_change_provider
    alias_method :attr_f_change_provider, :f_change_provider
    undef_method :f_change_provider
    alias_method :attr_f_change_provider=, :f_change_provider=
    undef_method :f_change_provider=
    
    attr_accessor :f_information_control_replacer
    alias_method :attr_f_information_control_replacer, :f_information_control_replacer
    undef_method :f_information_control_replacer
    alias_method :attr_f_information_control_replacer=, :f_information_control_replacer=
    undef_method :f_information_control_replacer=
    
    typesig { [IDelayedInputChangeProvider, InformationControlReplacer] }
    # Creates a new listener.
    # 
    # @param changeProvider the information control with delayed input changes
    # @param informationControlReplacer the information control replacer, whose information control should get the new input
    def initialize(change_provider, information_control_replacer)
      @f_change_provider = nil
      @f_information_control_replacer = nil
      @f_change_provider = change_provider
      @f_information_control_replacer = information_control_replacer
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.IDelayedInputChangeListener#inputChanged(java.lang.Object)
    def input_changed(new_input)
      @f_change_provider.set_delayed_input_change_listener(nil)
      @f_information_control_replacer.set_delayed_input(new_input)
    end
    
    private
    alias_method :initialize__delayed_input_change_listener, :initialize
  end
  
end
