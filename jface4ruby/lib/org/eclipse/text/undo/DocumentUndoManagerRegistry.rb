require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Undo
  module DocumentUndoManagerRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # This document undo manager registry provides access to a document's
  # undo manager. In order to connect a document a document undo manager
  # call <code>connect</code>. After that call has successfully completed
  # undo manager can be obtained via <code>getDocumentUndoManager</code>.
  # The undo manager is created on the first connect and disposed on the last
  # disconnect, i.e. this registry keeps track of how often a undo manager is
  # connected and returns the same undo manager to each client as long as the
  # document is connected.
  # <p>
  # <em>The recoding of changes starts with the first {@link #connect(IDocument)}.</em></p>
  # 
  # @since 3.2
  # @noinstantiate This class is not intended to be instantiated by clients.
  class DocumentUndoManagerRegistry 
    include_class_members DocumentUndoManagerRegistryImports
    
    class_module.module_eval {
      const_set_lazy(:Record) { Class.new do
        include_class_members DocumentUndoManagerRegistry
        
        typesig { [class_self::IDocument] }
        def initialize(document)
          @count = 0
          @undo_manager = nil
          @count = 0
          @undo_manager = self.class::DocumentUndoManager.new(document)
        end
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        attr_accessor :undo_manager
        alias_method :attr_undo_manager, :undo_manager
        undef_method :undo_manager
        alias_method :attr_undo_manager=, :undo_manager=
        undef_method :undo_manager=
        
        private
        alias_method :initialize__record, :initialize
      end }
      
      
      def fg_factory
        defined?(@@fg_factory) ? @@fg_factory : @@fg_factory= HashMap.new
      end
      alias_method :attr_fg_factory, :fg_factory
      
      def fg_factory=(value)
        @@fg_factory = value
      end
      alias_method :attr_fg_factory=, :fg_factory=
    }
    
    typesig { [] }
    def initialize
      # Do not instantiate
    end
    
    class_module.module_eval {
      typesig { [IDocument] }
      # Connects the file at the given location to this manager. After that call
      # successfully completed it is guaranteed that each call to <code>getFileBuffer</code>
      # returns the same file buffer until <code>disconnect</code> is called.
      # <p>
      # <em>The recoding of changes starts with the first {@link #connect(IDocument)}.</em></p>
      # 
      # @param document the document to be connected
      def connect(document)
        synchronized(self) do
          Assert.is_not_null(document)
          record = self.attr_fg_factory.get(document)
          if ((record).nil?)
            record = Record.new(document)
            self.attr_fg_factory.put(document, record)
          end
          record.attr_count += 1
        end
      end
      
      typesig { [IDocument] }
      # Disconnects the given document from this registry.
      # 
      # @param document the document to be disconnected
      def disconnect(document)
        synchronized(self) do
          Assert.is_not_null(document)
          record = self.attr_fg_factory.get(document)
          record.attr_count -= 1
          if ((record.attr_count).equal?(0))
            self.attr_fg_factory.remove(document)
          end
        end
      end
      
      typesig { [IDocument] }
      # Returns the file buffer managed for the given location or <code>null</code>
      # if there is no such file buffer.
      # <p>
      # The provided location is either a full path of a workspace resource or
      # an absolute path in the local file system. The file buffer manager does
      # not resolve the location of workspace resources in the case of linked
      # resources.
      # </p>
      # 
      # @param document the document for which to get its undo manager
      # @return the document undo manager or <code>null</code>
      def get_document_undo_manager(document)
        synchronized(self) do
          Assert.is_not_null(document)
          record = self.attr_fg_factory.get(document)
          if ((record).nil?)
            return nil
          end
          return record.attr_undo_manager
        end
      end
    }
    
    private
    alias_method :initialize__document_undo_manager_registry, :initialize
  end
  
end
