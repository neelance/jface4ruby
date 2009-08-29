require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Wizard
  module WizardSelectionPageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
    }
  end
  
  # An abstract implementation of a wizard page that manages a
  # set of embedded wizards.
  # <p>
  # A wizard selection page should present a list of wizard nodes
  # corresponding to other wizards. When the end user selects one of
  # them from the list, the first page of the selected wizard becomes
  # the next page. The only new methods introduced by this class are
  # <code>getSelectedNode</code> and <code>setSelectedNode</code>.
  # Otherwise, the subclass contract is the same as <code>WizardPage</code>.
  # </p>
  class WizardSelectionPage < WizardSelectionPageImports.const_get :WizardPage
    include_class_members WizardSelectionPageImports
    
    # The selected node; <code>null</code> if none.
    attr_accessor :selected_node
    alias_method :attr_selected_node, :selected_node
    undef_method :selected_node
    alias_method :attr_selected_node=, :selected_node=
    undef_method :selected_node=
    
    # List of wizard nodes that have cropped up in the past
    # (element type: <code>IWizardNode</code>).
    attr_accessor :selected_wizard_nodes
    alias_method :attr_selected_wizard_nodes, :selected_wizard_nodes
    undef_method :selected_wizard_nodes
    alias_method :attr_selected_wizard_nodes=, :selected_wizard_nodes=
    undef_method :selected_wizard_nodes=
    
    typesig { [String] }
    # Creates a new wizard selection page with the given name, and
    # with no title or image.
    # 
    # @param pageName the name of the page
    def initialize(page_name)
      @selected_node = nil
      @selected_wizard_nodes = nil
      super(page_name)
      @selected_node = nil
      @selected_wizard_nodes = ArrayList.new
      # Cannot finish from this page
      set_page_complete(false)
    end
    
    typesig { [IWizardNode] }
    # Adds the given wizard node to the list of selected nodes if
    # it is not already in the list.
    # 
    # @param node the wizard node, or <code>null</code>
    def add_selected_node(node)
      if ((node).nil?)
        return
      end
      if (@selected_wizard_nodes.contains(node))
        return
      end
      @selected_wizard_nodes.add(node)
    end
    
    typesig { [] }
    # The <code>WizardSelectionPage</code> implementation of
    # this <code>IWizardPage</code> method returns <code>true</code>
    # if there is a selected node.
    def can_flip_to_next_page
      return !(@selected_node).nil?
    end
    
    typesig { [] }
    # The <code>WizardSelectionPage</code> implementation of an <code>IDialogPage</code>
    # method disposes of all nested wizards. Subclasses may extend.
    def dispose
      super
      # notify nested wizards
      i = 0
      while i < @selected_wizard_nodes.size
        (@selected_wizard_nodes.get(i)).dispose
        i += 1
      end
    end
    
    typesig { [] }
    # The <code>WizardSelectionPage</code> implementation of
    # this <code>IWizardPage</code> method returns the first page
    # of the currently selected wizard if there is one.
    def get_next_page
      if ((@selected_node).nil?)
        return nil
      end
      is_created = @selected_node.is_content_created
      wizard = @selected_node.get_wizard
      if ((wizard).nil?)
        set_selected_node(nil)
        return nil
      end
      if (!is_created)
        # Allow the wizard to create its pages
        wizard.add_pages
      end
      return wizard.get_starting_page
    end
    
    typesig { [] }
    # Returns the currently selected wizard node within this page.
    # 
    # @return the wizard node, or <code>null</code> if no node is selected
    def get_selected_node
      return @selected_node
    end
    
    typesig { [IWizardNode] }
    # Sets or clears the currently selected wizard node within this page.
    # 
    # @param node the wizard node, or <code>null</code> to clear
    def set_selected_node(node)
      add_selected_node(node)
      @selected_node = node
      if (is_current_page)
        get_container.update_buttons
      end
    end
    
    private
    alias_method :initialize__wizard_selection_page, :initialize
  end
  
end
