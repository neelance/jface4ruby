require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module ToolBarContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Jface::Internal::Provisional::Action, :IToolBarContributionItem
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :CoolItem
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # The <code>ToolBarContributionItem</code> class provides a wrapper for tool
  # bar managers when used in cool bar managers. It extends <code>ContributionItem</code>
  # but and provides some additional methods to customize the size of the cool
  # item and to retrieve the underlying tool bar manager.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class ToolBarContributionItem < ToolBarContributionItemImports.const_get :ContributionItem
    include_class_members ToolBarContributionItemImports
    overload_protected {
      include IToolBarContributionItem
    }
    
    class_module.module_eval {
      # A constant used by <code>setMinimumItemsToShow</code> and <code>getMinimumItemsToShow</code>
      # to indicate that all tool items should be shown in the cool item.
      const_set_lazy(:SHOW_ALL_ITEMS) { -1 }
      const_attr_reader  :SHOW_ALL_ITEMS
    }
    
    # The pull down menu used to list all hidden tool items if the current
    # size is less than the preffered size.
    attr_accessor :chevron_menu_manager
    alias_method :attr_chevron_menu_manager, :chevron_menu_manager
    undef_method :chevron_menu_manager
    alias_method :attr_chevron_menu_manager=, :chevron_menu_manager=
    undef_method :chevron_menu_manager=
    
    # The widget created for this item; <code>null</code> before creation
    # and after disposal.
    attr_accessor :cool_item
    alias_method :attr_cool_item, :cool_item
    undef_method :cool_item
    alias_method :attr_cool_item=, :cool_item=
    undef_method :cool_item=
    
    # Current height of cool item
    attr_accessor :current_height
    alias_method :attr_current_height, :current_height
    undef_method :current_height
    alias_method :attr_current_height=, :current_height=
    undef_method :current_height=
    
    # Current width of cool item.
    attr_accessor :current_width
    alias_method :attr_current_width, :current_width
    undef_method :current_width
    alias_method :attr_current_width=, :current_width=
    undef_method :current_width=
    
    # A flag indicating that this item has been disposed. This prevents future
    # method invocations from doing things they shouldn't.
    attr_accessor :disposed
    alias_method :attr_disposed, :disposed
    undef_method :disposed
    alias_method :attr_disposed=, :disposed=
    undef_method :disposed=
    
    # Mininum number of tool items to show in the cool item widget.
    attr_accessor :minimum_items_to_show
    alias_method :attr_minimum_items_to_show, :minimum_items_to_show
    undef_method :minimum_items_to_show
    alias_method :attr_minimum_items_to_show=, :minimum_items_to_show=
    undef_method :minimum_items_to_show=
    
    # The tool bar manager used to manage the tool items contained in the cool
    # item widget.
    attr_accessor :tool_bar_manager
    alias_method :attr_tool_bar_manager, :tool_bar_manager
    undef_method :tool_bar_manager
    alias_method :attr_tool_bar_manager=, :tool_bar_manager=
    undef_method :tool_bar_manager=
    
    # Enable/disable chevron support.
    attr_accessor :use_chevron
    alias_method :attr_use_chevron, :use_chevron
    undef_method :use_chevron
    alias_method :attr_use_chevron=, :use_chevron=
    undef_method :use_chevron=
    
    typesig { [] }
    # Convenience method equivalent to <code>ToolBarContributionItem(new ToolBarManager(), null)</code>.
    def initialize
      initialize__tool_bar_contribution_item(ToolBarManager.new, nil)
    end
    
    typesig { [IToolBarManager] }
    # Convenience method equivalent to <code>ToolBarContributionItem(toolBarManager, null)</code>.
    # 
    # @param toolBarManager
    # the tool bar manager
    def initialize(tool_bar_manager)
      initialize__tool_bar_contribution_item(tool_bar_manager, nil)
    end
    
    typesig { [IToolBarManager, String] }
    # Creates a tool bar contribution item.
    # 
    # @param toolBarManager
    # the tool bar manager to wrap
    # @param id
    # the contribution item id, or <code>null</code> if none
    def initialize(tool_bar_manager, id)
      @chevron_menu_manager = nil
      @cool_item = nil
      @current_height = 0
      @current_width = 0
      @disposed = false
      @minimum_items_to_show = 0
      @tool_bar_manager = nil
      @use_chevron = false
      super(id)
      @chevron_menu_manager = nil
      @cool_item = nil
      @current_height = -1
      @current_width = -1
      @disposed = false
      @minimum_items_to_show = SHOW_ALL_ITEMS
      @tool_bar_manager = nil
      @use_chevron = true
      Assert.is_true(tool_bar_manager.is_a?(ToolBarManager))
      @tool_bar_manager = tool_bar_manager
    end
    
    typesig { [] }
    # Checks whether this contribution item has been disposed. If it has, and
    # the tracing options are active, then it prints some debugging
    # information.
    # 
    # @return <code>true</code> if the item is disposed; <code>false</code>
    # otherwise.
    def check_disposed
      if (@disposed)
        if (Policy::TRACE_TOOLBAR)
          System.out.println("Method invocation on a disposed tool bar contribution item.") # $NON-NLS-1$
          JavaException.new.print_stack_trace(System.out)
        end
        return true
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.IContributionItem#dispose()
    def dispose
      # Dispose of the ToolBar and all its contributions
      if (!(@tool_bar_manager).nil?)
        @tool_bar_manager.dispose
        @tool_bar_manager = nil
      end
      # We need to dispose the cool item or we might be left holding a cool
      # item with a disposed control.
      if ((!(@cool_item).nil?) && (!@cool_item.is_disposed))
        @cool_item.dispose
        @cool_item = nil
      end
      # Mark this item as disposed.
      @disposed = true
    end
    
    typesig { [CoolBar, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.IContributionItem#fill(org.eclipse.swt.widgets.CoolBar,
    # int)
    def fill(cool_bar, index)
      if (check_disposed)
        return
      end
      if ((@cool_item).nil? && !(cool_bar).nil?)
        old_tool_bar = @tool_bar_manager.get_control
        tool_bar = @tool_bar_manager.create_control(cool_bar)
        if ((!(old_tool_bar).nil?) && ((old_tool_bar == tool_bar)))
          # We are using an old tool bar, so we need to update.
          @tool_bar_manager.update(true)
        end
        # Do not create a coolItem if the toolbar is empty
        if (tool_bar.get_item_count < 1)
          return
        end
        flags = SWT::DROP_DOWN
        if (index >= 0)
          @cool_item = CoolItem.new(cool_bar, flags, index)
        else
          @cool_item = CoolItem.new(cool_bar, flags)
        end
        # sets the back reference
        @cool_item.set_data(self)
        # Add the toolbar to the CoolItem widget
        @cool_item.set_control(tool_bar)
        # Handle Context Menu
        # ToolBarManager.createControl can actually return a pre-existing control.
        # Only add the listener if the toolbar was newly created (bug 62097).
        if (!(old_tool_bar).equal?(tool_bar))
          tool_bar.add_listener(SWT::MenuDetect, Class.new(Listener.class == Class ? Listener : Object) do
            extend LocalClass
            include_class_members ToolBarContributionItem
            include Listener if Listener.class == Module
            
            typesig { [Event] }
            define_method :handle_event do |event|
              # if the toolbar does not have its own context menu then
              # handle the event
              if ((self.attr_tool_bar_manager.get_context_menu_manager).nil?)
                handle_context_menu(event)
              end
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        # Handle for chevron clicking
        if (get_use_chevron)
          @cool_item.add_selection_listener(# Chevron Support
          Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
            extend LocalClass
            include_class_members ToolBarContributionItem
            include SelectionAdapter if SelectionAdapter.class == Module
            
            typesig { [SelectionEvent] }
            define_method :widget_selected do |event|
              if ((event.attr_detail).equal?(SWT::ARROW))
                handle_chevron(event)
              end
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        @cool_item.add_dispose_listener(# Handle for disposal
        Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members ToolBarContributionItem
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            handle_widget_dispose(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # Sets the size of the coolItem
        update_size(true)
      end
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Returns a consistent set of wrap indices. The return value will always
    # include at least one entry and the first entry will always be zero.
    # CoolBar.getWrapIndices() is inconsistent in whether or not it returns an
    # index for the first row.
    def get_adjusted_wrap_indices(wraps)
      adjusted_wrap_indices = nil
      if ((wraps.attr_length).equal?(0))
        adjusted_wrap_indices = Array.typed(::Java::Int).new([0])
      else
        if (!(wraps[0]).equal?(0))
          adjusted_wrap_indices = Array.typed(::Java::Int).new(wraps.attr_length + 1) { 0 }
          adjusted_wrap_indices[0] = 0
          i = 0
          while i < wraps.attr_length
            adjusted_wrap_indices[i + 1] = wraps[i]
            i += 1
          end
        else
          adjusted_wrap_indices = wraps
        end
      end
      return adjusted_wrap_indices
    end
    
    typesig { [] }
    # Returns the current height of the corresponding cool item.
    # 
    # @return the current height
    def get_current_height
      if (check_disposed)
        return -1
      end
      return @current_height
    end
    
    typesig { [] }
    # Returns the current width of the corresponding cool item.
    # 
    # @return the current size
    def get_current_width
      if (check_disposed)
        return -1
      end
      return @current_width
    end
    
    typesig { [] }
    # Returns the minimum number of tool items to show in the cool item.
    # 
    # @return the minimum number of tool items to show, or <code>SHOW_ALL_ITEMS</code>
    # if a value was not set
    # @see #setMinimumItemsToShow(int)
    def get_minimum_items_to_show
      if (check_disposed)
        return -1
      end
      return @minimum_items_to_show
    end
    
    typesig { [] }
    # Returns the internal tool bar manager of the contribution item.
    # 
    # @return the tool bar manager, or <code>null</code> if one is not
    # defined.
    # @see IToolBarManager
    def get_tool_bar_manager
      if (check_disposed)
        return nil
      end
      return @tool_bar_manager
    end
    
    typesig { [] }
    # Returns whether chevron support is enabled.
    # 
    # @return <code>true</code> if chevron support is enabled, <code>false</code>
    # otherwise
    def get_use_chevron
      if (check_disposed)
        return false
      end
      return @use_chevron
    end
    
    typesig { [SelectionEvent] }
    # Create and display the chevron menu.
    def handle_chevron(event)
      item = event.attr_widget
      control = item.get_control
      if (((control.is_a?(ToolBar))).equal?(false))
        return
      end
      cool_bar = item.get_parent
      tool_bar = control
      tool_bar_bounds = tool_bar.get_bounds
      items = tool_bar.get_items
      hidden = ArrayList.new
      i = 0
      while i < items.attr_length
        item_bounds = items[i].get_bounds
        if (!((item_bounds.attr_x + item_bounds.attr_width <= tool_bar_bounds.attr_width) && (item_bounds.attr_y + item_bounds.attr_height <= tool_bar_bounds.attr_height)))
          hidden.add(items[i])
        end
        (i += 1)
      end
      # Create a pop-up menu with items for each of the hidden buttons.
      if (!(@chevron_menu_manager).nil?)
        @chevron_menu_manager.dispose
      end
      @chevron_menu_manager = MenuManager.new
      i_ = hidden.iterator
      while i_.has_next
        tool_item = i_.next_
        data = tool_item.get_data
        if (data.is_a?(ActionContributionItem))
          contribution = ActionContributionItem.new((data).get_action)
          @chevron_menu_manager.add(contribution)
        else
          if (data.is_a?(SubContributionItem))
            inner_data = (data).get_inner_item
            if (inner_data.is_a?(ActionContributionItem))
              contribution = ActionContributionItem.new((inner_data).get_action)
              @chevron_menu_manager.add(contribution)
            end
          else
            if (data.is_separator)
              @chevron_menu_manager.add(Separator.new)
            end
          end
        end
      end
      popup = @chevron_menu_manager.create_context_menu(cool_bar)
      chevron_position = cool_bar.to_display(event.attr_x, event.attr_y)
      popup.set_location(chevron_position.attr_x, chevron_position.attr_y)
      popup.set_visible(true)
    end
    
    typesig { [Event] }
    # Handles the event when the toobar item does not have its own context
    # menu.
    # 
    # @param event
    # the event object
    def handle_context_menu(event)
      tool_bar = @tool_bar_manager.get_control
      # If parent has a menu then use that one
      parent_menu = tool_bar.get_parent.get_menu
      if ((!(parent_menu).nil?) && (!parent_menu.is_disposed))
        tool_bar.set_menu(parent_menu)
        parent_menu.add_listener(SWT::Hide, # Hook listener to remove menu once it has disapeared
        Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members ToolBarContributionItem
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |inner_event|
            inner_tool_bar = self.attr_tool_bar_manager.get_control
            if (!(inner_tool_bar).nil?)
              inner_tool_bar.set_menu(nil)
              inner_parent_menu = inner_tool_bar.get_parent.get_menu
              if (!(inner_parent_menu).nil?)
                inner_parent_menu.remove_listener(SWT::Hide, self)
              end
            end
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [DisposeEvent] }
    # Handles the disposal of the widget.
    # 
    # @param event
    # the event object
    def handle_widget_dispose(event)
      @cool_item = nil
    end
    
    typesig { [] }
    # A contribution item is visible iff its internal state is visible <em>or</em>
    # the tool bar manager contains something other than group markers and
    # separators.
    # 
    # @return <code>true</code> if the tool bar manager contains something
    # other than group marks and separators, and the internal state is
    # set to be visible.
    def is_visible
      if (check_disposed)
        return false
      end
      visible_item = false
      if (!(@tool_bar_manager).nil?)
        contribution_items = @tool_bar_manager.get_items
        i = 0
        while i < contribution_items.attr_length
          contribution_item = contribution_items[i]
          if ((!contribution_item.is_group_marker) && (!contribution_item.is_separator))
            visible_item = true
            break
          end
          i += 1
        end
      end
      return (visible_item || super)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.IContributionItem#saveWidgetState()
    def save_widget_state
      if (check_disposed)
        return
      end
      if ((@cool_item).nil?)
        return
      end
      # 1. Save current size
      cool_bar = @cool_item.get_parent
      is_last_on_row = false
      last_index = cool_bar.get_item_count - 1
      cool_item_index = cool_bar.index_of(@cool_item)
      wrap_indicies = get_adjusted_wrap_indices(cool_bar.get_wrap_indices)
      # Traverse through all wrap indicies backwards
      row = wrap_indicies.attr_length - 1
      while row >= 0
        if (wrap_indicies[row] <= cool_item_index)
          next_row = row + 1
          next_row_start_index = 0
          if (next_row > (wrap_indicies.attr_length - 1))
            next_row_start_index = last_index + 1
          else
            next_row_start_index = wrap_indicies[next_row]
          end
          # Check to see if its the last item on the row
          if ((cool_item_index).equal?((next_row_start_index - 1)))
            is_last_on_row = true
          end
          break
        end
        row -= 1
      end
      # Save the preferred size as actual size for the last item on a row
      n_current_width = 0
      if (is_last_on_row)
        n_current_width = @cool_item.get_preferred_size.attr_x
      else
        n_current_width = @cool_item.get_size.attr_x
      end
      set_current_width(n_current_width)
      set_current_height(@cool_item.get_size.attr_y)
    end
    
    typesig { [::Java::Int] }
    # Sets the current height of the cool item. Update(SIZE) should be called
    # to adjust the widget.
    # 
    # @param currentHeight
    # the current height to set
    def set_current_height(current_height)
      if (check_disposed)
        return
      end
      @current_height = current_height
    end
    
    typesig { [::Java::Int] }
    # Sets the current width of the cool item. Update(SIZE) should be called
    # to adjust the widget.
    # 
    # @param currentWidth
    # the current width to set
    def set_current_width(current_width)
      if (check_disposed)
        return
      end
      @current_width = current_width
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of tool items to show in the cool item. If this
    # number is less than the total tool items, a chevron will appear and the
    # hidden tool items appear in a drop down menu. By default, all the tool
    # items are shown in the cool item.
    # 
    # @param minimumItemsToShow
    # the minimum number of tool items to show.
    # @see #getMinimumItemsToShow()
    # @see #setUseChevron(boolean)
    def set_minimum_items_to_show(minimum_items_to_show)
      if (check_disposed)
        return
      end
      @minimum_items_to_show = minimum_items_to_show
    end
    
    typesig { [::Java::Boolean] }
    # Enables or disables chevron support for the cool item. By default,
    # chevron support is enabled.
    # 
    # @param value
    # <code>true</code> to enable chevron support, <code>false</code>
    # otherwise.
    def set_use_chevron(value)
      if (check_disposed)
        return
      end
      @use_chevron = value
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.IContributionItem#update(java.lang.String)
    def update(property_name)
      if (check_disposed)
        return
      end
      if (!(@cool_item).nil?)
        manager = get_tool_bar_manager
        if (!(manager).nil?)
          manager.update(true)
        end
        if (((property_name).nil?) || (property_name == ICoolBarManager::SIZE))
          update_size(true)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Updates the cool items' preferred, minimum, and current size. The
    # preferred size is calculated based on the tool bar size and extra trim.
    # 
    # @param changeCurrentSize
    # <code>true</code> if the current size should be changed to
    # the preferred size, <code>false</code> to not change the
    # current size
    def update_size(change_current_size)
      if (check_disposed)
        return
      end
      # cannot set size if coolItem is null
      if ((@cool_item).nil? || @cool_item.is_disposed)
        return
      end
      locked = false
      cool_bar = @cool_item.get_parent
      begin
        # Fix odd behaviour with locked tool bars
        if (!(cool_bar).nil?)
          if (cool_bar.get_locked)
            cool_bar.set_locked(false)
            locked = true
          end
        end
        tool_bar = @cool_item.get_control
        if (((tool_bar).nil?) || (tool_bar.is_disposed) || (tool_bar.get_item_count <= 0))
          # if the toolbar does not contain any items then dispose of
          # coolItem
          @cool_item.set_data(nil)
          control = @cool_item.get_control
          if ((!(control).nil?) && !control.is_disposed)
            control.dispose
            @cool_item.set_control(nil)
          end
          if (!@cool_item.is_disposed)
            @cool_item.dispose
          end
        else
          # If the toolbar item exists then adjust the size of the cool
          # item
          tool_bar_size = tool_bar.compute_size(SWT::DEFAULT, SWT::DEFAULT)
          # Set the preffered size to the size of the toolbar plus trim
          preferred_size = @cool_item.compute_size(tool_bar_size.attr_x, tool_bar_size.attr_y)
          @cool_item.set_preferred_size(preferred_size)
          # note setMinimumSize must be called before setSize, see PR
          # 15565
          # Set minimum size
          if (!(get_minimum_items_to_show).equal?(SHOW_ALL_ITEMS))
            tool_item_width = tool_bar.get_items[0].get_width
            minimum_width = tool_item_width * get_minimum_items_to_show
            @cool_item.set_minimum_size(minimum_width, tool_bar_size.attr_y)
          else
            @cool_item.set_minimum_size(tool_bar_size.attr_x, tool_bar_size.attr_y)
          end
          if (change_current_size)
            # Set current size to preferred size
            @cool_item.set_size(preferred_size)
          end
        end
      ensure
        # If the cool bar was locked, then set it back to locked
        if ((locked) && (!(cool_bar).nil?))
          cool_bar.set_locked(true)
        end
      end
    end
    
    private
    alias_method :initialize__tool_bar_contribution_item, :initialize
  end
  
end
