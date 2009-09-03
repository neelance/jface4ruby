require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sebastian Davids: sdavids@gmx.de - see bug 25376
module Org::Eclipse::Jface::Text::Templates
  module GlobalTemplateVariablesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Com::Ibm::Icu::Text, :DateFormat
      include_const ::Com::Ibm::Icu::Util, :Calendar
    }
  end
  
  # Global variables which are available in any context.
  # <p>
  # Clients may instantiate the classes contained within this class.
  # </p>
  # 
  # @since 3.0
  class GlobalTemplateVariables 
    include_class_members GlobalTemplateVariablesImports
    
    class_module.module_eval {
      # The type of the selection variables.
      const_set_lazy(:SELECTION) { "selection" }
      const_attr_reader  :SELECTION
      
      # $NON-NLS-1$
      # 
      # The cursor variable determines the cursor placement after template edition.
      const_set_lazy(:Cursor) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        class_module.module_eval {
          # Name of the cursor variable, value= {@value}
          const_set_lazy(:NAME) { "cursor" }
          const_attr_reader  :NAME
        }
        
        typesig { [] }
        # $NON-NLS-1$
        # 
        # Creates a new cursor variable
        def initialize
          super(self.class::NAME, TextTemplateMessages.get_string("GlobalVariables.variable.description.cursor")) # $NON-NLS-1$
          set_evaluation_string("") # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__cursor, :initialize
      end }
      
      # The word selection variable determines templates that work on a full
      # lines selection.
      const_set_lazy(:WordSelection) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        class_module.module_eval {
          # Name of the word selection variable, value= {@value}
          const_set_lazy(:NAME) { "word_selection" }
          const_attr_reader  :NAME
        }
        
        typesig { [] }
        # $NON-NLS-1$
        # 
        # Creates a new word selection variable
        def initialize
          super(self.class::NAME, TextTemplateMessages.get_string("GlobalVariables.variable.description.selectedWord")) # $NON-NLS-1$
        end
        
        typesig { [class_self::TemplateContext] }
        def resolve(context)
          selection = context.get_variable(SELECTION)
          if ((selection).nil?)
            return ""
          end # $NON-NLS-1$
          return selection
        end
        
        private
        alias_method :initialize__word_selection, :initialize
      end }
      
      # The line selection variable determines templates that work on selected
      # lines.
      const_set_lazy(:LineSelection) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        class_module.module_eval {
          # Name of the line selection variable, value= {@value}
          const_set_lazy(:NAME) { "line_selection" }
          const_attr_reader  :NAME
        }
        
        typesig { [] }
        # $NON-NLS-1$
        # 
        # Creates a new line selection variable
        def initialize
          super(self.class::NAME, TextTemplateMessages.get_string("GlobalVariables.variable.description.selectedLines")) # $NON-NLS-1$
        end
        
        typesig { [class_self::TemplateContext] }
        def resolve(context)
          selection = context.get_variable(SELECTION)
          if ((selection).nil?)
            return ""
          end # $NON-NLS-1$
          return selection
        end
        
        private
        alias_method :initialize__line_selection, :initialize
      end }
      
      # The dollar variable inserts an escaped dollar symbol.
      const_set_lazy(:Dollar) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        typesig { [] }
        # Creates a new dollar variable
        def initialize
          super("dollar", TextTemplateMessages.get_string("GlobalVariables.variable.description.dollar")) # $NON-NLS-1$ //$NON-NLS-2$
          set_evaluation_string("$") # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__dollar, :initialize
      end }
      
      # The date variable evaluates to the current date.
      const_set_lazy(:JavaDate) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        typesig { [] }
        # Creates a new date variable
        def initialize
          super("date", TextTemplateMessages.get_string("GlobalVariables.variable.description.date")) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        typesig { [class_self::TemplateContext] }
        def resolve(context)
          return DateFormat.get_date_instance.format(Java::Util::JavaDate.new)
        end
        
        private
        alias_method :initialize__date, :initialize
      end }
      
      # The year variable evaluates to the current year.
      const_set_lazy(:Year) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        typesig { [] }
        # Creates a new year variable
        def initialize
          super("year", TextTemplateMessages.get_string("GlobalVariables.variable.description.year")) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        typesig { [class_self::TemplateContext] }
        def resolve(context)
          return JavaInteger.to_s(Calendar.get_instance.get(Calendar::YEAR))
        end
        
        private
        alias_method :initialize__year, :initialize
      end }
      
      # The time variable evaluates to the current time.
      const_set_lazy(:Time) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        typesig { [] }
        # Creates a new time variable
        def initialize
          super("time", TextTemplateMessages.get_string("GlobalVariables.variable.description.time")) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        typesig { [class_self::TemplateContext] }
        # {@inheritDoc}
        def resolve(context)
          return DateFormat.get_time_instance.format(Java::Util::JavaDate.new)
        end
        
        private
        alias_method :initialize__time, :initialize
      end }
      
      # The user variable evaluates to the current user.
      const_set_lazy(:User) { Class.new(SimpleTemplateVariableResolver) do
        include_class_members GlobalTemplateVariables
        
        typesig { [] }
        # Creates a new user name variable
        def initialize
          super("user", TextTemplateMessages.get_string("GlobalVariables.variable.description.user")) # $NON-NLS-1$ //$NON-NLS-2$
        end
        
        typesig { [class_self::TemplateContext] }
        # {@inheritDoc}
        def resolve(context)
          return System.get_property("user.name") # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__user, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__global_template_variables, :initialize
  end
  
end
