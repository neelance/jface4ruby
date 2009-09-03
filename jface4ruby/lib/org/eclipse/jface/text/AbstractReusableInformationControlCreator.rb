require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AbstractReusableInformationControlCreatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # Abstract class for a reusable information control creators.
  # 
  # @since 3.3
  class AbstractReusableInformationControlCreator 
    include_class_members AbstractReusableInformationControlCreatorImports
    include IInformationControlCreator
    include IInformationControlCreatorExtension
    include DisposeListener
    
    attr_accessor :f_information_controls
    alias_method :attr_f_information_controls, :f_information_controls
    undef_method :f_information_controls
    alias_method :attr_f_information_controls=, :f_information_controls=
    undef_method :f_information_controls=
    
    typesig { [Shell] }
    # Creates the control.
    # 
    # @param parent the parent shell
    # @return the created information control
    def do_create_information_control(parent)
      raise NotImplementedError
    end
    
    typesig { [Shell] }
    # @see org.eclipse.jface.text.IInformationControlCreator#createInformationControl(org.eclipse.swt.widgets.Shell)
    def create_information_control(parent)
      control = @f_information_controls.get(parent)
      if ((control).nil?)
        control = do_create_information_control(parent)
        control.add_dispose_listener(self)
        @f_information_controls.put(parent, control)
      end
      return control
    end
    
    typesig { [DisposeEvent] }
    # @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
    def widget_disposed(e)
      parent = nil
      if (e.attr_widget.is_a?(Shell))
        parent = (e.attr_widget).get_parent
      end
      if (parent.is_a?(Shell))
        @f_information_controls.remove(parent)
      end
    end
    
    typesig { [IInformationControl] }
    # @see org.eclipse.jface.text.IInformationControlCreatorExtension#canReuse(org.eclipse.jface.text.IInformationControl)
    def can_reuse(control)
      return @f_information_controls.contains_value(control)
    end
    
    typesig { [IInformationControlCreator] }
    # @see org.eclipse.jface.text.IInformationControlCreatorExtension#canReplace(org.eclipse.jface.text.IInformationControlCreator)
    def can_replace(creator)
      return (creator.get_class).equal?(get_class)
    end
    
    typesig { [] }
    def initialize
      @f_information_controls = HashMap.new
    end
    
    private
    alias_method :initialize__abstract_reusable_information_control_creator, :initialize
  end
  
end
