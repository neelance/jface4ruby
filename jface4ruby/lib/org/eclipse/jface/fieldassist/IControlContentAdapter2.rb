require "rjava"

# Copyright (c) 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module IControlContentAdapter2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # This interface is used by a {@link ContentProposalAdapter} in order to
  # retrieve and set the selection range in a control.
  # 
  # @since 3.4
  module IControlContentAdapter2
    include_class_members IControlContentAdapter2Imports
    
    typesig { [Control] }
    # Get the current selection range in the control. The x coordinate of the
    # returned point is the position of the first selected character and the y
    # coordinate of the returned point is the position of the last selected
    # character. The positions are specified as a zero-based index into the
    # string. Valid ranges are from 0 to N, where N is the size of the contents
    # string. A value of N indicates that the last character is in the
    # selection.
    # 
    # @param control
    # the control whose position is to be retrieved.
    # @return a point representing the selection start and end
    def get_selection(control)
      raise NotImplementedError
    end
    
    typesig { [Control, Point] }
    # Set the current selection range in the control. The x coordinate of the
    # provided point is the position of the first selected character and the y
    # coordinate of the point is the position of the last selected character.
    # The positions are specified as a zero-based index into the string. Valid
    # ranges are from 0 to N, where N is the size of the contents string. A
    # value of N indicates that the last character is in the selection. If the
    # x and y coordinates are the same, then there is no selection.
    # 
    # @param control
    # the control whose position is to be retrieved.
    # @param range
    # a point representing the selection start and end
    def set_selection(control, range)
      raise NotImplementedError
    end
  end
  
end
