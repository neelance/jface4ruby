require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module StatusLineContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CLabel
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Label
    }
  end
  
  # A contribution item to be used with status line managers.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # 
  # @since 3.4
  class StatusLineContributionItem < StatusLineContributionItemImports.const_get :ContributionItem
    include_class_members StatusLineContributionItemImports
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_CHAR_WIDTH) { 40 }
      const_attr_reader  :DEFAULT_CHAR_WIDTH
    }
    
    attr_accessor :char_width
    alias_method :attr_char_width, :char_width
    undef_method :char_width
    alias_method :attr_char_width=, :char_width=
    undef_method :char_width=
    
    attr_accessor :label
    alias_method :attr_label, :label
    undef_method :label
    alias_method :attr_label=, :label=
    undef_method :label=
    
    # The composite into which this contribution item has been placed. This
    # will be <code>null</code> if this instance has not yet been
    # initialized.
    attr_accessor :status_line
    alias_method :attr_status_line, :status_line
    undef_method :status_line
    alias_method :attr_status_line=, :status_line=
    undef_method :status_line=
    
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    attr_accessor :width_hint
    alias_method :attr_width_hint, :width_hint
    undef_method :width_hint
    alias_method :attr_width_hint=, :width_hint=
    undef_method :width_hint=
    
    attr_accessor :height_hint
    alias_method :attr_height_hint, :height_hint
    undef_method :height_hint
    alias_method :attr_height_hint=, :height_hint=
    undef_method :height_hint=
    
    typesig { [String] }
    # Creates a status line contribution item with the given id.
    # 
    # @param id
    # the contribution item's id, or <code>null</code> if it is to
    # have no id
    def initialize(id)
      initialize__status_line_contribution_item(id, DEFAULT_CHAR_WIDTH)
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a status line contribution item with the given id that displays
    # the given number of characters.
    # 
    # @param id
    # the contribution item's id, or <code>null</code> if it is to
    # have no id
    # @param charWidth
    # the number of characters to display
    def initialize(id, char_width)
      @char_width = 0
      @label = nil
      @status_line = nil
      @text = nil
      @width_hint = 0
      @height_hint = 0
      super(id)
      @status_line = nil
      @text = Util::ZERO_LENGTH_STRING
      @width_hint = -1
      @height_hint = -1
      @char_width = char_width
      set_visible(false) # no text to start with
    end
    
    typesig { [Composite] }
    def fill(parent)
      @status_line = parent
      sep = Label.new(parent, SWT::SEPARATOR)
      @label = CLabel.new(@status_line, SWT::SHADOW_NONE)
      if (@width_hint < 0)
        gc = GC.new(@status_line)
        gc.set_font(@status_line.get_font)
        fm = gc.get_font_metrics
        @width_hint = fm.get_average_char_width * @char_width
        @height_hint = fm.get_height
        gc.dispose
      end
      data = StatusLineLayoutData.new
      data.attr_width_hint = @width_hint
      @label.set_layout_data(data)
      @label.set_text(@text)
      data = StatusLineLayoutData.new
      data.attr_height_hint = @height_hint
      sep.set_layout_data(data)
    end
    
    typesig { [] }
    # An accessor for the current location of this status line contribution
    # item -- relative to the display.
    # 
    # @return The current location of this status line; <code>null</code> if
    # not yet initialized.
    def get_display_location
      if ((!(@label).nil?) && (!(@status_line).nil?))
        return @status_line.to_display(@label.get_location)
      end
      return nil
    end
    
    typesig { [] }
    # Retrieves the text that is being displayed in the status line.
    # 
    # @return the text that is currently being displayed
    def get_text
      return @text
    end
    
    typesig { [String] }
    # Sets the text to be displayed in the status line.
    # 
    # @param text
    # the text to be displayed, must not be <code>null</code>
    def set_text(text)
      Assert.is_not_null(text)
      @text = escape(text)
      if (!(@label).nil? && !@label.is_disposed)
        @label.set_text(@text)
      end
      if ((@text.length).equal?(0))
        if (is_visible)
          set_visible(false)
          contribution_manager = get_parent
          if (!(contribution_manager).nil?)
            contribution_manager.update(true)
          end
        end
      else
        if (!is_visible)
          set_visible(true)
          contribution_manager = get_parent
          if (!(contribution_manager).nil?)
            contribution_manager.update(true)
          end
        end
      end
    end
    
    typesig { [String] }
    def escape(text)
      return Util.replace_all(text, "&", "&&") # $NON-NLS-1$//$NON-NLS-2$
    end
    
    private
    alias_method :initialize__status_line_contribution_item, :initialize
  end
  
end
