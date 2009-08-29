require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module IPreferenceNodeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # Interface to a node in a preference dialog.
  # A preference node maintains a label and image used to display the
  # node in a preference dialog (usually in the form of a tree),
  # as well as the preference page this node stands for.
  # 
  # The node may use lazy creation for its page
  # 
  # Note that all preference nodes must be dispose their resources.
  # The node must dispose the page managed by this node, and any SWT resources
  # allocated by this node (Images, Fonts, etc).
  # However the node itself may be reused.
  module IPreferenceNode
    include_class_members IPreferenceNodeImports
    
    typesig { [IPreferenceNode] }
    # Adds the given preference node as a subnode of this
    # preference node.
    # 
    # @param node the node to add
    def add(node)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Creates the preference page for this node.
    def create_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Release the page managed by this node, and any SWT resources
    # held onto by this node (Images, Fonts, etc).
    # 
    # Note that nodes are reused so this is not a call to dispose the
    # node itself.
    def dispose_resources
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the subnode of this contribution node with the given node id.
    # 
    # @param id the preference node id
    # @return the subnode, or <code>null</code> if none
    def find_sub_node(id)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the id of this contribution node.
    # This id identifies a contribution node relative to its parent.
    # 
    # @return the node id
    def get_id
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the image used to present this node in a preference dialog.
    # 
    # @return the image for this node, or <code>null</code>
    # if there is no image for this node
    def get_label_image
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the text label used to present this node in a preference dialog.
    # 
    # @return the text label for this node, or <code>null</code>
    # if there is no label for this node
    def get_label_text
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the preference page for this node.
    # 
    # @return the preference page
    def get_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an iterator over the subnodes (immediate children)
    # of this contribution node.
    # 
    # @return an IPreferenceNode array containing the child nodes
    def get_sub_nodes
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Removes the subnode of this preference node with the given node id.
    # 
    # @param id the subnode id
    # @return the removed subnode, or <code>null</code> if none
    def remove(id)
      raise NotImplementedError
    end
    
    typesig { [IPreferenceNode] }
    # Removes the given preference node from the list of subnodes
    # (immediate children) of this node.
    # 
    # @param node the node to remove
    # @return <code>true</code> if the node was removed,
    # and <code>false</code> otherwise
    def remove(node)
      raise NotImplementedError
    end
  end
  
end
