require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IInformationControlExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IInformationControl}.
  # <p>
  # Replaces the concept of textual information to be displayed with the more
  # general concept of an input of the information control. Text to be displayed
  # set with <code>setInformation(String)</code> is ignored.
  # 
  # @see org.eclipse.jface.text.IInformationControl
  # @since 2.1
  module IInformationControlExtension2
    include_class_members IInformationControlExtension2Imports
    
    typesig { [Object] }
    # Sets the input to be presented in this information control. The concrete
    # contract the input object is expected to adhere is defined by the
    # implementer of this interface.
    # 
    # @param input the object to be used as input for this control
    def set_input(input)
      raise NotImplementedError
    end
  end
  
end
