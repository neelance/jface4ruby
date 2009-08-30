require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module ToolBarManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Accessibility, :ACC
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleAdapter
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleEvent
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :CoolBar
      include_const ::Org::Eclipse::Swt::Widgets, :CoolItem
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
    }
  end
  
  # A tool bar manager is a contribution manager which realizes itself and its
  # items in a tool bar control.
  # <p>
  # This class may be instantiated; it may also be subclassed if a more
  # sophisticated layout is required.
  # </p>
  class ToolBarManager < ToolBarManagerImports.const_get :ContributionManager
    include_class_members ToolBarManagerImports
    overload_protected {
      include IToolBarManager
    }
    
    # The tool bar items style; <code>SWT.NONE</code> by default.
    attr_accessor :item_style
    alias_method :attr_item_style, :item_style
    undef_method :item_style
    alias_method :attr_item_style=, :item_style=
    undef_method :item_style=
    
    # The tool bat control; <code>null</code> before creation and after
    # disposal.
    attr_accessor :tool_bar
    alias_method :attr_tool_bar, :tool_bar
    undef_method :tool_bar
    alias_method :attr_tool_bar=, :tool_bar=
    undef_method :tool_bar=
    
    # The menu manager to the context menu associated with the toolbar.
    # 
    # @since 3.0
    attr_accessor :context_menu_manager
    alias_method :attr_context_menu_manager, :context_menu_manager
    undef_method :context_menu_manager
    alias_method :attr_context_menu_manager=, :context_menu_manager=
    undef_method :context_menu_manager=
    
    typesig { [] }
    # Creates a new tool bar manager with the default SWT button style. Use the
    # {@link #createControl(Composite)} method to create the tool bar control.
    def initialize
      @item_style = 0
      @tool_bar = nil
      @context_menu_manager = nil
      super()
      @item_style = SWT::NONE
      @tool_bar = nil
      @context_menu_manager = nil
      # Do nothing if there are no parameters
    end
    
    typesig { [::Java::Int] }
    # Creates a tool bar manager with the given SWT button style. Use the
    # <code>createControl</code> method to create the tool bar control.
    # 
    # @param style
    # the tool bar item style
    # @see org.eclipse.swt.widgets.ToolBar for valid style bits
    def initialize(style)
      @item_style = 0
      @tool_bar = nil
      @context_menu_manager = nil
      super()
      @item_style = SWT::NONE
      @tool_bar = nil
      @context_menu_manager = nil
      @item_style = style
    end
    
    typesig { [ToolBar] }
    # Creates a tool bar manager for an existing tool bar control. This manager
    # becomes responsible for the control, and will dispose of it when the
    # manager is disposed.
    # <strong>NOTE</strong> When creating a ToolBarManager from an existing
    # {@link ToolBar} you will not get the accessible listener provided by
    # JFace.
    # @see #ToolBarManager()
    # @see #ToolBarManager(int)
    # 
    # @param toolbar
    # the tool bar control
    def initialize(toolbar)
      initialize__tool_bar_manager()
      @tool_bar = toolbar
    end
    
    typesig { [Composite] }
    # Creates and returns this manager's tool bar control. Does not create a
    # new control if one already exists. Also create an {@link AccessibleListener}
    # for the {@link ToolBar}.
    # 
    # @param parent
    # the parent control
    # @return the tool bar control
    def create_control(parent)
      if (!tool_bar_exist && !(parent).nil?)
        @tool_bar = ToolBar.new(parent, @item_style)
        @tool_bar.set_menu(get_context_menu_control)
        update(true)
        @tool_bar.get_accessible.add_accessible_listener(get_accessible_listener)
      end
      return @tool_bar
    end
    
    typesig { [] }
    # Get the accessible listener for the tool bar.
    # 
    # @return AccessibleListener
    # 
    # @since 3.1
    def get_accessible_listener
      return Class.new(AccessibleAdapter.class == Class ? AccessibleAdapter : Object) do
        extend LocalClass
        include_class_members ToolBarManager
        include AccessibleAdapter if AccessibleAdapter.class == Module
        
        typesig { [AccessibleEvent] }
        define_method :get_name do |e|
          if (!(e.attr_child_id).equal?(ACC::CHILDID_SELF))
            item = self.attr_tool_bar.get_item(e.attr_child_id)
            if (!(item).nil?)
              tool_tip = item.get_tool_tip_text
              if (!(tool_tip).nil?)
                e.attr_result = tool_tip
              end
            end
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Disposes of this tool bar manager and frees all allocated SWT resources.
    # Notifies all contribution items of the dispose. Note that this method
    # does not clean up references between this tool bar manager and its
    # associated contribution items. Use <code>removeAll</code> for that
    # purpose.
    def dispose
      if (tool_bar_exist)
        @tool_bar.dispose
      end
      @tool_bar = nil
      items = get_items
      i = 0
      while i < items.attr_length
        items[i].dispose
        i += 1
      end
      if (!(get_context_menu_manager).nil?)
        get_context_menu_manager.dispose
        set_context_menu_manager(nil)
      end
    end
    
    typesig { [] }
    # Returns the tool bar control for this manager.
    # 
    # @return the tool bar control, or <code>null</code> if none (before
    # creating or after disposal)
    def get_control
      return @tool_bar
    end
    
    typesig { [ToolBar, ::Java::Int, ::Java::Int] }
    # Re-lays out the tool bar.
    # <p>
    # The default implementation of this framework method re-lays out the
    # parent when the number of items are different and the new count != 0
    # 
    # @param layoutBar
    # the tool bar control
    # @param oldCount
    # the old number of items
    # @param newCount
    # the new number of items
    def relayout(layout_bar, old_count, new_count)
      if ((!(old_count).equal?(new_count)) && (!(new_count).equal?(0)))
        before_pack = layout_bar.get_size
        layout_bar.pack(true)
        after_pack = layout_bar.get_size
        # If the TB didn't change size then we're done
        if ((before_pack == after_pack))
          return
        end
        # OK, we need to re-layout the TB
        layout_bar.get_parent.layout
        # Now, if we're in a CoolBar then change the CoolItem size as well
        if (layout_bar.get_parent.is_a?(CoolBar))
          cb = layout_bar.get_parent
          items = cb.get_items
          i = 0
          while i < items.attr_length
            if ((items[i].get_control).equal?(layout_bar))
              cur_size = items[i].get_size
              items[i].set_size(cur_size.attr_x + (after_pack.attr_x - before_pack.attr_x), cur_size.attr_y + (after_pack.attr_y - before_pack.attr_y))
              return
            end
            i += 1
          end
        end
      end
    end
    
    typesig { [] }
    # Returns whether the tool bar control is created and not disposed.
    # 
    # @return <code>true</code> if the control is created and not disposed,
    # <code>false</code> otherwise
    def tool_bar_exist
      return !(@tool_bar).nil? && !@tool_bar.is_disposed
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc) Method declared on IContributionManager.
    def update(force)
      # long startTime= 0;
      # if (DEBUG) {
      # dumpStatistics();
      # startTime= (new Date()).getTime();
      # }
      if (is_dirty || force)
        if (tool_bar_exist)
          old_count = @tool_bar.get_item_count
          # clean contains all active items without double separators
          items = get_items
          clean = ArrayList.new(items.attr_length)
          separator = nil
          # long cleanStartTime= 0;
          # if (DEBUG) {
          # cleanStartTime= (new Date()).getTime();
          # }
          i = 0
          while i < items.attr_length
            ci = items[i]
            if (!is_child_visible(ci))
              (i += 1)
              next
            end
            if (ci.is_separator)
              # delay creation until necessary
              # (handles both adjacent separators, and separator at
              # end)
              separator = ci
            else
              if (!(separator).nil?)
                if (clean.size > 0)
                  clean.add(separator)
                end
                separator = nil
              end
              clean.add(ci)
            end
            (i += 1)
          end
          # if (DEBUG) {
          # System.out.println(" Time needed to build clean vector: " +
          # ((new Date()).getTime() - cleanStartTime));
          # }
          # determine obsolete items (removed or non active)
          mi = @tool_bar.get_items
          to_remove = ArrayList.new(mi.attr_length)
          i_ = 0
          while i_ < mi.attr_length
            # there may be null items in a toolbar
            if ((mi[i_]).nil?)
              i_ += 1
              next
            end
            data = mi[i_].get_data
            if ((data).nil? || !clean.contains(data) || (data.is_a?(IContributionItem) && (data).is_dynamic))
              to_remove.add(mi[i_])
            end
            i_ += 1
          end
          # Turn redraw off if the number of items to be added
          # is above a certain threshold, to minimize flicker,
          # otherwise the toolbar can be seen to redraw after each item.
          # Do this before any modifications are made.
          # We assume each contribution item will contribute at least one
          # toolbar item.
          use_redraw = (clean.size - (mi.attr_length - to_remove.size)) >= 3
          begin
            if (use_redraw)
              @tool_bar.set_redraw(false)
            end
            # remove obsolete items
            i__ = to_remove.size
            while (i__ -= 1) >= 0
              item = to_remove.get(i__)
              if (!item.is_disposed)
                ctrl = item.get_control
                if (!(ctrl).nil?)
                  item.set_control(nil)
                  ctrl.dispose
                end
                item.dispose
              end
            end
            # add new items
            src = nil
            dest = nil
            mi = @tool_bar.get_items
            src_ix = 0
            dest_ix = 0
            e = clean.iterator
            while e.has_next
              src = e.next_
              # get corresponding item in SWT widget
              if (src_ix < mi.attr_length)
                dest = mi[src_ix].get_data
              else
                dest = nil
              end
              if (!(dest).nil? && (src == dest))
                src_ix += 1
                dest_ix += 1
                next
              end
              if (!(dest).nil? && dest.is_separator && src.is_separator)
                mi[src_ix].set_data(src)
                src_ix += 1
                dest_ix += 1
                next
              end
              start = @tool_bar.get_item_count
              src.fill(@tool_bar, dest_ix)
              new_items = @tool_bar.get_item_count - start
              i___ = 0
              while i___ < new_items
                item = @tool_bar.get_item(((dest_ix += 1) - 1))
                item.set_data(src)
                i___ += 1
              end
            end
            # remove any old tool items not accounted for
            i___ = mi.attr_length
            while (i___ -= 1) >= src_ix
              item = mi[i___]
              if (!item.is_disposed)
                ctrl = item.get_control
                if (!(ctrl).nil?)
                  item.set_control(nil)
                  ctrl.dispose
                end
                item.dispose
              end
            end
            set_dirty(false)
            # turn redraw back on if we turned it off above
          ensure
            if (use_redraw)
              @tool_bar.set_redraw(true)
            end
          end
          new_count = @tool_bar.get_item_count
          # If we're forcing a change then ensure that we re-layout everything
          if (force)
            old_count = new_count + 1
          end
          relayout(@tool_bar, old_count, new_count)
        end
      end
      # if (DEBUG) {
      # System.out.println(" Time needed for update: " + ((new
      # Date()).getTime() - startTime));
      # System.out.println();
      # }
    end
    
    typesig { [] }
    # Returns the control of the Menu Manager. If the menu manager does not
    # have a control then one is created.
    # 
    # @return menu widget associated with manager
    def get_context_menu_control
      if ((!(@context_menu_manager).nil?) && (!(@tool_bar).nil?))
        menu_widget = @context_menu_manager.get_menu
        if (((menu_widget).nil?) || (menu_widget.is_disposed))
          menu_widget = @context_menu_manager.create_context_menu(@tool_bar)
        end
        return menu_widget
      end
      return nil
    end
    
    typesig { [] }
    # Returns the context menu manager for this tool bar manager.
    # 
    # @return the context menu manager, or <code>null</code> if none
    # @since 3.0
    def get_context_menu_manager
      return @context_menu_manager
    end
    
    typesig { [MenuManager] }
    # Sets the context menu manager for this tool bar manager to the given menu
    # manager. If the tool bar control exists, it also adds the menu control to
    # the tool bar.
    # 
    # @param contextMenuManager
    # the context menu manager, or <code>null</code> if none
    # @since 3.0
    def set_context_menu_manager(context_menu_manager)
      @context_menu_manager = context_menu_manager
      if (!(@tool_bar).nil?)
        @tool_bar.set_menu(get_context_menu_control)
      end
    end
    
    typesig { [IContributionItem] }
    def is_child_visible(item)
      v = nil
      overrides = get_overrides
      if ((overrides).nil?)
        v = nil
      else
        v = get_overrides.get_visible(item)
      end
      if (!(v).nil?)
        return v.boolean_value
      end
      return item.is_visible
    end
    
    private
    alias_method :initialize__tool_bar_manager, :initialize
  end
  
end
