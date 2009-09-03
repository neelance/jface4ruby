require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module LinkedModeModelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Text::Edits, :MalformedTreeException
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::IDocumentExtension, :IReplace
    }
  end
  
  # The model for linked mode, umbrellas several
  # {@link LinkedPositionGroup}s. Once installed, the model
  # propagates any changes to a position to all its siblings in the same position
  # group.
  # <p>
  # Setting up a model consists of first adding
  # <code>LinkedPositionGroup</code>s to it, and then installing the
  # model by either calling {@link #forceInstall()} or
  # {@link #tryInstall()}. After installing the model, it becomes
  # <em>sealed</em> and no more groups may be added.
  # </p>
  # <p>
  # If a document change occurs that would modify more than one position
  # group or that would invalidate the disjointness requirement of the positions,
  # the model is torn down and all positions are deleted. The same happens
  # upon calling {@link #exit(int)}.
  # </p>
  # <h4>Nesting</h4>
  # <p>
  # A <code>LinkedModeModel</code> may be nested into another model. This
  # happens when installing a model the positions of which all fit into a
  # single position in a parent model that has previously been installed on
  # the same document(s).
  # </p>
  # <p>
  # Clients may instantiate instances of this class.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class LinkedModeModel 
    include_class_members LinkedModeModelImports
    
    class_module.module_eval {
      typesig { [IDocument] }
      # Checks whether there is already a model installed on <code>document</code>.
      # 
      # @param document the <code>IDocument</code> of interest
      # @return <code>true</code> if there is an existing model, <code>false</code>
      # otherwise
      def has_installed_model(document)
        # if there is a manager, there also is a model
        return LinkedModeManager.has_manager(document)
      end
      
      typesig { [Array.typed(IDocument)] }
      # Checks whether there is already a linked mode model installed on any of
      # the <code>documents</code>.
      # 
      # @param documents the <code>IDocument</code>s of interest
      # @return <code>true</code> if there is an existing model, <code>false</code>
      # otherwise
      def has_installed_model(documents)
        # if there is a manager, there also is a model
        return LinkedModeManager.has_manager(documents)
      end
      
      typesig { [IDocument] }
      # Cancels any linked mode model on the specified document. If there is no
      # model, nothing happens.
      # 
      # @param document the document whose <code>LinkedModeModel</code> should
      # be canceled
      def close_all_models(document)
        LinkedModeManager.cancel_manager(document)
      end
      
      typesig { [IDocument, ::Java::Int] }
      # Returns the model currently active on <code>document</code> at
      # <code>offset</code>, or <code>null</code> if there is none.
      # 
      # @param document the document for which the caller asks for a
      # model
      # @param offset the offset into <code>document</code>, as there may be
      # several models on a document
      # @return the model currently active on <code>document</code>, or
      # <code>null</code>
      def get_model(document, offset)
        if (!has_installed_model(document))
          return nil
        end
        mgr = LinkedModeManager.get_linked_manager(Array.typed(IDocument).new([document]), false)
        if (!(mgr).nil?)
          return mgr.get_top_environment
        end
        return nil
      end
      
      # Encapsulates the edition triggered by a change to a linking position. Can
      # be applied to a document as a whole.
      const_set_lazy(:Replace) { Class.new do
        extend LocalClass
        include_class_members LinkedModeModel
        include IReplace
        
        # The edition to apply on a document.
        attr_accessor :f_edit
        alias_method :attr_f_edit, :f_edit
        undef_method :f_edit
        alias_method :attr_f_edit=, :f_edit=
        undef_method :f_edit=
        
        typesig { [class_self::TextEdit] }
        # Creates a new instance.
        # 
        # @param edit the edition to apply to a document.
        def initialize(edit)
          @f_edit = nil
          @f_edit = edit
        end
        
        typesig { [class_self::IDocument, class_self::IDocumentListener] }
        # @see org.eclipse.jface.text.IDocumentExtension.IReplace#perform(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocumentListener)
        def perform(document, owner)
          document.remove_document_listener(owner)
          self.attr_f_is_changing = true
          begin
            @f_edit.apply(document, TextEdit::UPDATE_REGIONS | TextEdit::CREATE_UNDO)
          rescue self.class::BadLocationException => e
            # XXX: perform should really throw a BadLocationException
            # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=52950
            raise self.class::RuntimeException.new(e)
          ensure
            document.add_document_listener(owner)
            self.attr_f_is_changing = false
          end
        end
        
        private
        alias_method :initialize__replace, :initialize
      end }
      
      # The document listener triggering the linked updating of positions
      # managed by this model.
      const_set_lazy(:DocumentListener) { Class.new do
        extend LocalClass
        include_class_members LinkedModeModel
        include IDocumentListener
        
        attr_accessor :f_exit
        alias_method :attr_f_exit, :f_exit
        undef_method :f_exit
        alias_method :attr_f_exit=, :f_exit=
        undef_method :f_exit=
        
        typesig { [class_self::DocumentEvent] }
        # Checks whether <code>event</code> occurs within any of the positions
        # managed by this model. If not, the linked mode is left.
        # 
        # @param event {@inheritDoc}
        def document_about_to_be_changed(event)
          # don't react on changes executed by the parent model
          if (!(self.attr_f_parent_environment).nil? && self.attr_f_parent_environment.is_changing)
            return
          end
          it = self.attr_f_groups.iterator
          while it.has_next
            group = it.next_
            if (!group.is_legal_event(event))
              @f_exit = true
              return
            end
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # Propagates a change to a linked position to all its sibling positions.
        # 
        # @param event {@inheritDoc}
        def document_changed(event)
          if (@f_exit)
            @local_class_parent.exit(ILinkedModeListener::EXTERNAL_MODIFICATION)
            return
          end
          @f_exit = false
          # don't react on changes executed by the parent model
          if (!(self.attr_f_parent_environment).nil? && self.attr_f_parent_environment.is_changing)
            return
          end
          # collect all results
          result = nil
          it = self.attr_f_groups.iterator
          while it.has_next
            group = it.next_
            map = group.handle_event(event)
            if (!(result).nil? && !(map).nil?)
              # exit if more than one position was changed
              @local_class_parent.exit(ILinkedModeListener::EXTERNAL_MODIFICATION)
              return
            end
            if (!(map).nil?)
              result = map
            end
          end
          if (!(result).nil?)
            # edit all documents
            it2 = result.key_set.iterator
            while it2.has_next
              doc = it2.next_
              edit = result.get(doc)
              replace = self.class::Replace.new(edit)
              # apply the edition, either as post notification replace
              # on the calling document or directly on any other
              # document
              if ((doc).equal?(event.get_document))
                if (doc.is_a?(self.class::IDocumentExtension))
                  (doc).register_post_notification_replace(self, replace)
                else
                  # ignore - there is no way we can log from JFace text...
                end
              else
                replace.perform(doc, self)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_exit = false
        end
        
        private
        alias_method :initialize__document_listener, :initialize
      end }
    }
    
    # The set of linked position groups.
    attr_accessor :f_groups
    alias_method :attr_f_groups, :f_groups
    undef_method :f_groups
    alias_method :attr_f_groups=, :f_groups=
    undef_method :f_groups=
    
    # The set of documents spanned by this group.
    attr_accessor :f_documents
    alias_method :attr_f_documents, :f_documents
    undef_method :f_documents
    alias_method :attr_f_documents=, :f_documents=
    undef_method :f_documents=
    
    # The position updater for linked positions.
    attr_accessor :f_updater
    alias_method :attr_f_updater, :f_updater
    undef_method :f_updater
    alias_method :attr_f_updater=, :f_updater=
    undef_method :f_updater=
    
    # The document listener on the documents affected by this model.
    attr_accessor :f_document_listener
    alias_method :attr_f_document_listener, :f_document_listener
    undef_method :f_document_listener
    alias_method :attr_f_document_listener=, :f_document_listener=
    undef_method :f_document_listener=
    
    # The parent model for a hierarchical set up, or <code>null</code>.
    attr_accessor :f_parent_environment
    alias_method :attr_f_parent_environment, :f_parent_environment
    undef_method :f_parent_environment
    alias_method :attr_f_parent_environment=, :f_parent_environment=
    undef_method :f_parent_environment=
    
    # The position in <code>fParentEnvironment</code> that includes all
    # positions in this object, or <code>null</code> if there is no parent
    # model.
    attr_accessor :f_parent_position
    alias_method :attr_f_parent_position, :f_parent_position
    undef_method :f_parent_position
    alias_method :attr_f_parent_position=, :f_parent_position=
    undef_method :f_parent_position=
    
    # A model is sealed once it has children - no more positions can be
    # added.
    attr_accessor :f_is_sealed
    alias_method :attr_f_is_sealed, :f_is_sealed
    undef_method :f_is_sealed
    alias_method :attr_f_is_sealed=, :f_is_sealed=
    undef_method :f_is_sealed=
    
    # <code>true</code> when this model is changing documents.
    attr_accessor :f_is_changing
    alias_method :attr_f_is_changing, :f_is_changing
    undef_method :f_is_changing
    alias_method :attr_f_is_changing=, :f_is_changing=
    undef_method :f_is_changing=
    
    # The linked listeners.
    attr_accessor :f_listeners
    alias_method :attr_f_listeners, :f_listeners
    undef_method :f_listeners
    alias_method :attr_f_listeners=, :f_listeners=
    undef_method :f_listeners=
    
    # Flag telling whether we have exited:
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    # The sequence of document positions as we are going to iterate through
    # them.
    attr_accessor :f_position_sequence
    alias_method :attr_f_position_sequence, :f_position_sequence
    undef_method :f_position_sequence
    alias_method :attr_f_position_sequence=, :f_position_sequence=
    undef_method :f_position_sequence=
    
    typesig { [] }
    # Whether we are in the process of editing documents (set by <code>Replace</code>,
    # read by <code>DocumentListener</code>.
    # 
    # @return <code>true</code> if we are in the process of editing a
    # document, <code>false</code> otherwise
    def is_changing
      return @f_is_changing || !(@f_parent_environment).nil? && @f_parent_environment.is_changing
    end
    
    typesig { [LinkedPositionGroup] }
    # Throws a <code>BadLocationException</code> if <code>group</code>
    # conflicts with this model's groups.
    # 
    # @param group the group being checked
    # @throws BadLocationException if <code>group</code> conflicts with this
    # model's groups
    def enforce_disjoint(group)
      it = @f_groups.iterator
      while it.has_next
        g = it.next_
        g.enforce_disjoint(group)
      end
    end
    
    typesig { [::Java::Int] }
    # Causes this model to exit. Called either if an illegal document change
    # is detected, or by the UI.
    # 
    # @param flags the exit flags as defined in {@link ILinkedModeListener}
    def exit(flags)
      if (!@f_is_active)
        return
      end
      @f_is_active = false
      it = @f_documents.iterator
      while it.has_next
        doc = it.next_
        begin
          doc.remove_position_category(get_category)
        rescue BadPositionCategoryException => e
          # won't happen
          Assert.is_true(false)
        end
        doc.remove_position_updater(@f_updater)
        doc.remove_document_listener(@f_document_listener)
      end
      @f_documents.clear
      @f_groups.clear
      listeners = ArrayList.new(@f_listeners)
      @f_listeners.clear
      it_ = listeners.iterator
      while it_.has_next
        listener = it_.next_
        listener.left(self, flags)
      end
      if (!(@f_parent_environment).nil?)
        @f_parent_environment.resume(flags)
      end
    end
    
    typesig { [::Java::Int] }
    # Causes this model to stop forwarding updates. The positions are not
    # unregistered however, which will only happen when <code>exit</code>
    # is called, or after the next document change.
    # 
    # @param flags the exit flags as defined in {@link ILinkedModeListener}
    # @since 3.1
    def stop_forwarding(flags)
      @f_document_listener.attr_f_exit = true
    end
    
    typesig { [IDocument] }
    # Puts <code>document</code> into the set of managed documents. This
    # involves registering the document listener and adding our position
    # category.
    # 
    # @param document the new document
    def manage_document(document)
      if (!@f_documents.contains(document))
        @f_documents.add(document)
        document.add_position_category(get_category)
        document.add_position_updater(@f_updater)
        document.add_document_listener(@f_document_listener)
      end
    end
    
    typesig { [] }
    # Returns the position category used by this model.
    # 
    # @return the position category used by this model
    def get_category
      return to_s
    end
    
    typesig { [LinkedPositionGroup] }
    # Adds a position group to this <code>LinkedModeModel</code>. This
    # method may not be called if the model has been installed. Also, if
    # a UI has been set up for this model, it may not pick up groups
    # added afterwards.
    # <p>
    # If the positions in <code>group</code> conflict with any other group in
    # this model, a <code>BadLocationException</code> is thrown. Also,
    # if this model is nested inside another one, all positions in all
    # groups of the child model have to reside within a single position in the
    # parent model, otherwise a <code>BadLocationException</code> is thrown.
    # </p>
    # <p>
    # If <code>group</code> already exists, nothing happens.
    # </p>
    # 
    # @param group the group to be added to this model
    # @throws BadLocationException if the group conflicts with the other groups
    # in this model or violates the nesting requirements.
    # @throws IllegalStateException if the method is called when the
    # model is already sealed
    def add_group(group)
      if ((group).nil?)
        raise IllegalArgumentException.new("group may not be null")
      end # $NON-NLS-1$
      if (@f_is_sealed)
        raise IllegalStateException.new("model is already installed")
      end # $NON-NLS-1$
      if (@f_groups.contains(group))
        # nothing happens
        return
      end
      enforce_disjoint(group)
      group.seal
      @f_groups.add(group)
    end
    
    typesig { [] }
    # Creates a new model.
    # @since 3.1
    def initialize
      @f_groups = ArrayList.new
      @f_documents = HashSet.new
      @f_updater = InclusivePositionUpdater.new(get_category)
      @f_document_listener = DocumentListener.new_local(self)
      @f_parent_environment = nil
      @f_parent_position = nil
      @f_is_sealed = false
      @f_is_changing = false
      @f_listeners = ArrayList.new
      @f_is_active = true
      @f_position_sequence = ArrayList.new
    end
    
    typesig { [] }
    # Installs this model, which includes registering as document
    # listener on all involved documents and storing global information about
    # this model. Any conflicting model already present will be
    # closed.
    # <p>
    # If an exception is thrown, the installation failed and
    # the model is unusable.
    # </p>
    # 
    # @throws BadLocationException if some of the positions of this model
    # were not valid positions on their respective documents
    def force_install
      if (!install(true))
        Assert.is_true(false)
      end
    end
    
    typesig { [] }
    # Installs this model, which includes registering as document
    # listener on all involved documents and storing global information about
    # this model. If there is another model installed on the
    # document(s) targeted by the receiver that conflicts with it, installation
    # may fail.
    # <p>
    # The return value states whether installation was
    # successful; if not, the model is not installed and will not work.
    # </p>
    # 
    # @return <code>true</code> if installation was successful,
    # <code>false</code> otherwise
    # @throws BadLocationException if some of the positions of this model
    # were not valid positions on their respective documents
    def try_install
      return install(false)
    end
    
    typesig { [::Java::Boolean] }
    # Installs this model, which includes registering as document
    # listener on all involved documents and storing global information about
    # this model. The return value states whether installation was
    # successful; if not, the model is not installed and will not work.
    # The return value can only then become <code>false</code> if
    # <code>force</code> was set to <code>false</code> as well.
    # 
    # @param force if <code>true</code>, any other model that cannot
    # coexist with this one is canceled; if <code>false</code>,
    # install will fail when conflicts occur and return false
    # @return <code>true</code> if installation was successful,
    # <code>false</code> otherwise
    # @throws BadLocationException if some of the positions of this model
    # were not valid positions on their respective documents
    def install(force)
      if (@f_is_sealed)
        raise IllegalStateException.new("model is already installed")
      end # $NON-NLS-1$
      enforce_not_empty
      documents = get_documents
      manager = LinkedModeManager.get_linked_manager(documents, force)
      # if we force creation, we require a valid manager
      Assert.is_true(!(force && (manager).nil?))
      if ((manager).nil?)
        return false
      end
      if (!manager.nest_environment(self, force))
        if (force)
          Assert.is_true(false)
        else
          return false
        end
      end
      # we set up successfully. After this point, exit has to be called to
      # remove registered listeners...
      @f_is_sealed = true
      if (!(@f_parent_environment).nil?)
        @f_parent_environment.suspend
      end
      # register positions
      begin
        it = @f_groups.iterator
        while it.has_next
          group = it.next_
          group.register(self)
        end
        return true
      rescue BadLocationException => e
        # if we fail to add, make sure to release all listeners again
        exit(ILinkedModeListener::NONE)
        raise e
      end
    end
    
    typesig { [] }
    # Asserts that there is at least one linked position in this linked mode
    # model, throws an IllegalStateException otherwise.
    def enforce_not_empty
      has_position = false
      it = @f_groups.iterator
      while it.has_next
        if (!(it.next_).is_empty)
          has_position = true
          break
        end
      end
      if (!has_position)
        raise IllegalStateException.new("must specify at least one linked position")
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # Collects all the documents that contained positions are set upon.
    # @return the set of documents affected by this model
    def get_documents
      docs = HashSet.new
      it = @f_groups.iterator
      while it.has_next
        group = it.next_
        docs.add_all(Arrays.as_list(group.get_documents))
      end
      return docs.to_array(Array.typed(IDocument).new(docs.size) { nil })
    end
    
    typesig { [LinkedModeModel] }
    # Returns whether the receiver can be nested into the given <code>parent</code>
    # model. If yes, the parent model and its position that the receiver
    # fits in are remembered.
    # 
    # @param parent the parent model candidate
    # @return <code>true</code> if the receiver can be nested into <code>parent</code>, <code>false</code> otherwise
    def can_nest_into(parent)
      it = @f_groups.iterator
      while it.has_next
        group = it.next_
        if (!enforce_nestability(group, parent))
          @f_parent_position = nil
          return false
        end
      end
      Assert.is_not_null(@f_parent_position)
      @f_parent_environment = parent
      return true
    end
    
    typesig { [LinkedPositionGroup, LinkedModeModel] }
    # Called by nested models when a group is added to them. All
    # positions in all groups of a nested model have to fit inside a
    # single position in the parent model.
    # 
    # @param group the group of the nested model to be adopted.
    # @param model the model to check against
    # @return <code>false</code> if it failed to enforce nestability
    def enforce_nestability(group, model)
      Assert.is_not_null(model)
      Assert.is_not_null(group)
      begin
        it = model.attr_f_groups.iterator
        while it.has_next
          pg = it.next_
          pos = nil
          pos = pg.adopt(group)
          if (!(pos).nil? && !(@f_parent_position).nil? && !(@f_parent_position).equal?(pos))
            return false
             # group does not fit into one parent position, which is illegal
          else
            if ((@f_parent_position).nil? && !(pos).nil?)
              @f_parent_position = pos
            end
          end
        end
      rescue BadLocationException => e
        return false
      end
      # group must fit into exactly one of the parent's positions
      return !(@f_parent_position).nil?
    end
    
    typesig { [] }
    # Returns whether this model is nested.
    # 
    # <p>
    # This method is part of the private protocol between
    # <code>LinkedModeUI</code> and <code>LinkedModeModel</code>.
    # </p>
    # 
    # @return <code>true</code> if this model is nested,
    # <code>false</code> otherwise
    def is_nested
      return !(@f_parent_environment).nil?
    end
    
    typesig { [] }
    # Returns the positions in this model that have a tab stop, in the
    # order they were added.
    # 
    # <p>
    # This method is part of the private protocol between
    # <code>LinkedModeUI</code> and <code>LinkedModeModel</code>.
    # </p>
    # 
    # @return the positions in this model that have a tab stop, in the
    # order they were added
    def get_tab_stop_sequence
      return @f_position_sequence
    end
    
    typesig { [ILinkedModeListener] }
    # Adds <code>listener</code> to the set of listeners that are informed
    # upon state changes.
    # 
    # @param listener the new listener
    def add_linking_listener(listener)
      Assert.is_not_null(listener)
      if (!@f_listeners.contains(listener))
        @f_listeners.add(listener)
      end
    end
    
    typesig { [ILinkedModeListener] }
    # Removes <code>listener</code> from the set of listeners that are
    # informed upon state changes.
    # 
    # @param listener the new listener
    def remove_linking_listener(listener)
      @f_listeners.remove(listener)
    end
    
    typesig { [LinkedPosition] }
    # Finds the position in this model that is closest after
    # <code>toFind</code>. <code>toFind</code> needs not be a position in
    # this model and serves merely as an offset.
    # 
    # <p>
    # This method part of the private protocol between
    # <code>LinkedModeUI</code> and <code>LinkedModeModel</code>.
    # </p>
    # 
    # @param toFind the position to search from
    # @return the closest position in the same document as <code>toFind</code>
    # after the offset of <code>toFind</code>, or <code>null</code>
    def find_position(to_find)
      position = nil
      it = @f_groups.iterator
      while it.has_next
        group = it.next_
        position = group.get_position(to_find)
        if (!(position).nil?)
          break
        end
      end
      return position
    end
    
    typesig { [LinkedPosition] }
    # Registers a <code>LinkedPosition</code> with this model. Called
    # by <code>PositionGroup</code>.
    # 
    # @param position the position to register
    # @throws BadLocationException if the position cannot be added to its
    # document
    def register(position)
      Assert.is_not_null(position)
      document = position.get_document
      manage_document(document)
      begin
        document.add_position(get_category, position)
      rescue BadPositionCategoryException => e
        # won't happen as the category has been added by manageDocument()
        Assert.is_true(false)
      end
      seq_nr = position.get_sequence_number
      if (!(seq_nr).equal?(LinkedPositionGroup::NO_STOP))
        @f_position_sequence.add(position)
      end
    end
    
    typesig { [] }
    # Suspends this model.
    def suspend
      l = ArrayList.new(@f_listeners)
      it = l.iterator
      while it.has_next
        listener = it.next_
        listener.suspend(self)
      end
    end
    
    typesig { [::Java::Int] }
    # Resumes this model. <code>flags</code> can be <code>NONE</code>
    # or <code>SELECT</code>.
    # 
    # @param flags <code>NONE</code> or <code>SELECT</code>
    def resume(flags)
      l = ArrayList.new(@f_listeners)
      it = l.iterator
      while it.has_next
        listener = it.next_
        listener.resume(self, flags)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns whether an offset is contained by any position in this
    # model.
    # 
    # @param offset the offset to check
    # @return <code>true</code> if <code>offset</code> is included by any
    # position (see {@link LinkedPosition#includes(int)}) in this
    # model, <code>false</code> otherwise
    def any_position_contains(offset)
      it = @f_groups.iterator
      while it.has_next
        group = it.next_
        if (group.contains(offset))
          # take the first hit - exclusion is guaranteed by enforcing
          # disjointness when adding positions
          return true
        end
      end
      return false
    end
    
    typesig { [Position] }
    # Returns the linked position group that contains <code>position</code>,
    # or <code>null</code> if <code>position</code> is not contained in any
    # group within this model. Group containment is tested by calling
    # <code>group.contains(position)</code> for every <code>group</code> in
    # this model.
    # 
    # <p>
    # This method part of the private protocol between
    # <code>LinkedModeUI</code> and <code>LinkedModeModel</code>.
    # </p>
    # 
    # @param position the position the group of which is requested
    # @return the first group in this model for which
    # <code>group.contains(position)</code> returns <code>true</code>,
    # or <code>null</code> if no group contains <code>position</code>
    def get_group_for_position(position)
      it = @f_groups.iterator
      while it.has_next
        group = it.next_
        if (group.contains(position))
          return group
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__linked_mode_model, :initialize
  end
  
end
