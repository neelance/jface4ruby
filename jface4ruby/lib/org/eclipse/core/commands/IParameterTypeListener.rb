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
  module IParameterTypeListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
    }
  end
  
  # An instance of this interface can be used by clients to receive notification
  # of changes to one or more instances of {@link ParameterType}.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.2
  # @see ParameterType#addListener(IParameterTypeListener)
  # @see ParameterType#removeListener(IParameterTypeListener)
  module IParameterTypeListener
    include_class_members IParameterTypeListenerImports
    
    typesig { [ParameterTypeEvent] }
    # Notifies that one or more properties of an instance of
    # {@link ParameterType} have changed. Specific details are described in the
    # {@link ParameterTypeEvent}.
    # 
    # @param parameterTypeEvent
    # the event. Guaranteed not to be <code>null</code>.
    def parameter_type_changed(parameter_type_event)
      raise NotImplementedError
    end
  end
  
end
