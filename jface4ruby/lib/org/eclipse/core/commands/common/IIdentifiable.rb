require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module IIdentifiableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
    }
  end
  
  # <p>
  # An object that is unique identifiable based on the combination of its class
  # and its identifier.
  # </p>
  # 
  # @see HandleObject
  # @since 3.2
  module IIdentifiable
    include_class_members IIdentifiableImports
    
    typesig { [] }
    # Returns the identifier for this object.
    # 
    # @return The identifier; never <code>null</code>.
    def get_id
      raise NotImplementedError
    end
  end
  
end
