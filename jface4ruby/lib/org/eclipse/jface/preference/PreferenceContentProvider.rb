require "rjava"

# Copyright (c) 2003, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module PreferenceContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Viewers, :ITreeContentProvider
      include_const ::Org::Eclipse::Jface::Viewers, :Viewer
    }
  end
  
  # Provides a tree model for <code>PreferenceManager</code> content.
  # 
  # @since 3.0
  class PreferenceContentProvider 
    include_class_members PreferenceContentProviderImports
    include ITreeContentProvider
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IContentProvider#dispose()
    def dispose
      @manager = nil
    end
    
    typesig { [IPreferenceNode, IPreferenceNode] }
    # Find the parent of the provided node.  Will search recursivly through the
    # preference tree.
    # 
    # @param parent the possible parent node.
    # @param target the target child node.
    # @return the parent node of the child node.
    def find_parent(parent, target)
      if ((parent.get_id == target.get_id))
        return nil
      end
      found = parent.find_sub_node(target.get_id)
      if (!(found).nil?)
        return parent
      end
      children = parent.get_sub_nodes
      i = 0
      while i < children.attr_length
        found = find_parent(children[i], target)
        if (!(found).nil?)
          return found
        end
        i += 1
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ITreeContentProvider#getChildren(java.lang.Object)
    def get_children(parent_element)
      # must be an instance of <code>IPreferenceNode</code>.
      return (parent_element).get_sub_nodes
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
    def get_elements(input_element)
      # must be an instance of <code>PreferenceManager</code>.
      return get_children((input_element).get_root)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ITreeContentProvider#getParent(java.lang.Object)
    def get_parent(element)
      # must be an instance of <code>IPreferenceNode</code>.
      target_node = element
      root = @manager.get_root
      return find_parent(root, target_node)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ITreeContentProvider#hasChildren(java.lang.Object)
    def has_children(element)
      return get_children(element).attr_length > 0
    end
    
    typesig { [Viewer, Object, Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
    def input_changed(viewer, old_input, new_input)
      @manager = new_input
    end
    
    typesig { [PreferenceManager] }
    # Set the manager for the preferences.
    # @param manager The manager to set.
    # 
    # @since 3.1
    def set_manager(manager)
      @manager = manager
    end
    
    typesig { [] }
    def initialize
      @manager = nil
    end
    
    private
    alias_method :initialize__preference_content_provider, :initialize
  end
  
end
