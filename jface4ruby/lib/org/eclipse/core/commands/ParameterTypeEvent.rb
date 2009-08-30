require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ParameterTypeEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractHandleObjectEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # {@link ParameterType}.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @see IParameterTypeListener#parameterTypeChanged(ParameterTypeEvent)
  # @since 3.2
  class ParameterTypeEvent < ParameterTypeEventImports.const_get :AbstractHandleObjectEvent
    include_class_members ParameterTypeEventImports
    
    # The parameter type that has changed. This value is never
    # <code>null</code>.
    attr_accessor :parameter_type
    alias_method :attr_parameter_type, :parameter_type
    undef_method :parameter_type
    alias_method :attr_parameter_type=, :parameter_type=
    undef_method :parameter_type=
    
    typesig { [ParameterType, ::Java::Boolean] }
    # Constructs a new instance.
    # 
    # @param parameterType
    # The parameter type that changed; must not be <code>null</code>.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    def initialize(parameter_type, defined_changed)
      @parameter_type = nil
      super(defined_changed)
      if ((parameter_type).nil?)
        raise NullPointerException.new
      end
      @parameter_type = parameter_type
    end
    
    typesig { [] }
    # Returns the instance of the parameter type that changed.
    # 
    # @return the instance of the parameter type that changed. Guaranteed not
    # to be <code>null</code>.
    def get_parameter_type
      return @parameter_type
    end
    
    private
    alias_method :initialize__parameter_type_event, :initialize
  end
  
end
