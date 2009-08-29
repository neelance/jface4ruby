require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module PreferenceNodeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A concrete implementation of a node in a preference dialog tree. This class
  # also supports lazy creation of the node's preference page.
  class PreferenceNode 
    include_class_members PreferenceNodeImports
    include IPreferenceNode
    
    # Preference page, or <code>null</code> if not yet loaded.
    attr_accessor :page
    alias_method :attr_page, :page
    undef_method :page
    alias_method :attr_page=, :page=
    undef_method :page=
    
    # The list of subnodes (immediate children) of this node (element type:
    # <code>IPreferenceNode</code>).
    attr_accessor :sub_nodes
    alias_method :attr_sub_nodes, :sub_nodes
    undef_method :sub_nodes
    alias_method :attr_sub_nodes=, :sub_nodes=
    undef_method :sub_nodes=
    
    # Name of a class that implements <code>IPreferencePage</code>, or
    # <code>null</code> if none.
    attr_accessor :classname
    alias_method :attr_classname, :classname
    undef_method :classname
    alias_method :attr_classname=, :classname=
    undef_method :classname=
    
    # The id of this node.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # Text label for this node. Note that this field is only used prior to the
    # creation of the preference page.
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    # Image descriptor for this node, or <code>null</code> if none.
    attr_accessor :image_descriptor
    alias_method :attr_image_descriptor, :image_descriptor
    undef_method :image_descriptor
    alias_method :attr_image_descriptor=, :image_descriptor=
    undef_method :image_descriptor=
    
    # Cached image, or <code>null</code> if none.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    typesig { [String] }
    # Creates a new preference node with the given id. The new node has no
    # subnodes.
    # 
    # @param id
    # the node id
    def initialize(id)
      @page = nil
      @sub_nodes = nil
      @classname = nil
      @id = nil
      @label = nil
      @image_descriptor = nil
      @image = nil
      Assert.is_not_null(id)
      @id = id
    end
    
    typesig { [String, String, ImageDescriptor, String] }
    # Creates a preference node with the given id, label, and image, and
    # lazily-loaded preference page. The preference node assumes (sole)
    # responsibility for disposing of the image; this will happen when the node
    # is disposed.
    # 
    # @param id
    # the node id
    # @param label
    # the label used to display the node in the preference dialog's
    # tree
    # @param image
    # the image displayed left of the label in the preference
    # dialog's tree, or <code>null</code> if none
    # @param className
    # the class name of the preference page; this class must
    # implement <code>IPreferencePage</code>
    def initialize(id, label, image, class_name)
      initialize__preference_node(id)
      @image_descriptor = image
      Assert.is_not_null(label)
      @label = label
      @classname = class_name
    end
    
    typesig { [String, IPreferencePage] }
    # Creates a preference node with the given id and preference page. The
    # title of the preference page is used for the node label. The node will
    # not have an image.
    # 
    # @param id
    # the node id
    # @param preferencePage
    # the preference page
    def initialize(id, preference_page)
      initialize__preference_node(id)
      Assert.is_not_null(preference_page)
      @page = preference_page
    end
    
    typesig { [IPreferenceNode] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def add(node)
      if ((@sub_nodes).nil?)
        @sub_nodes = ArrayList.new
      end
      @sub_nodes.add(node)
    end
    
    typesig { [String] }
    # Creates a new instance of the given class <code>className</code>.
    # 
    # @param className
    # @return new Object or <code>null</code> in case of failures.
    def create_object(class_name)
      Assert.is_not_null(class_name)
      begin
        cl = Class.for_name(class_name)
        if (!(cl).nil?)
          return cl.new_instance
        end
      rescue ClassNotFoundException => e
        return nil
      rescue InstantiationException => e
        return nil
      rescue IllegalAccessException => e
        return nil
      rescue NoSuchMethodError => e
        return nil
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def create_page
      @page = create_object(@classname)
      if (!(get_label_image).nil?)
        @page.set_image_descriptor(@image_descriptor)
      end
      @page.set_title(@label)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def dispose_resources
      if (!(@image).nil?)
        @image.dispose
        @image = nil
      end
      if (!(@page).nil?)
        @page.dispose
        @page = nil
      end
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IContributionNode.
    def find_sub_node(id)
      Assert.is_not_null(id)
      Assert.is_true(id.length > 0)
      if ((@sub_nodes).nil?)
        return nil
      end
      size_ = @sub_nodes.size
      i = 0
      while i < size_
        node = @sub_nodes.get(i)
        if ((id == node.get_id))
          return node
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def get_id
      return @id
    end
    
    typesig { [] }
    # Returns the image descriptor for this node.
    # 
    # @return the image descriptor
    def get_image_descriptor
      return @image_descriptor
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def get_label_image
      if ((@image).nil? && !(@image_descriptor).nil?)
        @image = @image_descriptor.create_image
      end
      return @image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def get_label_text
      if (!(@page).nil?)
        return @page.get_title
      end
      return @label
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def get_page
      return @page
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def get_sub_nodes
      if ((@sub_nodes).nil?)
        return Array.typed(IPreferenceNode).new(0) { nil }
      end
      return @sub_nodes.to_array(Array.typed(IPreferenceNode).new(@sub_nodes.size) { nil })
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def remove(id)
      node = find_sub_node(id)
      if (!(node).nil?)
        remove(node)
      end
      return node
    end
    
    typesig { [IPreferenceNode] }
    # (non-Javadoc) Method declared on IPreferenceNode.
    def remove(node)
      if ((@sub_nodes).nil?)
        return false
      end
      return @sub_nodes.remove(node)
    end
    
    typesig { [IPreferencePage] }
    # Set the current page to be newPage.
    # 
    # @param newPage
    def set_page(new_page)
      @page = new_page
    end
    
    private
    alias_method :initialize__preference_node, :initialize
  end
  
end
