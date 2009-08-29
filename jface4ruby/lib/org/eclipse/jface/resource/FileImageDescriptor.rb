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
  module FileImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Core::Runtime, :FileLocator
      include_const ::Org::Eclipse::Core::Runtime, :Path
      include_const ::Org::Eclipse::Jface::Internal, :InternalPolicy
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
    }
  end
  
  # An image descriptor that loads its image information from a file.
  class FileImageDescriptor < FileImageDescriptorImports.const_get :ImageDescriptor
    include_class_members FileImageDescriptorImports
    
    # The class whose resource directory contain the file, or <code>null</code>
    # if none.
    attr_accessor :location
    alias_method :attr_location, :location
    undef_method :location
    alias_method :attr_location=, :location=
    undef_method :location=
    
    # The name of the file.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [Class, String] }
    # Creates a new file image descriptor. The file has the given file name and
    # is located in the given class's resource directory. If the given class is
    # <code>null</code>, the file name must be absolute.
    # <p>
    # Note that the file is not accessed until its <code>getImageDate</code>
    # method is called.
    # </p>
    # 
    # @param clazz
    # class for resource directory, or <code>null</code>
    # @param filename
    # the name of the file
    def initialize(clazz, filename)
      @location = nil
      @name = nil
      super()
      @location = clazz
      @name = filename
    end
    
    typesig { [Object] }
    # (non-Javadoc) Method declared on Object.
    def ==(o)
      if (!(o.is_a?(FileImageDescriptor)))
        return false
      end
      other = o
      if (!(@location).nil?)
        if (!(@location == other.attr_location))
          return false
        end
      else
        if (!(other.attr_location).nil?)
          return false
        end
      end
      return (@name == other.attr_name)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.resource.ImageDescriptor#getImageData() The
    # FileImageDescriptor implementation of this method is not used by
    # {@link ImageDescriptor#createImage(boolean, Device)} as of version
    # 3.4 so that the SWT OS optimised loading can be used.
    def get_image_data
      in_ = get_stream
      result = nil
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
            # System.err.println(getClass().getName()+".getImageData():
            # "+
            # "Exception while closing InputStream : "+e);
          end
        end
      end
      return result
    end
    
    typesig { [] }
    # Returns a stream on the image contents. Returns null if a stream could
    # not be opened.
    # 
    # @return the buffered stream on the file or <code>null</code> if the
    # file cannot be found
    def get_stream
      is = nil
      if (!(@location).nil?)
        is = @location.get_resource_as_stream(@name)
      else
        begin
          is = FileInputStream.new(@name)
        rescue FileNotFoundException => e
          return nil
        end
      end
      if ((is).nil?)
        return nil
      end
      return BufferedInputStream.new(is)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Object.
    def hash_code
      code = @name.hash_code
      if (!(@location).nil?)
        code += @location.hash_code
      end
      return code
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Object.
    # 
    # 
    # The <code>FileImageDescriptor</code> implementation of this
    # <code>Object</code> method returns a string representation of this
    # object which is suitable only for debugging.
    def to_s
      return "FileImageDescriptor(location=" + RJava.cast_to_string(@location) + ", name=" + @name + ")" # $NON-NLS-3$//$NON-NLS-2$//$NON-NLS-1$
    end
    
    typesig { [::Java::Boolean, Device] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.resource.ImageDescriptor#createImage(boolean,
    # org.eclipse.swt.graphics.Device)
    def create_image(return_missing_image_on_error, device)
      path = get_file_path
      if ((path).nil?)
        return create_default_image(return_missing_image_on_error, device)
      end
      begin
        return Image.new(device, path)
      rescue SWTException => exception
        # if we fail try the default way using a stream
      end
      return super(return_missing_image_on_error, device)
    end
    
    typesig { [::Java::Boolean, Device] }
    # Return default image if returnMissingImageOnError is true.
    # 
    # @param device
    # @return Image or <code>null</code>
    def create_default_image(return_missing_image_on_error, device)
      begin
        if (return_missing_image_on_error)
          return Image.new(device, DEFAULT_IMAGE_DATA)
        end
      rescue SWTException => next_exception
        return nil
      end
      return nil
    end
    
    typesig { [] }
    # Returns the filename for the ImageData.
    # 
    # @return {@link String} or <code>null</code> if the file cannot be found
    def get_file_path
      if ((@location).nil?)
        return Path.new(@name).to_osstring
      end
      resource = @location.get_resource(@name)
      if ((resource).nil?)
        return nil
      end
      begin
        if (!InternalPolicy::OSGI_AVAILABLE)
          # Stand-alone case
          return Path.new(resource.get_file).to_osstring
        end
        return Path.new(FileLocator.to_file_url(resource).get_path).to_osstring
      rescue IOException => e
        Policy.log_exception(e)
        return nil
      end
    end
    
    private
    alias_method :initialize__file_image_descriptor, :initialize
  end
  
end
