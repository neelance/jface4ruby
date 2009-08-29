require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module URLImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Runtime, :FileLocator
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Path
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Internal, :InternalPolicy
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
    }
  end
  
  # An ImageDescriptor that gets its information from a URL. This class is not
  # public API. Use ImageDescriptor#createFromURL to create a descriptor that
  # uses a URL.
  class URLImageDescriptor < URLImageDescriptorImports.const_get :ImageDescriptor
    include_class_members URLImageDescriptorImports
    
    class_module.module_eval {
      # Constant for the file protocol for optimized loading
      const_set_lazy(:FILE_PROTOCOL) { "file" }
      const_attr_reader  :FILE_PROTOCOL
    }
    
    # $NON-NLS-1$
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    typesig { [URL] }
    # Creates a new URLImageDescriptor.
    # 
    # @param url
    # The URL to load the image from. Must be non-null.
    def initialize(url)
      @url = nil
      super()
      @url = url
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on Object.
    def ==(o)
      if (!(o.is_a?(URLImageDescriptor)))
        return false
      end
      return ((o).attr_url == @url)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on ImageDesciptor. Returns null if the
    # image data cannot be read.
    def get_image_data
      result = nil
      in_ = get_stream
      if (!(in_).nil?)
        begin
          result = ImageData.new(in_)
        rescue SWTException => e
          if (!(e.attr_code).equal?(SWT::ERROR_INVALID_IMAGE))
            raise e
            # fall through otherwise
          end
        ensure
          begin
            in_.close
          rescue IOException => e
            Policy.get_log.log(Status.new(IStatus::ERROR, Policy::JFACE, e.get_localized_message, e))
          end
        end
      end
      return result
    end
    
    typesig { [] }
    # Returns a stream on the image contents. Returns null if a stream could
    # not be opened.
    # 
    # @return the stream for loading the data
    def get_stream
      begin
        return BufferedInputStream.new(@url.open_stream)
      rescue IOException => e
        return nil
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Object.
    def hash_code
      return @url.hash_code
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Object.
    # 
    # 
    # The <code>URLImageDescriptor</code> implementation of this
    # <code>Object</code> method returns a string representation of this
    # object which is suitable only for debugging.
    def to_s
      return "URLImageDescriptor(" + RJava.cast_to_string(@url) + ")" # $NON-NLS-1$ //$NON-NLS-2$
    end
    
    typesig { [] }
    # Returns the filename for the ImageData.
    # 
    # @return {@link String} or <code>null</code> if the file cannot be found
    def get_file_path
      begin
        if (!InternalPolicy::OSGI_AVAILABLE)
          if (FILE_PROTOCOL.equals_ignore_case(@url.get_protocol))
            return Path.new(@url.get_file).to_osstring
          end
          return nil
        end
        located_url = FileLocator.to_file_url(@url)
        if (FILE_PROTOCOL.equals_ignore_case(located_url.get_protocol))
          return Path.new(located_url.get_path).to_osstring
        end
        return nil
      rescue IOException => e
        Policy.log_exception(e)
        return nil
      end
    end
    
    typesig { [::Java::Boolean, Device] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.resource.ImageDescriptor#createImage(boolean,
    # org.eclipse.swt.graphics.Device)
    def create_image(return_missing_image_on_error, device)
      # Try to see if we can optimize using SWTs file based image support.
      path = get_file_path
      if ((path).nil?)
        return super(return_missing_image_on_error, device)
      end
      begin
        return Image.new(device, path)
      rescue SWTException => exception
        # If we fail fall back to the slower input stream method.
      end
      return super(return_missing_image_on_error, device)
    end
    
    private
    alias_method :initialize__urlimage_descriptor, :initialize
  end
  
end
