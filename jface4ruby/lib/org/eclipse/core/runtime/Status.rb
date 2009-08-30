require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module StatusImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Org::Eclipse::Core::Internal::Runtime, :IRuntimeConstants
      include_const ::Org::Eclipse::Core::Internal::Runtime, :LocalizationUtils
    }
  end
  
  # A concrete status implementation, suitable either for
  # instantiating or subclassing.
  # <p>
  # This class can be used without OSGi running.
  # </p>
  class Status 
    include_class_members StatusImports
    include IStatus
    
    class_module.module_eval {
      # A standard OK status with an "ok"  message.
      # 
      # @since 3.0
      const_set_lazy(:OK_STATUS) { Status.new(OK, IRuntimeConstants::PI_RUNTIME, OK, LocalizationUtils.safe_localize("ok"), nil) }
      const_attr_reader  :OK_STATUS
      
      # $NON-NLS-1$
      # 
      # A standard CANCEL status with no message.
      # 
      # @since 3.0
      const_set_lazy(:CANCEL_STATUS) { Status.new(CANCEL, IRuntimeConstants::PI_RUNTIME, 1, "", nil) }
      const_attr_reader  :CANCEL_STATUS
    }
    
    # $NON-NLS-1$
    # 
    # The severity. One of
    # <ul>
    # <li><code>CANCEL</code></li>
    # <li><code>ERROR</code></li>
    # <li><code>WARNING</code></li>
    # <li><code>INFO</code></li>
    # <li>or <code>OK</code> (0)</li>
    # </ul>
    attr_accessor :severity
    alias_method :attr_severity, :severity
    undef_method :severity
    alias_method :attr_severity=, :severity=
    undef_method :severity=
    
    # Unique identifier of plug-in.
    attr_accessor :plugin_id
    alias_method :attr_plugin_id, :plugin_id
    undef_method :plugin_id
    alias_method :attr_plugin_id=, :plugin_id=
    undef_method :plugin_id=
    
    # Plug-in-specific status code.
    attr_accessor :code
    alias_method :attr_code, :code
    undef_method :code
    alias_method :attr_code=, :code=
    undef_method :code=
    
    # Message, localized to the current locale.
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # Wrapped exception, or <code>null</code> if none.
    attr_accessor :exception
    alias_method :attr_exception, :exception
    undef_method :exception
    alias_method :attr_exception=, :exception=
    undef_method :exception=
    
    class_module.module_eval {
      # Constant to avoid generating garbage.
      const_set_lazy(:TheEmptyStatusArray) { Array.typed(IStatus).new(0) { nil } }
      const_attr_reader  :TheEmptyStatusArray
    }
    
    typesig { [::Java::Int, String, ::Java::Int, String, JavaThrowable] }
    # Creates a new status object.  The created status has no children.
    # 
    # @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
    # <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
    # @param pluginId the unique identifier of the relevant plug-in
    # @param code the plug-in-specific status code, or <code>OK</code>
    # @param message a human-readable message, localized to the
    # current locale
    # @param exception a low-level exception, or <code>null</code> if not
    # applicable
    def initialize(severity, plugin_id, code, message, exception)
      @severity = OK
      @plugin_id = nil
      @code = 0
      @message = nil
      @exception = nil
      set_severity(severity)
      set_plugin(plugin_id)
      set_code(code)
      set_message(message)
      set_exception(exception)
    end
    
    typesig { [::Java::Int, String, String, JavaThrowable] }
    # Simplified constructor of a new status object; assumes that code is <code>OK</code>.
    # The created status has no children.
    # 
    # @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
    # <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
    # @param pluginId the unique identifier of the relevant plug-in
    # @param message a human-readable message, localized to the
    # current locale
    # @param exception a low-level exception, or <code>null</code> if not
    # applicable
    # 
    # @since org.eclipse.equinox.common 3.3
    def initialize(severity, plugin_id, message, exception)
      @severity = OK
      @plugin_id = nil
      @code = 0
      @message = nil
      @exception = nil
      set_severity(severity)
      set_plugin(plugin_id)
      set_message(message)
      set_exception(exception)
      set_code(OK)
    end
    
    typesig { [::Java::Int, String, String] }
    # Simplified constructor of a new status object; assumes that code is <code>OK</code> and
    # exception is <code>null</code>. The created status has no children.
    # 
    # @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
    # <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
    # @param pluginId the unique identifier of the relevant plug-in
    # @param message a human-readable message, localized to the
    # current locale
    # 
    # @since org.eclipse.equinox.common 3.3
    def initialize(severity, plugin_id, message)
      @severity = OK
      @plugin_id = nil
      @code = 0
      @message = nil
      @exception = nil
      set_severity(severity)
      set_plugin(plugin_id)
      set_message(message)
      set_code(OK)
      set_exception(nil)
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_children
      return TheEmptyStatusArray
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_code
      return @code
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_exception
      return @exception
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_message
      return @message
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_plugin
      return @plugin_id
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def get_severity
      return @severity
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def is_multi_status
      return false
    end
    
    typesig { [] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def is_ok
      return (@severity).equal?(OK)
    end
    
    typesig { [::Java::Int] }
    # (Intentionally not javadoc'd)
    # Implements the corresponding method on <code>IStatus</code>.
    def matches(severity_mask)
      return !((@severity & severity_mask)).equal?(0)
    end
    
    typesig { [::Java::Int] }
    # Sets the status code.
    # 
    # @param code the plug-in-specific status code, or <code>OK</code>
    def set_code(code)
      @code = code
    end
    
    typesig { [JavaThrowable] }
    # Sets the exception.
    # 
    # @param exception a low-level exception, or <code>null</code> if not
    # applicable
    def set_exception(exception)
      @exception = exception
    end
    
    typesig { [String] }
    # Sets the message. If null is passed, message is set to an empty
    # string.
    # 
    # @param message a human-readable message, localized to the
    # current locale
    def set_message(message)
      if ((message).nil?)
        @message = ""
         # $NON-NLS-1$
      else
        @message = message
      end
    end
    
    typesig { [String] }
    # Sets the plug-in id.
    # 
    # @param pluginId the unique identifier of the relevant plug-in
    def set_plugin(plugin_id)
      Assert.is_legal(!(plugin_id).nil? && plugin_id.length > 0)
      @plugin_id = plugin_id
    end
    
    typesig { [::Java::Int] }
    # Sets the severity.
    # 
    # @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
    # <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
    def set_severity(severity)
      Assert.is_legal((severity).equal?(OK) || (severity).equal?(ERROR) || (severity).equal?(WARNING) || (severity).equal?(INFO) || (severity).equal?(CANCEL))
      @severity = severity
    end
    
    typesig { [] }
    # Returns a string representation of the status, suitable
    # for debugging purposes only.
    def to_s
      buf = StringBuffer.new
      buf.append("Status ") # $NON-NLS-1$
      if ((@severity).equal?(OK))
        buf.append("OK") # $NON-NLS-1$
      else
        if ((@severity).equal?(ERROR))
          buf.append("ERROR") # $NON-NLS-1$
        else
          if ((@severity).equal?(WARNING))
            buf.append("WARNING") # $NON-NLS-1$
          else
            if ((@severity).equal?(INFO))
              buf.append("INFO") # $NON-NLS-1$
            else
              if ((@severity).equal?(CANCEL))
                buf.append("CANCEL") # $NON-NLS-1$
              else
                buf.append("severity=") # $NON-NLS-1$
                buf.append(@severity)
              end
            end
          end
        end
      end
      buf.append(": ") # $NON-NLS-1$
      buf.append(@plugin_id)
      buf.append(" code=") # $NON-NLS-1$
      buf.append(@code)
      buf.append(Character.new(?\s.ord))
      buf.append(@message)
      buf.append(Character.new(?\s.ord))
      buf.append(@exception)
      return buf.to_s
    end
    
    private
    alias_method :initialize__status, :initialize
  end
  
end
