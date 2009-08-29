require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Window
  module WindowManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Window
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A manager for a group of windows. Window managers are an optional JFace
  # feature used in applications which create many different windows (dialogs,
  # wizards, etc.) in addition to a main window. A window manager can be used to
  # remember all the windows that an application has created (independent of
  # whether they are presently open or closed). There can be several window
  # managers, and they can be arranged into a tree. This kind of organization
  # makes it simple to close whole subgroupings of windows.
  # <p>
  # Creating a window manager is as simple as creating an instance of
  # <code>WindowManager</code>. Associating a window with a window manager is
  # done with <code>WindowManager.add(Window)</code>. A window is automatically
  # removed from its window manager as a side effect of closing the window.
  # </p>
  # 
  # @see Window
  class WindowManager 
    include_class_members WindowManagerImports
    
    # List of windows managed by this window manager
    # (element type: <code>Window</code>).
    attr_accessor :windows
    alias_method :attr_windows, :windows
    undef_method :windows
    alias_method :attr_windows=, :windows=
    undef_method :windows=
    
    # List of window managers who have this window manager
    # as their parent (element type: <code>WindowManager</code>).
    attr_accessor :sub_managers
    alias_method :attr_sub_managers, :sub_managers
    undef_method :sub_managers
    alias_method :attr_sub_managers=, :sub_managers=
    undef_method :sub_managers=
    
    typesig { [] }
    # Creates an empty window manager without a parent window
    # manager (that is, a root window manager).
    def initialize
      @windows = ArrayList.new
      @sub_managers = nil
    end
    
    typesig { [WindowManager] }
    # Creates an empty window manager with the given
    # window manager as parent.
    # 
    # @param parent the parent window manager
    def initialize(parent)
      @windows = ArrayList.new
      @sub_managers = nil
      Assert.is_not_null(parent)
      parent.add_window_manager(self)
    end
    
    typesig { [Window] }
    # Adds the given window to the set of windows managed by
    # this window manager. Does nothing is this window is
    # already managed by this window manager.
    # 
    # @param window the window
    def add(window)
      if (!@windows.contains(window))
        @windows.add(window)
        window.set_window_manager(self)
      end
    end
    
    typesig { [WindowManager] }
    # Adds the given window manager to the list of
    # window managers that have this one as a parent.
    # </p>
    # @param wm the child window manager
    def add_window_manager(wm)
      if ((@sub_managers).nil?)
        @sub_managers = ArrayList.new
      end
      if (!@sub_managers.contains(wm))
        @sub_managers.add(wm)
      end
    end
    
    typesig { [] }
    # Attempts to close all windows managed by this window manager,
    # as well as windows managed by any descendent window managers.
    # 
    # @return <code>true</code> if all windows were sucessfully closed,
    # and <code>false</code> if any window refused to close
    def close
      t = @windows.clone # make iteration robust
      e = t.iterator
      while (e.has_next)
        window = e.next_
        closed = window.close
        if (!closed)
          return false
        end
      end
      if (!(@sub_managers).nil?)
        e = @sub_managers.iterator
        while (e.has_next)
          wm = e.next_
          closed = wm.close
          if (!closed)
            return false
          end
        end
      end
      return true
    end
    
    typesig { [] }
    # Returns this window manager's number of windows
    # 
    # @return the number of windows
    # @since 3.0
    def get_window_count
      return @windows.size
    end
    
    typesig { [] }
    # Returns this window manager's set of windows.
    # 
    # @return a possibly empty list of window
    def get_windows
      bs = Array.typed(Window).new(@windows.size) { nil }
      @windows.to_array(bs)
      return bs
    end
    
    typesig { [Window] }
    # Removes the given window from the set of windows managed by
    # this window manager. Does nothing is this window is
    # not managed by this window manager.
    # 
    # @param window the window
    def remove(window)
      if (@windows.contains(window))
        @windows.remove(window)
        window.set_window_manager(nil)
      end
    end
    
    private
    alias_method :initialize__window_manager, :initialize
  end
  
end
