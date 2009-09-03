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
  module LinkedModeManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Stack
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A linked mode manager ensures exclusive access of linked position infrastructures to documents. There
  # is at most one <code>LinkedModeManager</code> installed on the same document. The <code>getManager</code>
  # methods will return the existing instance if any of the specified documents already have an installed
  # manager.
  # 
  # @since 3.0
  class LinkedModeManager 
    include_class_members LinkedModeManagerImports
    
    class_module.module_eval {
      # Our implementation of <code>ILinkedModeListener</code>.
      const_set_lazy(:Listener) { Class.new do
        extend LocalClass
        include_class_members LinkedModeManager
        include ILinkedModeListener
        
        typesig { [class_self::LinkedModeModel, ::Java::Int] }
        # @see org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel.ILinkedModeListener#left(org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel, int)
        def left(model, flags)
          @local_class_parent.left(model, flags)
        end
        
        typesig { [class_self::LinkedModeModel] }
        # @see org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel.ILinkedModeListener#suspend(org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel)
        def suspend(model)
          # not interested
        end
        
        typesig { [class_self::LinkedModeModel, ::Java::Int] }
        # @see org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel.ILinkedModeListener#resume(org.eclipse.jdt.internal.ui.text.link2.LinkedModeModel, int)
        def resume(model, flags)
          # not interested
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__listener, :initialize
      end }
      
      # Global map from documents to managers.
      
      def fg_managers
        defined?(@@fg_managers) ? @@fg_managers : @@fg_managers= HashMap.new
      end
      alias_method :attr_fg_managers, :fg_managers
      
      def fg_managers=(value)
        @@fg_managers = value
      end
      alias_method :attr_fg_managers=, :fg_managers=
      
      typesig { [IDocument] }
      # Returns whether there exists a <code>LinkedModeManager</code> on <code>document</code>.
      # 
      # @param document the document of interest
      # @return <code>true</code> if there exists a <code>LinkedModeManager</code> on <code>document</code>, <code>false</code> otherwise
      def has_manager(document)
        return !(self.attr_fg_managers.get(document)).nil?
      end
      
      typesig { [Array.typed(IDocument)] }
      # Returns whether there exists a <code>LinkedModeManager</code> on any of the <code>documents</code>.
      # 
      # @param documents the documents of interest
      # @return <code>true</code> if there exists a <code>LinkedModeManager</code> on any of the <code>documents</code>, <code>false</code> otherwise
      def has_manager(documents)
        i = 0
        while i < documents.attr_length
          if (has_manager(documents[i]))
            return true
          end
          i += 1
        end
        return false
      end
      
      typesig { [Array.typed(IDocument), ::Java::Boolean] }
      # Returns the manager for the given documents. If <code>force</code> is
      # <code>true</code>, any existing conflicting managers are canceled, otherwise,
      # the method may return <code>null</code> if there are conflicts.
      # 
      # @param documents the documents of interest
      # @param force whether to kill any conflicting managers
      # @return a manager able to cover the requested documents, or <code>null</code> if there is a conflict and <code>force</code> was set to <code>false</code>
      def get_linked_manager(documents, force)
        if ((documents).nil? || (documents.attr_length).equal?(0))
          return nil
        end
        mgrs = HashSet.new
        mgr = nil
        i = 0
        while i < documents.attr_length
          mgr = self.attr_fg_managers.get(documents[i])
          if (!(mgr).nil?)
            mgrs.add(mgr)
          end
          i += 1
        end
        if (mgrs.size > 1)
          if (force)
            it = mgrs.iterator
            while it.has_next
              m = it.next_
              m.close_all_environments
            end
          else
            return nil
          end
        end
        if ((mgrs.size).equal?(0))
          mgr = LinkedModeManager.new
        end
        i_ = 0
        while i_ < documents.attr_length
          self.attr_fg_managers.put(documents[i_], mgr)
          i_ += 1
        end
        return mgr
      end
      
      typesig { [IDocument] }
      # Cancels any linked mode manager for the specified document.
      # 
      # @param document the document whose <code>LinkedModeManager</code> should be canceled
      def cancel_manager(document)
        mgr = self.attr_fg_managers.get(document)
        if (!(mgr).nil?)
          mgr.close_all_environments
        end
      end
    }
    
    # The hierarchy of environments managed by this manager.
    attr_accessor :f_environments
    alias_method :attr_f_environments, :f_environments
    undef_method :f_environments
    alias_method :attr_f_environments=, :f_environments=
    undef_method :f_environments=
    
    attr_accessor :f_listener
    alias_method :attr_f_listener, :f_listener
    undef_method :f_listener
    alias_method :attr_f_listener=, :f_listener=
    undef_method :f_listener=
    
    typesig { [LinkedModeModel, ::Java::Int] }
    # Notify the manager about a leaving model.
    # 
    # @param model the model to nest
    # @param flags the reason and commands for leaving linked mode
    def left(model, flags)
      if (!@f_environments.contains(model))
        return
      end
      while (!@f_environments.is_empty)
        env = @f_environments.pop
        if ((env).equal?(model))
          break
        end
        env.exit(ILinkedModeListener::NONE)
      end
      if (@f_environments.is_empty)
        remove_manager
      end
    end
    
    typesig { [] }
    def close_all_environments
      while (!@f_environments.is_empty)
        env = @f_environments.pop
        env.exit(ILinkedModeListener::NONE)
      end
      remove_manager
    end
    
    typesig { [] }
    def remove_manager
      it = self.attr_fg_managers.key_set.iterator
      while it.has_next
        doc = it.next_
        if ((self.attr_fg_managers.get(doc)).equal?(self))
          it.remove
        end
      end
    end
    
    typesig { [LinkedModeModel, ::Java::Boolean] }
    # Tries to nest the given <code>LinkedModeModel</code> onto the top of
    # the stack of environments managed by the receiver. If <code>force</code>
    # is <code>true</code>, any environments on the stack that create a conflict
    # are killed.
    # 
    # @param model the model to nest
    # @param force whether to force the addition of the model
    # @return <code>true</code> if nesting was successful, <code>false</code> otherwise (only possible if <code>force</code> is <code>false</code>
    def nest_environment(model, force)
      Assert.is_not_null(model)
      begin
        while (true)
          if (@f_environments.is_empty)
            model.add_linking_listener(@f_listener)
            @f_environments.push(model)
            return true
          end
          top = @f_environments.peek
          if (model.can_nest_into(top))
            model.add_linking_listener(@f_listener)
            @f_environments.push(model)
            return true
          else
            if (!force)
              return false
            else
              # force
              @f_environments.pop
              top.exit(ILinkedModeListener::NONE)
              # continue;
            end
          end
        end
      ensure
        # if we remove any, make sure the new one got inserted
        Assert.is_true(@f_environments.size > 0)
      end
    end
    
    typesig { [] }
    # Returns the <code>LinkedModeModel</code> that is on top of the stack of
    # environments managed by the receiver.
    # 
    # @return the topmost <code>LinkedModeModel</code>
    def get_top_environment
      if (@f_environments.is_empty)
        return nil
      end
      return @f_environments.peek
    end
    
    typesig { [] }
    def initialize
      @f_environments = Stack.new
      @f_listener = Listener.new_local(self)
    end
    
    private
    alias_method :initialize__linked_mode_manager, :initialize
  end
  
end
