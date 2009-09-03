require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module ProjectionDocumentEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :SlaveDocumentEvent
    }
  end
  
  # This event is sent out by an
  # {@link org.eclipse.jface.text.projection.ProjectionDocument}when it is
  # manipulated. The manipulation is either a content manipulation or a change of
  # the projection between the master and the slave. Clients can determine the
  # type of change by asking the projection document event for its change type
  # (see {@link #getChangeType()}) and comparing it with the predefined types
  # {@link #PROJECTION_CHANGE}and {@link #CONTENT_CHANGE}.
  # <p>
  # Clients are not supposed to create instances of this class. Instances are
  # created by {@link org.eclipse.jface.text.projection.ProjectionDocument}
  # instances. This class is not intended to be subclassed.</p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionDocumentEvent < ProjectionDocumentEventImports.const_get :SlaveDocumentEvent
    include_class_members ProjectionDocumentEventImports
    
    class_module.module_eval {
      # The change type indicating a projection change
      const_set_lazy(:PROJECTION_CHANGE) { Object.new }
      const_attr_reader  :PROJECTION_CHANGE
      
      # The change type indicating a content change
      const_set_lazy(:CONTENT_CHANGE) { Object.new }
      const_attr_reader  :CONTENT_CHANGE
    }
    
    # The change type
    attr_accessor :f_change_type
    alias_method :attr_f_change_type, :f_change_type
    undef_method :f_change_type
    alias_method :attr_f_change_type=, :f_change_type=
    undef_method :f_change_type=
    
    # The offset of the change in the master document
    attr_accessor :f_master_offset
    alias_method :attr_f_master_offset, :f_master_offset
    undef_method :f_master_offset
    alias_method :attr_f_master_offset=, :f_master_offset=
    undef_method :f_master_offset=
    
    # The length of the change in the master document
    attr_accessor :f_master_length
    alias_method :attr_f_master_length, :f_master_length
    undef_method :f_master_length
    alias_method :attr_f_master_length=, :f_master_length=
    undef_method :f_master_length=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String, DocumentEvent] }
    # Creates a new content change event caused by the given master document
    # change. Instances created using this constructor return <code>-1</code>
    # when calling <code>getMasterOffset</code> or
    # <code>getMasterLength</code>. This information can be obtained by
    # accessing the master event.
    # 
    # @param doc the changed projection document
    # @param offset the offset in the projection document
    # @param length the length in the projection document
    # @param text the replacement text
    # @param masterEvent the original master event
    def initialize(doc, offset, length, text, master_event)
      @f_change_type = nil
      @f_master_offset = 0
      @f_master_length = 0
      super(doc, offset, length, text, master_event)
      @f_master_offset = -1
      @f_master_length = -1
      @f_change_type = CONTENT_CHANGE
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String, ::Java::Int, ::Java::Int] }
    # Creates a new projection change event for the given properties. Instances
    # created with this constructor return the given master document offset and
    # length but do not have an associated master document event.
    # 
    # @param doc the projection document
    # @param offset the offset in the projection document
    # @param length the length in the projection document
    # @param text the replacement text
    # @param masterOffset the offset in the master document
    # @param masterLength the length in the master document
    def initialize(doc, offset, length, text, master_offset, master_length)
      @f_change_type = nil
      @f_master_offset = 0
      @f_master_length = 0
      super(doc, offset, length, text, nil)
      @f_master_offset = -1
      @f_master_length = -1
      @f_change_type = PROJECTION_CHANGE
      @f_master_offset = master_offset
      @f_master_length = master_length
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String, ::Java::Int, ::Java::Int, DocumentEvent] }
    # Creates a new projection document event for the given properties. The
    # projection change is caused by a manipulation of the master document. In
    # order to accommodate the master document change, the projection document
    # had to change the projection. Instances created with this constructor
    # return the given master document offset and length and also have an
    # associated master document event.
    # 
    # @param doc the projection document
    # @param offset the offset in the projection document
    # @param length the length in the projection document
    # @param text the replacement text
    # @param masterOffset the offset in the master document
    # @param masterLength the length in the master document
    # @param masterEvent the master document event
    def initialize(doc, offset, length, text, master_offset, master_length, master_event)
      @f_change_type = nil
      @f_master_offset = 0
      @f_master_length = 0
      super(doc, offset, length, text, master_event)
      @f_master_offset = -1
      @f_master_length = -1
      @f_change_type = PROJECTION_CHANGE
      @f_master_offset = master_offset
      @f_master_length = master_length
    end
    
    typesig { [] }
    # Returns the change type of this event. This is either {@link #PROJECTION_CHANGE} or
    # {@link #CONTENT_CHANGE}.
    # 
    # @return the change type of this event
    def get_change_type
      return @f_change_type
    end
    
    typesig { [] }
    # Returns the offset of the master document range that has been added or removed in case this
    # event describes a projection change, otherwise it returns <code>-1</code>.
    # 
    # @return the master document offset of the projection change or <code>-1</code>
    def get_master_offset
      return @f_master_offset
    end
    
    typesig { [] }
    # Returns the length of the master document range that has been added or removed in case this event
    # describes a projection changed, otherwise <code>-1</code>.
    # 
    # @return the master document length of the projection change or <code>-1</code>
    def get_master_length
      return @f_master_length
    end
    
    private
    alias_method :initialize__projection_document_event, :initialize
  end
  
end
