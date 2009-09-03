require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IWidgetTokenKeeperExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IWidgetTokenKeeper}.
  # <p>
  # Replaces the original <code>requestWidgetToken</code> functionality with a
  # new priority based approach. Adds the concept of focus handling.
  # 
  # @since 3.0
  module IWidgetTokenKeeperExtension
    include_class_members IWidgetTokenKeeperExtensionImports
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # The given widget token owner requests the widget token  from
    # this token keeper. Returns  <code>true</code> if the token is released
    # by this token keeper. Note, the keeper must not call
    # <code>releaseWidgetToken(IWidgetTokenKeeper)</code> explicitly.
    # 
    # <p>The general contract is that the receiver should release the token
    # if <code>priority</code> exceeds the receiver's priority.</p>
    # 
    # @param owner the token owner
    # @param priority the priority of the request
    # @return <code>true</code> if token has been released <code>false</code> otherwise
    def request_widget_token(owner, priority)
      raise NotImplementedError
    end
    
    typesig { [IWidgetTokenOwner] }
    # Requests the receiver to give focus to its popup shell, hover, or similar. There is
    # no assumption made whether the receiver actually succeeded in taking the focus. The return
    # value gives a hint whether the receiver tried to take focus.
    # 
    # @param owner the token owner
    # @return <code>true</code> if the receiver tried to take focus, <code>false</code> if it did not.
    def set_focus(owner)
      raise NotImplementedError
    end
  end
  
end
