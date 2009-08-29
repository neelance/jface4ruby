require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module LocalSelectionTransferImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Swt::Dnd, :ByteArrayTransfer
      include_const ::Org::Eclipse::Swt::Dnd, :TransferData
    }
  end
  
  # A LocalSelectionTransfer may be used for drag and drop operations
  # within the same instance of Eclipse.
  # The selection is made available directly for use in the DropTargetListener.
  # dropAccept method. The DropTargetEvent passed to dropAccept does not contain
  # the drop data. The selection may be used for validation purposes so that the
  # drop can be aborted if appropriate.
  # 
  # This class is not intended to be subclassed.
  # 
  # @since 3.2
  class LocalSelectionTransfer < LocalSelectionTransferImports.const_get :ByteArrayTransfer
    include_class_members LocalSelectionTransferImports
    
    class_module.module_eval {
      # First attempt to create a UUID for the type name to make sure that
      # different Eclipse applications use different "types" of
      # <code>LocalSelectionTransfer</code>
      const_set_lazy(:TYPE_NAME) { "local-selection-transfer-format" + RJava.cast_to_string((Long.new(System.current_time_millis)).to_s) }
      const_attr_reader  :TYPE_NAME
      
      # $NON-NLS-1$;
      const_set_lazy(:TYPEID) { register_type(TYPE_NAME) }
      const_attr_reader  :TYPEID
      
      const_set_lazy(:INSTANCE) { LocalSelectionTransfer.new }
      const_attr_reader  :INSTANCE
    }
    
    attr_accessor :selection
    alias_method :attr_selection, :selection
    undef_method :selection
    alias_method :attr_selection=, :selection=
    undef_method :selection=
    
    attr_accessor :selection_set_time
    alias_method :attr_selection_set_time, :selection_set_time
    undef_method :selection_set_time
    alias_method :attr_selection_set_time=, :selection_set_time=
    undef_method :selection_set_time=
    
    typesig { [] }
    # Only the singleton instance of this class may be used.
    def initialize
      @selection = nil
      @selection_set_time = 0
      super()
      # do nothing
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the singleton.
      # 
      # @return the singleton
      def get_transfer
        return INSTANCE
      end
    }
    
    typesig { [] }
    # Returns the local transfer data.
    # 
    # @return the local transfer data
    def get_selection
      return @selection
    end
    
    typesig { [Object] }
    # Tests whether native drop data matches this transfer type.
    # 
    # @param result result of converting the native drop data to Java
    # @return true if the native drop data does not match this transfer type.
    # false otherwise.
    def is_invalid_native_type(result)
      return !(result.is_a?(Array.typed(::Java::Byte))) || !(TYPE_NAME == String.new(result))
    end
    
    typesig { [] }
    # Returns the type id used to identify this transfer.
    # 
    # @return the type id used to identify this transfer.
    def get_type_ids
      return Array.typed(::Java::Int).new([TYPEID])
    end
    
    typesig { [] }
    # Returns the type name used to identify this transfer.
    # 
    # @return the type name used to identify this transfer.
    def get_type_names
      return Array.typed(String).new([TYPE_NAME])
    end
    
    typesig { [Object, TransferData] }
    # Overrides org.eclipse.swt.dnd.ByteArrayTransfer#javaToNative(Object,
    # TransferData).
    # Only encode the transfer type name since the selection is read and
    # written in the same process.
    # 
    # @see org.eclipse.swt.dnd.ByteArrayTransfer#javaToNative(java.lang.Object, org.eclipse.swt.dnd.TransferData)
    def java_to_native(object, transfer_data)
      check = TYPE_NAME.get_bytes
      super(check, transfer_data)
    end
    
    typesig { [TransferData] }
    # Overrides org.eclipse.swt.dnd.ByteArrayTransfer#nativeToJava(TransferData).
    # Test if the native drop data matches this transfer type.
    # 
    # @see org.eclipse.swt.dnd.ByteArrayTransfer#nativeToJava(TransferData)
    def native_to_java(transfer_data)
      result = super(transfer_data)
      if (is_invalid_native_type(result))
        Policy.get_log.log(Status.new(IStatus::ERROR, Policy::JFACE, IStatus::ERROR, JFaceResources.get_string("LocalSelectionTransfer.errorMessage"), nil)) # $NON-NLS-1$
      end
      return @selection
    end
    
    typesig { [ISelection] }
    # Sets the transfer data for local use.
    # 
    # @param s the transfer data
    def set_selection(s)
      @selection = s
    end
    
    typesig { [] }
    # Returns the time when the selection operation
    # this transfer is associated with was started.
    # 
    # @return the time when the selection operation has started
    # 
    # @see org.eclipse.swt.events.TypedEvent#time
    def get_selection_set_time
      return @selection_set_time
    end
    
    typesig { [::Java::Long] }
    # Sets the time when the selection operation this
    # transfer is associated with was started.
    # If assigning this from an SWT event, be sure to use
    # <code>setSelectionTime(event.time & 0xFFFF)</code>
    # 
    # @param time the time when the selection operation was started
    # 
    # @see org.eclipse.swt.events.TypedEvent#time
    def set_selection_set_time(time)
      @selection_set_time = time
    end
    
    private
    alias_method :initialize__local_selection_transfer, :initialize
  end
  
end
