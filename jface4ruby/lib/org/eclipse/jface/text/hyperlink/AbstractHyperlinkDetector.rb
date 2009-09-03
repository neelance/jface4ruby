require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module AbstractHyperlinkDetectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IAdaptable
    }
  end
  
  # A hyperlink detector that can provide adapters through
  # a context that can be set by the creator of this hyperlink
  # detector.
  # <p>
  # Clients may subclass.
  # </p>
  # 
  # @since 3.3
  class AbstractHyperlinkDetector 
    include_class_members AbstractHyperlinkDetectorImports
    include IHyperlinkDetector
    include IHyperlinkDetectorExtension
    
    # The context of this hyperlink detector.
    attr_accessor :f_context
    alias_method :attr_f_context, :f_context
    undef_method :f_context
    alias_method :attr_f_context=, :f_context=
    undef_method :f_context=
    
    typesig { [IAdaptable] }
    # Sets this hyperlink detector's context which
    # is responsible to provide the adapters.
    # 
    # @param context the context for this hyperlink detector
    # @throws IllegalArgumentException if the context is <code>null</code>
    # @throws IllegalStateException if this method is called more than once
    def set_context(context)
      Assert.is_legal(!(context).nil?)
      if (!(@f_context).nil?)
        raise IllegalStateException.new
      end
      @f_context = context
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension#dispose()
    def dispose
      @f_context = nil
    end
    
    typesig { [Class] }
    # Returns an object which is an instance of the given class
    # and provides additional context for this hyperlink detector.
    # 
    # @param adapterClass the adapter class to look up
    # @return an instance that can be cast to the given class,
    # or <code>null</code> if this object does not
    # have an adapter for the given class
    def get_adapter(adapter_class)
      Assert.is_legal(!(adapter_class).nil?)
      if (!(@f_context).nil?)
        return @f_context.get_adapter(adapter_class)
      end
      return nil
    end
    
    typesig { [] }
    def initialize
      @f_context = nil
    end
    
    private
    alias_method :initialize__abstract_hyperlink_detector, :initialize
  end
  
end
