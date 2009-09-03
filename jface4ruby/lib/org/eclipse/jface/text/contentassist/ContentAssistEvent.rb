require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Anton Leherbauer (Wind River Systems) - [content assist][api] ContentAssistEvent should contain information about auto activation - https://bugs.eclipse.org/bugs/show_bug.cgi?id=193728
module Org::Eclipse::Jface::Text::Contentassist
  module ContentAssistEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
    }
  end
  
  # Describes the state that the content assistant is in when completing proposals.
  # <p>
  # Clients may use this class.
  # </p>
  # 
  # @since 3.2
  # @see ICompletionListener
  # @noinstantiate This class is not intended to be instantiated by clients.
  class ContentAssistEvent 
    include_class_members ContentAssistEventImports
    
    typesig { [IContentAssistant, IContentAssistProcessor, ::Java::Boolean] }
    # Creates a new event.
    # 
    # @param ca the assistant
    # @param proc the processor
    # @param isAutoActivated whether content assist was triggered by auto activation
    # @since 3.4
    def initialize(ca, proc, is_auto_activated)
      @assistant = nil
      @processor = nil
      @is_auto_activated = false
      @assistant = ca
      @processor = proc
      @is_auto_activated = is_auto_activated
    end
    
    typesig { [ContentAssistant, IContentAssistProcessor] }
    # Creates a new event.
    # 
    # @param ca the assistant
    # @param proc the processor
    def initialize(ca, proc)
      initialize__content_assist_event(ca, proc, false)
    end
    
    # The content assistant computing proposals.
    attr_accessor :assistant
    alias_method :attr_assistant, :assistant
    undef_method :assistant
    alias_method :attr_assistant=, :assistant=
    undef_method :assistant=
    
    # The processor for the current partition.
    attr_accessor :processor
    alias_method :attr_processor, :processor
    undef_method :processor
    alias_method :attr_processor=, :processor=
    undef_method :processor=
    
    # Tells, whether content assist was triggered by auto activation.
    # <p>
    # <strong>Note:</strong> This flag is only valid in {@link ICompletionListener#assistSessionStarted(ContentAssistEvent)}.
    # </p>
    # 
    # @since 3.4
    attr_accessor :is_auto_activated
    alias_method :attr_is_auto_activated, :is_auto_activated
    undef_method :is_auto_activated
    alias_method :attr_is_auto_activated=, :is_auto_activated=
    undef_method :is_auto_activated=
    
    private
    alias_method :initialize__content_assist_event, :initialize
  end
  
end
