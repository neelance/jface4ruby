require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module ResourceManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt, :SWTException
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Device
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
    }
  end
  
  # This class manages SWT resources. It manages reference-counted instances of resources
  # such as Fonts, Images, and Colors, and allows them to be accessed using descriptors.
  # Everything allocated through the registry should also be disposed through the registry.
  # Since the resources are shared and reference counted, they should never be disposed
  # directly.
  # <p>
  # ResourceManager handles correct allocation and disposal of resources. It differs from
  # the various JFace *Registry classes, which also map symbolic IDs onto resources. In
  # general, you should use a *Registry class to map IDs onto descriptors, and use a
  # ResourceManager to convert the descriptors into real Images/Fonts/etc.
  # </p>
  # 
  # @since 3.1
  class ResourceManager 
    include_class_members ResourceManagerImports
    
    # List of Runnables scheduled to run when the ResourceManager is disposed.
    # null if empty.
    attr_accessor :dispose_execs
    alias_method :attr_dispose_execs, :dispose_execs
    undef_method :dispose_execs
    alias_method :attr_dispose_execs=, :dispose_execs=
    undef_method :dispose_execs=
    
    typesig { [] }
    # Returns the Device for which this ResourceManager will create resources
    # 
    # @since 3.1
    # 
    # @return the Device associated with this ResourceManager
    def get_device
      raise NotImplementedError
    end
    
    typesig { [DeviceResourceDescriptor] }
    # Returns the resource described by the given descriptor. If the resource already
    # exists, the reference count is incremented and the exiting resource is returned.
    # Otherwise, a new resource is allocated. Every call to this method should have
    # a corresponding call to {@link #destroy(DeviceResourceDescriptor)}.
    # 
    # <p>If the resource is intended to live for entire lifetime of the resource manager,
    # a subsequent call to {@link #destroy(DeviceResourceDescriptor)} may be omitted and the
    # resource will be cleaned up when the resource manager is disposed. This pattern
    # is useful for short-lived {@link LocalResourceManager}s, but should never be used
    # with the global resource manager since doing so effectively leaks the resource.</p>
    # 
    # <p>The resources returned from this method are reference counted and may be shared
    # internally with other resource managers. They should never be disposed outside of the
    # ResourceManager framework, or it will cause exceptions in other code that shares
    # them. For example, never call {@link org.eclipse.swt.graphics.Resource#dispose()}
    # on anything returned from this method.</p>
    # 
    # <p>Callers may safely downcast the result to the resource type associated with
    # the descriptor. For example, when given an ImageDescriptor, the return
    # value of this method will always be an Image.</p>
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor for the resource to allocate
    # @return the newly allocated resource (not null)
    # @throws DeviceResourceException if unable to allocate the resource
    def create(descriptor)
      raise NotImplementedError
    end
    
    typesig { [DeviceResourceDescriptor] }
    # Deallocates a resource previously allocated by {@link #create(DeviceResourceDescriptor)}.
    # Descriptors are compared by equality, not identity. If the same resource was
    # created multiple times, this may decrement a reference count rather than
    # disposing the actual resource.
    # 
    # @since 3.1
    # 
    # @param descriptor identifier for the resource
    def destroy(descriptor)
      raise NotImplementedError
    end
    
    typesig { [DeviceResourceDescriptor] }
    # <p>Returns a previously-allocated resource or allocates a new one if none
    # exists yet. The resource will remain allocated for at least the lifetime
    # of this resource manager. If necessary, the resource will be deallocated
    # automatically when the resource manager is disposed.</p>
    # 
    # <p>The resources returned from this method are reference counted and may be shared
    # internally with other resource managers. They should never be disposed outside of the
    # ResourceManager framework, or it will cause exceptions in other code that shares
    # them. For example, never call {@link org.eclipse.swt.graphics.Resource#dispose()}
    # on anything returned from this method.</p>
    # 
    # <p>
    # Callers may safely downcast the result to the resource type associated with
    # the descriptor. For example, when given an ImageDescriptor, the return
    # value of this method may be downcast to Image.
    # </p>
    # 
    # <p>
    # This method should only be used for resources that should remain
    # allocated for the lifetime of the resource manager. To allocate shorter-lived
    # resources, manage them with <code>create</code>, and <code>destroy</code>
    # rather than this method.
    # </p>
    # 
    # <p>
    # This method should never be called on the global resource manager,
    # since all resources will remain allocated for the lifetime of the app and
    # will be effectively leaked.
    # </p>
    # 
    # @param descriptor identifier for the requested resource
    # @return the requested resource. Never null.
    # @throws DeviceResourceException if the resource does not exist yet and cannot
    # be created for any reason.
    # 
    # @since 3.3
    def get(descriptor)
      result = find(descriptor)
      if ((result).nil?)
        result = create(descriptor)
      end
      return result
    end
    
    typesig { [ImageDescriptor] }
    # <p>Creates an image, given an image descriptor. Images allocated in this manner must
    # be disposed by {@link #destroyImage(ImageDescriptor)}, and never by calling
    # {@link Image#dispose()}.</p>
    # 
    # <p>
    # If the image is intended to remain allocated for the lifetime of the ResourceManager,
    # the call to destroyImage may be omitted and the image will be cleaned up automatically
    # when the ResourceManager is disposed. This should only be done with short-lived ResourceManagers,
    # as doing so with the global manager effectively leaks the resource.
    # </p>
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor for the image to create
    # @return the Image described by this descriptor (possibly shared by other equivalent
    # ImageDescriptors)
    # @throws DeviceResourceException if unable to allocate the Image
    def create_image(descriptor)
      # Assertion added to help diagnose client bugs.  See bug #83711 and bug #90454.
      Assert.is_not_null(descriptor)
      return create(descriptor)
    end
    
    typesig { [ImageDescriptor] }
    # Creates an image, given an image descriptor. Images allocated in this manner must
    # be disposed by {@link #destroyImage(ImageDescriptor)}, and never by calling
    # {@link Image#dispose()}.
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor for the image to create
    # @return the Image described by this descriptor (possibly shared by other equivalent
    # ImageDescriptors)
    def create_image_with_default(descriptor)
      if ((descriptor).nil?)
        return get_default_image
      end
      begin
        return create(descriptor)
      rescue DeviceResourceException => e
        # $NON-NLS-1$
        # $NON-NLS-1$
        Policy.get_log.log(Status.new(IStatus::WARNING, "org.eclipse.jface", 0, "The image could not be loaded: " + RJava.cast_to_string(descriptor), e))
        return get_default_image
      rescue SWTException => e
        # $NON-NLS-1$
        # $NON-NLS-1$
        Policy.get_log.log(Status.new(IStatus::WARNING, "org.eclipse.jface", 0, "The image could not be loaded: " + RJava.cast_to_string(descriptor), e))
        return get_default_image
      end
    end
    
    typesig { [] }
    # Returns the default image that will be returned in the event that the intended
    # image is missing.
    # 
    # @since 3.1
    # 
    # @return a default image that will be returned in the event that the intended
    # image is missing.
    def get_default_image
      raise NotImplementedError
    end
    
    typesig { [ImageDescriptor] }
    # Undoes everything that was done by {@link #createImage(ImageDescriptor)}.
    # 
    # @since 3.1
    # 
    # @param descriptor identifier for the image to dispose
    def destroy_image(descriptor)
      destroy(descriptor)
    end
    
    typesig { [ColorDescriptor] }
    # Allocates a color, given a color descriptor. Any color allocated in this
    # manner must be disposed by calling {@link #destroyColor(ColorDescriptor)},
    # or by an eventual call to {@link #dispose()}. {@link Color#dispose()} must
    # never been called directly on the returned color.
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor for the color to create
    # @return the Color described by the given ColorDescriptor (not null)
    # @throws DeviceResourceException if unable to create the color
    def create_color(descriptor)
      return create(descriptor)
    end
    
    typesig { [RGB] }
    # Allocates a color, given its RGB value. Any color allocated in this
    # manner must be disposed by calling {@link #destroyColor(RGB)},
    # or by an eventual call to {@link #dispose()}. {@link Color#dispose()} must
    # never been called directly on the returned color.
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor for the color to create
    # @return the Color described by the given ColorDescriptor (not null)
    # @throws DeviceResourceException if unable to create the color
    def create_color(descriptor)
      return create_color(RGBColorDescriptor.new(descriptor))
    end
    
    typesig { [RGB] }
    # Undoes everything that was done by a call to {@link #createColor(RGB)}.
    # 
    # @since 3.1
    # 
    # @param descriptor RGB value of the color to dispose
    def destroy_color(descriptor)
      destroy_color(RGBColorDescriptor.new(descriptor))
    end
    
    typesig { [ColorDescriptor] }
    # Undoes everything that was done by a call to {@link #createColor(ColorDescriptor)}.
    # 
    # 
    # @since 3.1
    # 
    # @param descriptor identifier for the color to dispose
    def destroy_color(descriptor)
      destroy(descriptor)
    end
    
    typesig { [FontDescriptor] }
    # Returns the Font described by the given FontDescriptor. Any Font
    # allocated in this manner must be deallocated by calling disposeFont(...),
    # or by an eventual call to {@link #dispose()}.  The method {@link Font#dispose()}
    # must never be called directly on the returned font.
    # 
    # @since 3.1
    # 
    # @param descriptor description of the font to create
    # @return the Font described by the given descriptor
    # @throws DeviceResourceException if unable to create the font
    def create_font(descriptor)
      return create(descriptor)
    end
    
    typesig { [FontDescriptor] }
    # Undoes everything that was done by a previous call to {@link #createFont(FontDescriptor)}.
    # 
    # @since 3.1
    # 
    # @param descriptor description of the font to destroy
    def destroy_font(descriptor)
      destroy(descriptor)
    end
    
    typesig { [] }
    # Disposes any remaining resources allocated by this manager.
    def dispose
      if ((@dispose_execs).nil?)
        return
      end
      # If one of the runnables throws an exception, we need to propagate it.
      # However, this should not prevent the remaining runnables from being
      # notified. If any runnables throw an exception, we remember one of them
      # here and throw it at the end of the method.
      found_exception = nil
      execs = @dispose_execs.to_array(Array.typed(Runnable).new(@dispose_execs.size) { nil })
      i = 0
      while i < execs.attr_length
        exec = execs[i]
        begin
          exec.run
        rescue RuntimeException => e
          # Ensure that we propagate an exception, but don't stop notifying
          # the remaining runnables.
          found_exception = e
        end
        i += 1
      end
      if (!(found_exception).nil?)
        # If any runnables threw an exception, propagate one of them.
        raise found_exception
      end
    end
    
    typesig { [DeviceResourceDescriptor] }
    # Returns a previously allocated resource associated with the given descriptor, or
    # null if none exists yet.
    # 
    # @since 3.1
    # 
    # @param descriptor descriptor to find
    # @return a previously allocated resource for the given descriptor or null if none.
    def find(descriptor)
      raise NotImplementedError
    end
    
    typesig { [Runnable] }
    # Causes the <code>run()</code> method of the runnable to
    # be invoked just before the receiver is disposed. The runnable
    # can be subsequently canceled by a call to <code>cancelDisposeExec</code>.
    # 
    # @param r runnable to execute.
    def dispose_exec(r)
      Assert.is_not_null(r)
      if ((@dispose_execs).nil?)
        @dispose_execs = ArrayList.new
      end
      @dispose_execs.add(r)
    end
    
    typesig { [Runnable] }
    # Cancels a runnable that was previously scheduled with <code>disposeExec</code>.
    # Has no effect if the given runnable was not previously registered with
    # disposeExec.
    # 
    # @param r runnable to cancel
    def cancel_dispose_exec(r)
      Assert.is_not_null(r)
      if ((@dispose_execs).nil?)
        return
      end
      @dispose_execs.remove(r)
      if (@dispose_execs.is_empty)
        @dispose_execs = nil
      end
    end
    
    typesig { [] }
    def initialize
      @dispose_execs = nil
    end
    
    private
    alias_method :initialize__resource_manager, :initialize
  end
  
end
