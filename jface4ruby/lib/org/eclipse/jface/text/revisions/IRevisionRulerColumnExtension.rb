require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Revisions
  module IRevisionRulerColumnExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
    }
  end
  
  # Extension interface for {@link IRevisionRulerColumn}.
  # <p>
  # Introduces the ability to register a selection listener on revisions and configurable rendering
  # modes.
  # </p>
  # 
  # @see IRevisionRulerColumn
  # @since 3.3
  module IRevisionRulerColumnExtension
    include_class_members IRevisionRulerColumnExtensionImports
    
    class_module.module_eval {
      # Rendering mode type-safe enum.
      const_set_lazy(:RenderingMode) { Class.new do
        local_class_in IRevisionRulerColumnExtension
        include_class_members IRevisionRulerColumnExtension
        
        attr_accessor :f_name
        alias_method :attr_f_name, :f_name
        undef_method :f_name
        alias_method :attr_f_name=, :f_name=
        undef_method :f_name=
        
        typesig { [String] }
        def initialize(name)
          @f_name = nil
          Assert.is_legal(!(name).nil?)
          @f_name = name
        end
        
        typesig { [] }
        # Returns the name of the rendering mode.
        # @return the name of the rendering mode
        def name
          return @f_name
        end
        
        private
        alias_method :initialize__rendering_mode, :initialize
      end }
      
      # Rendering mode that assigns a unique color to each revision author.
      const_set_lazy(:AUTHOR) { RenderingMode.new_local(self, "Author") }
      const_attr_reader  :AUTHOR
      
      # $NON-NLS-1$
      # 
      # Rendering mode that assigns colors to revisions by their age.
      # <p>
      # Currently the most recent revision is red, the oldest is a faint yellow.
      # The coloring scheme can change in future releases.
      # </p>
      const_set_lazy(:AGE) { RenderingMode.new_local(self, "Age") }
      const_attr_reader  :AGE
      
      # $NON-NLS-1$
      # 
      # Rendering mode that assigns unique colors per revision author and
      # uses different color intensity depending on the age.
      # <p>
      # Currently it selects lighter colors for older revisions and more intense
      # colors for more recent revisions.
      # The coloring scheme can change in future releases.
      # </p>
      const_set_lazy(:AUTHOR_SHADED_BY_AGE) { RenderingMode.new_local(self, "Both") }
      const_attr_reader  :AUTHOR_SHADED_BY_AGE
    }
    
    typesig { [RenderingMode] }
    # $NON-NLS-1$
    # 
    # Changes the rendering mode and triggers redrawing if needed.
    # 
    # @param mode the rendering mode
    def set_revision_rendering_mode(mode)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables showing the revision id.
    # 
    # @param show <code>true</code> to show the revision, <code>false</code> to hide it
    def show_revision_id(show)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables showing the revision author.
    # 
    # @param show <code>true</code> to show the author, <code>false</code> to hide it
    def show_revision_author(show)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the revision selection provider.
    # 
    # @return the revision selection provider
    def get_revision_selection_provider
      raise NotImplementedError
    end
    
    typesig { [IRevisionListener] }
    # Adds a revision listener that will be notified when the displayed revision information
    # changes.
    # 
    # @param listener the listener to add
    def add_revision_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IRevisionListener] }
    # Removes a previously registered revision listener; nothing happens if <code>listener</code>
    # was not registered with the receiver.
    # 
    # @param listener the listener to remove
    def remove_revision_listener(listener)
      raise NotImplementedError
    end
  end
  
end
