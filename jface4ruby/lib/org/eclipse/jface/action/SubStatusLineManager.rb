require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module SubStatusLineManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # A <code>SubStatusLineManager</code> is used to define a set of contribution
  # items within a parent manager.  Once defined, the visibility of the entire set can
  # be changed as a unit.
  class SubStatusLineManager < SubStatusLineManagerImports.const_get :SubContributionManager
    include_class_members SubStatusLineManagerImports
    overload_protected {
      include IStatusLineManager
    }
    
    # Current status line message.
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # Current status line error message.
    attr_accessor :error_message
    alias_method :attr_error_message, :error_message
    undef_method :error_message
    alias_method :attr_error_message=, :error_message=
    undef_method :error_message=
    
    # Current status line message image.
    attr_accessor :message_image
    alias_method :attr_message_image, :message_image
    undef_method :message_image
    alias_method :attr_message_image=, :message_image=
    undef_method :message_image=
    
    # Current status line error image
    attr_accessor :error_image
    alias_method :attr_error_image, :error_image
    undef_method :error_image
    alias_method :attr_error_image=, :error_image=
    undef_method :error_image=
    
    typesig { [IStatusLineManager] }
    # Constructs a new manager.
    # 
    # @param mgr the parent manager.  All contributions made to the
    # <code>SubStatusLineManager</code> are forwarded and appear in the
    # parent manager.
    def initialize(mgr)
      @message = nil
      @error_message = nil
      @message_image = nil
      @error_image = nil
      super(mgr)
    end
    
    typesig { [] }
    # @return the parent status line manager that this sub-manager contributes
    # to
    def get_parent_status_line_manager
      # Cast is ok because that's the only
      # thing we accept in the construtor.
      return get_parent
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def get_progress_monitor
      return get_parent_status_line_manager.get_progress_monitor
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def is_cancel_enabled
      return get_parent_status_line_manager.is_cancel_enabled
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_cancel_enabled(enabled)
      get_parent_status_line_manager.set_cancel_enabled(enabled)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_error_message(message)
      @error_image = nil
      @error_message = message
      if (is_visible)
        get_parent_status_line_manager.set_error_message(@error_message)
      end
    end
    
    typesig { [Image, String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_error_message(image, message)
      @error_image = image
      @error_message = message
      if (is_visible)
        get_parent_status_line_manager.set_error_message(@error_image, @error_message)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_message(message)
      @message_image = nil
      @message = message
      if (is_visible)
        get_parent_status_line_manager.set_message(message)
      end
    end
    
    typesig { [Image, String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_message(image, message)
      @message_image = image
      @message = message
      if (is_visible)
        get_parent_status_line_manager.set_message(@message_image, message)
      end
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on SubContributionManager.
    def set_visible(visible)
      super(visible)
      if (visible)
        get_parent_status_line_manager.set_error_message(@error_image, @error_message)
        get_parent_status_line_manager.set_message(@message_image, @message)
      else
        get_parent_status_line_manager.set_message(nil, nil)
        get_parent_status_line_manager.set_error_message(nil, nil)
      end
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def update(force)
      # This method is not governed by visibility.  The client may
      # call <code>setVisible</code> and then force an update.  At that
      # point we need to update the parent.
      get_parent_status_line_manager.update(force)
    end
    
    private
    alias_method :initialize__sub_status_line_manager, :initialize
  end
  
end
