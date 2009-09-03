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
  module SlaveDocumentEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A slave document event represents a master document event as a slave-relative
  # document event. It also carries the master document event.
  class SlaveDocumentEvent < SlaveDocumentEventImports.const_get :DocumentEvent
    include_class_members SlaveDocumentEventImports
    
    # The master document event
    attr_accessor :f_master_event
    alias_method :attr_f_master_event, :f_master_event
    undef_method :f_master_event
    alias_method :attr_f_master_event=, :f_master_event=
    undef_method :f_master_event=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String, DocumentEvent] }
    # Creates a new slave document event.
    # 
    # @param doc the slave document
    # @param offset the offset in the slave document
    # @param length the length in the slave document
    # @param text the substitution text
    # @param masterEvent the master document event
    def initialize(doc, offset, length, text, master_event)
      @f_master_event = nil
      super(doc, offset, length, text)
      @f_master_event = master_event
    end
    
    typesig { [] }
    # Returns this event's master event.
    # 
    # @return this event's master event
    def get_master_event
      return @f_master_event
    end
    
    private
    alias_method :initialize__slave_document_event, :initialize
  end
  
end
