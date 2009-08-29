require "rjava"

# Copyright (c) 2005, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module TreeSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A concrete implementation of the <code>ITreeSelection</code> interface,
  # suitable for instantiating.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @since 3.2
  class TreeSelection < TreeSelectionImports.const_get :StructuredSelection
    include_class_members TreeSelectionImports
    overload_protected {
      include ITreeSelection
    }
    
    # Implementation note.  This class extends StructuredSelection because many pre-existing
    # JFace viewer clients assumed that the only implementation of IStructuredSelection
    # was StructuredSelection.  By extending StructuredSelection rather than implementing
    # ITreeSelection directly, we avoid this problem.
    # For more details, see Bug 121939 [Viewers] TreeSelection should subclass StructuredSelection.
    attr_accessor :paths
    alias_method :attr_paths, :paths
    undef_method :paths
    alias_method :attr_paths=, :paths=
    undef_method :paths=
    
    attr_accessor :element2tree_paths
    alias_method :attr_element2tree_paths, :element2tree_paths
    undef_method :element2tree_paths
    alias_method :attr_element2tree_paths=, :element2tree_paths=
    undef_method :element2tree_paths=
    
    class_module.module_eval {
      # The canonical empty selection. This selection should be used instead of
      # <code>null</code>.
      const_set_lazy(:EMPTY) { TreeSelection.new }
      const_attr_reader  :EMPTY
      
      const_set_lazy(:EMPTY_TREE_PATHS) { Array.typed(TreePath).new(0) { nil } }
      const_attr_reader  :EMPTY_TREE_PATHS
      
      const_set_lazy(:InitializeData) { Class.new do
        include_class_members TreeSelection
        
        attr_accessor :selection
        alias_method :attr_selection, :selection
        undef_method :selection
        alias_method :attr_selection=, :selection=
        undef_method :selection=
        
        attr_accessor :paths
        alias_method :attr_paths, :paths
        undef_method :paths
        alias_method :attr_paths=, :paths=
        undef_method :paths=
        
        attr_accessor :element2tree_paths
        alias_method :attr_element2tree_paths, :element2tree_paths
        undef_method :element2tree_paths
        alias_method :attr_element2tree_paths=, :element2tree_paths=
        undef_method :element2tree_paths=
        
        typesig { [Array.typed(class_self::TreePath), class_self::IElementComparer] }
        def initialize(paths, comparer)
          @selection = nil
          @paths = nil
          @element2tree_paths = nil
          @paths = Array.typed(self.class::TreePath).new(paths.attr_length) { nil }
          System.arraycopy(paths, 0, @paths, 0, paths.attr_length)
          @element2tree_paths = self.class::CustomHashtable.new(comparer)
          size = paths.attr_length
          @selection = self.class::ArrayList.new(size)
          i = 0
          while i < size
            last_segment = paths[i].get_last_segment
            mapped = @element2tree_paths.get(last_segment)
            if ((mapped).nil?)
              @selection.add(last_segment)
              @element2tree_paths.put(last_segment, paths[i])
            else
              if (mapped.is_a?(self.class::JavaList))
                (mapped).add(paths[i])
              else
                new_mapped = self.class::ArrayList.new(2)
                new_mapped.add(mapped)
                new_mapped.add(paths[i])
                @element2tree_paths.put(last_segment, new_mapped)
              end
            end
            i += 1
          end
        end
        
        private
        alias_method :initialize__initialize_data, :initialize
      end }
    }
    
    typesig { [Array.typed(TreePath)] }
    # Constructs a selection based on the elements identified by the given tree
    # paths.
    # 
    # @param paths
    # tree paths
    def initialize(paths)
      initialize__tree_selection(InitializeData.new(paths, nil))
    end
    
    typesig { [Array.typed(TreePath), IElementComparer] }
    # Constructs a selection based on the elements identified by the given tree
    # paths.
    # 
    # @param paths
    # tree paths
    # @param comparer
    # the comparer, or <code>null</code> if default equals is to be used
    def initialize(paths, comparer)
      initialize__tree_selection(InitializeData.new(paths, comparer))
    end
    
    typesig { [TreePath] }
    # Constructs a selection based on the elements identified by the given tree
    # path.
    # 
    # @param treePath
    # tree path, or <code>null</code> for an empty selection
    def initialize(tree_path)
      initialize__tree_selection(!(tree_path).nil? ? Array.typed(TreePath).new([tree_path]) : EMPTY_TREE_PATHS, nil)
    end
    
    typesig { [TreePath, IElementComparer] }
    # Constructs a selection based on the elements identified by the given tree
    # path.
    # 
    # @param treePath
    # tree path, or <code>null</code> for an empty selection
    # @param comparer
    # the comparer, or <code>null</code> if default equals is to be used
    def initialize(tree_path, comparer)
      initialize__tree_selection(!(tree_path).nil? ? Array.typed(TreePath).new([tree_path]) : EMPTY_TREE_PATHS, comparer)
    end
    
    typesig { [InitializeData] }
    # Creates a new tree selection based on the initialization data.
    # 
    # @param data the data
    def initialize(data)
      @paths = nil
      @element2tree_paths = nil
      super(data.attr_selection)
      @paths = nil
      @element2tree_paths = nil
      @paths = data.attr_paths
      @element2tree_paths = data.attr_element2tree_paths
    end
    
    typesig { [] }
    # Creates a new empty selection. See also the static field
    # <code>EMPTY</code> which contains an empty selection singleton.
    # 
    # @see #EMPTY
    def initialize
      @paths = nil
      @element2tree_paths = nil
      super()
      @paths = nil
      @element2tree_paths = nil
    end
    
    typesig { [] }
    # Returns the element comparer passed in when the tree selection
    # has been created or <code>null</code> if no comparer has been
    # provided.
    # 
    # @return the element comparer or <code>null</code>
    # 
    # @since 3.2
    def get_element_comparer
      if ((@element2tree_paths).nil?)
        return nil
      end
      return @element2tree_paths.get_comparer
    end
    
    typesig { [Object] }
    def ==(obj)
      if (!(obj.is_a?(TreeSelection)))
        # Fall back to super implementation, see bug 135837.
        return super(obj)
      end
      selection = obj
      size = get_paths.attr_length
      if ((selection.get_paths.attr_length).equal?(size))
        comparer_or_null = ((get_element_comparer).equal?(selection.get_element_comparer)) ? get_element_comparer : nil
        if (size > 0)
          i = 0
          while i < @paths.attr_length
            if (!(@paths[i] == selection.attr_paths[i]))
              return false
            end
            i += 1
          end
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    def hash_code
      code = get_class.hash_code
      if (!(@paths).nil?)
        i = 0
        while i < @paths.attr_length
          code = code * 17 + @paths[i].hash_code(get_element_comparer)
          i += 1
        end
      end
      return code
    end
    
    typesig { [] }
    def get_paths
      return (@paths).nil? ? EMPTY_TREE_PATHS : @paths.clone
    end
    
    typesig { [Object] }
    def get_paths_for(element)
      value = (@element2tree_paths).nil? ? nil : @element2tree_paths.get(element)
      if ((value).nil?)
        return EMPTY_TREE_PATHS
      else
        if (value.is_a?(TreePath))
          return Array.typed(TreePath).new([value])
        else
          if (value.is_a?(JavaList))
            l = value
            return l.to_array(Array.typed(TreePath).new(l.size) { nil })
          else
            # should not happen:
            Assert.is_true(false, "Unhandled case") # $NON-NLS-1$
            return nil
          end
        end
      end
    end
    
    private
    alias_method :initialize__tree_selection, :initialize
  end
  
end
