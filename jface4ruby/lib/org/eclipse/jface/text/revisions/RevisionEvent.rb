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
  module RevisionEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Informs about a change of revision information.
  # <p>
  # Clients may use but not instantiate this class.
  # </p>
  # 
  # @since 3.3
  # @noinstantiate This class is not intended to be instantiated by clients.
  class RevisionEvent 
    include_class_members RevisionEventImports
    
    attr_accessor :f_information
    alias_method :attr_f_information, :f_information
    undef_method :f_information
    alias_method :attr_f_information=, :f_information=
    undef_method :f_information=
    
    typesig { [RevisionInformation] }
    # Creates a new event.
    # 
    # @param information the revision info
    def initialize(information)
      @f_information = nil
      Assert.is_legal(!(information).nil?)
      @f_information = information
    end
    
    typesig { [] }
    # Returns the revision information that has changed.
    # 
    # @return the revision information that has changed
    def get_revision_information
      return @f_information
    end
    
    private
    alias_method :initialize__revision_event, :initialize
  end
  
end
