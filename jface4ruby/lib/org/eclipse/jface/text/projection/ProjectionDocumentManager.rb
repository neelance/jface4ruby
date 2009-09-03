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
  module ProjectionDocumentManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMapping
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :ISlaveDocumentManager
      include_const ::Org::Eclipse::Jface::Text, :ISlaveDocumentManagerExtension
    }
  end
  
  # A <code>ProjectionDocumentManager</code> is one particular implementation
  # of {@link org.eclipse.jface.text.ISlaveDocumentManager}. This manager
  # creates so called projection documents (see
  # {@link org.eclipse.jface.text.projection.ProjectionDocument}as slave
  # documents for given master documents.
  # <p>
  # A projection document represents a particular projection of the master
  # document and is accordingly adapted to changes of the master document. Vice
  # versa, the master document is accordingly adapted to changes of its slave
  # documents. The manager does not maintain any particular management structure
  # but utilizes mechanisms given by {@link org.eclipse.jface.text.IDocument}
  # such as position categories and position updaters.
  # <p>
  # Clients can instantiate this class. This class is not intended to be
  # subclassed.</p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionDocumentManager 
    include_class_members ProjectionDocumentManagerImports
    include IDocumentListener
    include ISlaveDocumentManager
    include ISlaveDocumentManagerExtension
    
    # Registry for master documents and their projection documents.
    attr_accessor :f_projection_registry
    alias_method :attr_f_projection_registry, :f_projection_registry
    undef_method :f_projection_registry
    alias_method :attr_f_projection_registry=, :f_projection_registry=
    undef_method :f_projection_registry=
    
    typesig { [IDocument, ProjectionDocument] }
    # Registers the given projection document for the given master document.
    # 
    # @param master the master document
    # @param projection the projection document
    def add(master, projection)
      list = @f_projection_registry.get(master)
      if ((list).nil?)
        list = ArrayList.new(1)
        @f_projection_registry.put(master, list)
      end
      list.add(projection)
    end
    
    typesig { [IDocument, ProjectionDocument] }
    # Unregisters the given projection document from its master.
    # 
    # @param master the master document
    # @param projection the projection document
    def remove(master, projection)
      list = @f_projection_registry.get(master)
      if (!(list).nil?)
        list.remove(projection)
        if ((list.size).equal?(0))
          @f_projection_registry.remove(master)
        end
      end
    end
    
    typesig { [IDocument] }
    # Returns whether the given document is a master document.
    # 
    # @param master the document
    # @return <code>true</code> if the given document is a master document known to this manager
    def has_projection(master)
      return (@f_projection_registry.get(master).is_a?(JavaList))
    end
    
    typesig { [IDocument] }
    # Returns an iterator enumerating all projection documents registered for the given document or
    # <code>null</code> if the document is not a known master document.
    # 
    # @param master the document
    # @return an iterator for all registered projection documents or <code>null</code>
    def get_projections_iterator(master)
      list = @f_projection_registry.get(master)
      if (!(list).nil?)
        return list.iterator
      end
      return nil
    end
    
    typesig { [::Java::Boolean, DocumentEvent] }
    # Informs all projection documents of the master document that issued the given document event.
    # 
    # @param about indicates whether the change is about to happen or happened already
    # @param masterEvent the document event which will be processed to inform the projection documents
    def fire_document_event(about, master_event)
      master = master_event.get_document
      e = get_projections_iterator(master)
      if ((e).nil?)
        return
      end
      while (e.has_next)
        document = e.next_
        if (about)
          document.master_document_about_to_be_changed(master_event)
        else
          document.master_document_changed(master_event)
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
    def document_changed(event)
      fire_document_event(false, event)
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
    def document_about_to_be_changed(event)
      fire_document_event(true, event)
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#createMasterSlaveMapping(org.eclipse.jface.text.IDocument)
    def create_master_slave_mapping(slave)
      if (slave.is_a?(ProjectionDocument))
        projection_document = slave
        return projection_document.get_document_information_mapping
      end
      return nil
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#createSlaveDocument(org.eclipse.jface.text.IDocument)
    def create_slave_document(master)
      if (!has_projection(master))
        master.add_document_listener(self)
      end
      slave = create_projection_document(master)
      add(master, slave)
      return slave
    end
    
    typesig { [IDocument] }
    # Factory method for projection documents.
    # 
    # @param master the master document
    # @return the newly created projection document
    def create_projection_document(master)
      return ProjectionDocument.new(master)
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#freeSlaveDocument(org.eclipse.jface.text.IDocument)
    def free_slave_document(slave)
      if (slave.is_a?(ProjectionDocument))
        projection_document = slave
        master = projection_document.get_master_document
        remove(master, projection_document)
        projection_document.dispose
        if (!has_projection(master))
          master.remove_document_listener(self)
        end
      end
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#getMasterDocument(org.eclipse.jface.text.IDocument)
    def get_master_document(slave)
      if (slave.is_a?(ProjectionDocument))
        return (slave).get_master_document
      end
      return nil
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#isSlaveDocument(org.eclipse.jface.text.IDocument)
    def is_slave_document(document)
      return (document.is_a?(ProjectionDocument))
    end
    
    typesig { [IDocument, ::Java::Boolean] }
    # @see org.eclipse.jface.text.ISlaveDocumentManager#setAutoExpandMode(org.eclipse.jface.text.IDocument, boolean)
    def set_auto_expand_mode(slave, auto_expanding)
      if (slave.is_a?(ProjectionDocument))
        (slave).set_auto_expand_mode(auto_expanding)
      end
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.ISlaveDocumentManagerExtension#getSlaveDocuments(org.eclipse.jface.text.IDocument)
    def get_slave_documents(master)
      list = @f_projection_registry.get(master)
      if (!(list).nil?)
        result = Array.typed(IDocument).new(list.size) { nil }
        list.to_array(result)
        return result
      end
      return nil
    end
    
    typesig { [] }
    def initialize
      @f_projection_registry = HashMap.new
    end
    
    private
    alias_method :initialize__projection_document_manager, :initialize
  end
  
end
