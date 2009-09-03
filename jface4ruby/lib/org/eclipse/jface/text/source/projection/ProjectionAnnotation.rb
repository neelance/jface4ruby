require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module ProjectionAnnotationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Text::Source, :Annotation
      include_const ::Org::Eclipse::Jface::Text::Source, :IAnnotationPresentation
      include_const ::Org::Eclipse::Jface::Text::Source, :ImageUtilities
    }
  end
  
  # Annotation used to represent the projection of a master document onto a
  # {@link org.eclipse.jface.text.projection.ProjectionDocument}. A projection
  # annotation can be either expanded or collapsed. If expanded it corresponds to
  # a segment of the projection document. If collapsed, it represents a region of
  # the master document that does not have a corresponding segment in the
  # projection document.
  # <p>
  # Clients may subclass or use as is.
  # </p>
  # 
  # @since 3.0
  class ProjectionAnnotation < ProjectionAnnotationImports.const_get :Annotation
    include_class_members ProjectionAnnotationImports
    overload_protected {
      include IAnnotationPresentation
    }
    
    class_module.module_eval {
      const_set_lazy(:DisplayDisposeRunnable) { Class.new do
        include_class_members ProjectionAnnotation
        include Runnable
        
        typesig { [] }
        def run
          if (!(self.attr_fg_collapsed_image).nil?)
            self.attr_fg_collapsed_image.dispose
            self.attr_fg_collapsed_image = nil
          end
          if (!(self.attr_fg_expanded_image).nil?)
            self.attr_fg_expanded_image.dispose
            self.attr_fg_expanded_image = nil
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__display_dispose_runnable, :initialize
      end }
      
      # The type of projection annotations.
      const_set_lazy(:TYPE) { "org.eclipse.projection" }
      const_attr_reader  :TYPE
      
      # $NON-NLS-1$
      const_set_lazy(:COLOR) { SWT::COLOR_GRAY }
      const_attr_reader  :COLOR
      
      
      def fg_collapsed_image
        defined?(@@fg_collapsed_image) ? @@fg_collapsed_image : @@fg_collapsed_image= nil
      end
      alias_method :attr_fg_collapsed_image, :fg_collapsed_image
      
      def fg_collapsed_image=(value)
        @@fg_collapsed_image = value
      end
      alias_method :attr_fg_collapsed_image=, :fg_collapsed_image=
      
      
      def fg_expanded_image
        defined?(@@fg_expanded_image) ? @@fg_expanded_image : @@fg_expanded_image= nil
      end
      alias_method :attr_fg_expanded_image, :fg_expanded_image
      
      def fg_expanded_image=(value)
        @@fg_expanded_image = value
      end
      alias_method :attr_fg_expanded_image=, :fg_expanded_image=
    }
    
    # The state of this annotation
    attr_accessor :f_is_collapsed
    alias_method :attr_f_is_collapsed, :f_is_collapsed
    undef_method :f_is_collapsed
    alias_method :attr_f_is_collapsed=, :f_is_collapsed=
    undef_method :f_is_collapsed=
    
    # Indicates whether this annotation should be painted as range
    attr_accessor :f_is_range_indication
    alias_method :attr_f_is_range_indication, :f_is_range_indication
    undef_method :f_is_range_indication
    alias_method :attr_f_is_range_indication=, :f_is_range_indication=
    undef_method :f_is_range_indication=
    
    typesig { [] }
    # Creates a new expanded projection annotation.
    def initialize
      initialize__projection_annotation(false)
    end
    
    typesig { [::Java::Boolean] }
    # Creates a new projection annotation. When <code>isCollapsed</code>
    # is <code>true</code> the annotation is initially collapsed.
    # 
    # @param isCollapsed <code>true</code> if the annotation should initially be collapsed, <code>false</code> otherwise
    def initialize(is_collapsed)
      @f_is_collapsed = false
      @f_is_range_indication = false
      super(TYPE, false, nil)
      @f_is_collapsed = false
      @f_is_range_indication = false
      @f_is_collapsed = is_collapsed
    end
    
    typesig { [::Java::Boolean] }
    # Enables and disables the range indication for this annotation.
    # 
    # @param rangeIndication the enable state for the range indication
    def set_range_indication(range_indication)
      @f_is_range_indication = range_indication
    end
    
    typesig { [GC, Canvas, Rectangle] }
    def draw_range_indication(gc, canvas, r)
      margin = 3
      # cap the height - at least on GTK, large numbers are converted to
      # negatives at some point
      height = Math.min(r.attr_y + r.attr_height - margin, canvas.get_size.attr_y)
      gc.set_foreground(canvas.get_display.get_system_color(COLOR))
      gc.set_line_width(0) # NOTE: 0 means width is 1 but with optimized performance
      gc.draw_line(r.attr_x + 4, r.attr_y + 12, r.attr_x + 4, height)
      gc.draw_line(r.attr_x + 4, height, r.attr_x + r.attr_width - margin, height)
    end
    
    typesig { [GC, Canvas, Rectangle] }
    # @see org.eclipse.jface.text.source.IAnnotationPresentation#paint(org.eclipse.swt.graphics.GC, org.eclipse.swt.widgets.Canvas, org.eclipse.swt.graphics.Rectangle)
    def paint(gc, canvas, rectangle)
      image = get_image(canvas.get_display)
      if (!(image).nil?)
        ImageUtilities.draw_image(image, gc, canvas, rectangle, SWT::CENTER, SWT::TOP)
        if (@f_is_range_indication)
          font_metrics = gc.get_font_metrics
          delta = (font_metrics.get_height - image.get_bounds.attr_height) / 2
          rectangle.attr_y += delta
          rectangle.attr_height -= delta
          draw_range_indication(gc, canvas, rectangle)
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IAnnotationPresentation#getLayer()
    def get_layer
      return IAnnotationPresentation::DEFAULT_LAYER
    end
    
    typesig { [Display] }
    def get_image(display)
      initialize_images(display)
      return is_collapsed ? self.attr_fg_collapsed_image : self.attr_fg_expanded_image
    end
    
    typesig { [Display] }
    def initialize_images(display)
      if ((self.attr_fg_collapsed_image).nil?)
        descriptor = ImageDescriptor.create_from_file(ProjectionAnnotation, "images/collapsed.gif") # $NON-NLS-1$
        self.attr_fg_collapsed_image = descriptor.create_image(display)
        descriptor = ImageDescriptor.create_from_file(ProjectionAnnotation, "images/expanded.gif") # $NON-NLS-1$
        self.attr_fg_expanded_image = descriptor.create_image(display)
        display.dispose_exec(DisplayDisposeRunnable.new)
      end
    end
    
    typesig { [] }
    # Returns the state of this annotation.
    # 
    # @return <code>true</code> if collapsed
    def is_collapsed
      return @f_is_collapsed
    end
    
    typesig { [] }
    # Marks this annotation as being collapsed.
    def mark_collapsed
      @f_is_collapsed = true
    end
    
    typesig { [] }
    # Marks this annotation as being unfolded.
    def mark_expanded
      @f_is_collapsed = false
    end
    
    private
    alias_method :initialize__projection_annotation, :initialize
  end
  
end
