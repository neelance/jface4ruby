require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Revisions
  module IRevisionRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerInfo
      include_const ::Org::Eclipse::Jface::Text::Source, :IVerticalRulerInfoExtension
    }
  end
  
  # A vertical ruler column capable of displaying revision (annotate) information.
  # 
  # In order to provide backward compatibility for clients of
  # <code>IRevisionRulerColumn</code>, extension interfaces are used as a means
  # of evolution. The following extension interfaces exist:
  # <ul>
  # <li>{@link IRevisionRulerColumnExtension} since
  # version 3.3 allowing to register a selection listener on revisions and a configurable rendering mode.
  # </li>
  # </ul>
  # 
  # @since 3.2
  # @see RevisionInformation
  # @see IRevisionRulerColumnExtension
  module IRevisionRulerColumn
    include_class_members IRevisionRulerColumnImports
    include IVerticalRulerColumn
    include IVerticalRulerInfo
    include IVerticalRulerInfoExtension
    
    typesig { [RevisionInformation] }
    # Sets the revision information.
    # 
    # @param info the new revision information, or <code>null</code> to reset the ruler
    def set_revision_information(info)
      raise NotImplementedError
    end
  end
  
end
