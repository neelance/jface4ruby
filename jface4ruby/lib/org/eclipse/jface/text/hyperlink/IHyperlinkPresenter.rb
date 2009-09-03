require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module IHyperlinkPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # A hyperlink presenter shows hyperlinks on the installed text viewer
  # and allows to pick one on of the hyperlinks.
  # <p>
  # In order to provide backward compatibility for clients of <code>IHyperlinkDetector</code>, extension
  # interfaces are used to provide a means of evolution. The following extension interfaces exist:
  # <ul>
  # <li>{@link IHyperlinkPresenterExtension} since version 3.4,
  # adds the ability to query  whether the currently shown hyperlinks
  # can be hidden.
  # </li>
  # </ul></p>
  # <p>
  # Clients may implement this interface. A default implementation is provided
  # through {@link org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter}.
  # </p>
  # 
  # @see IHyperlinkPresenterExtension
  # @since 3.1
  module IHyperlinkPresenter
    include_class_members IHyperlinkPresenterImports
    
    typesig { [] }
    # Tells whether this presenter is able to handle
    # more than one hyperlink.
    # 
    # @return <code>true</code> if this presenter can handle more than one hyperlink
    def can_show_multiple_hyperlinks
      raise NotImplementedError
    end
    
    typesig { [Array.typed(IHyperlink)] }
    # Tells this hyperlink presenter to show the given
    # hyperlinks on the installed text viewer.
    # 
    # @param hyperlinks the hyperlinks to show
    # @throws IllegalArgumentException if
    # <ul>
    # <li><code>hyperlinks</code> is empty</li>
    # <li>{@link #canShowMultipleHyperlinks()} returns <code>false</code> and <code>hyperlinks</code> contains more than one element</li>
    # </ul>
    def show_hyperlinks(hyperlinks)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells this hyperlink presenter to hide the hyperlinks
    # requested to be shown by {@link #showHyperlinks(IHyperlink[])}.
    def hide_hyperlinks
      raise NotImplementedError
    end
    
    typesig { [ITextViewer] }
    # Installs this hyperlink presenter on the given text viewer.
    # 
    # @param textViewer the text viewer
    def install(text_viewer)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Uninstalls this hyperlink presenter.
    def uninstall
      raise NotImplementedError
    end
  end
  
end
