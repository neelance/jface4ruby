require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TreeColumnViewerLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # TreeViewerLabelProvider is the ViewerLabelProvider that handles TreePaths.
  # 
  # @since 3.3
  class TreeColumnViewerLabelProvider < TreeColumnViewerLabelProviderImports.const_get :TableColumnViewerLabelProvider
    include_class_members TreeColumnViewerLabelProviderImports
    
    attr_accessor :tree_path_provider
    alias_method :attr_tree_path_provider, :tree_path_provider
    undef_method :tree_path_provider
    alias_method :attr_tree_path_provider=, :tree_path_provider=
    undef_method :tree_path_provider=
    
    typesig { [IBaseLabelProvider] }
    # Create a new instance of the receiver with the supplied labelProvider.
    # 
    # @param labelProvider
    def initialize(label_provider)
      @tree_path_provider = nil
      super(label_provider)
      @tree_path_provider = Class.new(ITreePathLabelProvider.class == Class ? ITreePathLabelProvider : Object) do
        local_class_in TreeColumnViewerLabelProvider
        include_class_members TreeColumnViewerLabelProvider
        include ITreePathLabelProvider if ITreePathLabelProvider.class == Module
        
        typesig { [ViewerLabel, TreePath] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.ITreePathLabelProvider#updateLabel(org.eclipse.jface.viewers.ViewerLabel,
        # org.eclipse.jface.viewers.TreePath)
        define_method :update_label do |label, element_path|
          # Do nothing by default
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IBaseLabelProvider#dispose()
        define_method :dispose do
          # Do nothing by default
        end
        
        typesig { [ILabelProviderListener] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IBaseLabelProvider#addListener(org.eclipse.jface.viewers.ILabelProviderListener)
        define_method :add_listener do |listener|
          # Do nothing by default
        end
        
        typesig { [ILabelProviderListener] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IBaseLabelProvider#removeListener(org.eclipse.jface.viewers.ILabelProviderListener)
        define_method :remove_listener do |listener|
          # Do nothing by default
        end
        
        typesig { [Object, String] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.IBaseLabelProvider#isLabelProperty(java.lang.Object, java.lang.String)
        define_method :is_label_property do |element, property|
          return false
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [ViewerLabel, TreePath] }
    # Update the label for the element with TreePath.
    # 
    # @param label
    # @param elementPath
    def update_label(label, element_path)
      @tree_path_provider.update_label(label, element_path)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.viewers.ViewerLabelProvider#setProviders(java.lang.Object)
    def set_providers(provider)
      super(provider)
      if (provider.is_a?(ITreePathLabelProvider))
        @tree_path_provider = provider
      end
    end
    
    typesig { [] }
    # Return the ITreePathLabelProvider for the receiver.
    # 
    # @return Returns the treePathProvider.
    def get_tree_path_provider
      return @tree_path_provider
    end
    
    private
    alias_method :initialize__tree_column_viewer_label_provider, :initialize
  end
  
end
