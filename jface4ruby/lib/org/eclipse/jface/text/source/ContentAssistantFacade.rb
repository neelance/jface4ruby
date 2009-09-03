require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ContentAssistantFacadeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Core::Commands, :IHandler
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionListener
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistantExtension2
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistantExtension4
    }
  end
  
  # Facade to allow minimal access to the given content assistant.
  # <p>
  # The offered API access can grow over time.
  # </p>
  # 
  # @since 3.4
  class ContentAssistantFacade 
    include_class_members ContentAssistantFacadeImports
    
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    typesig { [IContentAssistant] }
    # Creates a new facade.
    # 
    # @param contentAssistant the content assistant which implements {@link IContentAssistantExtension2} and {@link IContentAssistantExtension4}
    def initialize(content_assistant)
      @f_content_assistant = nil
      Assert.is_legal(content_assistant.is_a?(IContentAssistantExtension4) && content_assistant.is_a?(IContentAssistantExtension4))
      @f_content_assistant = content_assistant
    end
    
    typesig { [String] }
    # Returns the handler for the given command identifier.
    # <p>
    # The same handler instance will be returned when called a more than once
    # with the same command identifier.
    # </p>
    # 
    # @param commandId the command identifier
    # @return the handler for the given command identifier
    # @throws IllegalArgumentException if the command is not supported by this
    # content assistant
    # @throws IllegalStateException if called when the content assistant is
    # uninstalled
    def get_handler(command_id)
      if ((@f_content_assistant).nil?)
        raise IllegalStateException.new
      end
      return (@f_content_assistant).get_handler(command_id)
    end
    
    typesig { [ICompletionListener] }
    # Adds a completion listener that will be informed before proposals are
    # computed.
    # 
    # @param listener the listener
    # @throws IllegalStateException if called when the content assistant is
    # uninstalled
    def add_completion_listener(listener)
      if ((@f_content_assistant).nil?)
        raise IllegalStateException.new
      end
      (@f_content_assistant).add_completion_listener(listener)
    end
    
    typesig { [ICompletionListener] }
    # Removes a completion listener.
    # 
    # @param listener the listener to remove
    # @throws IllegalStateException if called when the content assistant is
    # uninstalled
    def remove_completion_listener(listener)
      (@f_content_assistant).remove_completion_listener(listener)
    end
    
    private
    alias_method :initialize__content_assistant_facade, :initialize
  end
  
end
