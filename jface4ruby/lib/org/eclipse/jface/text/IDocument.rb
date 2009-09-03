require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IDocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # An <code>IDocument</code> represents text providing support for
  # <ul>
  # <li> text manipulation
  # <li> positions
  # <li> partitions
  # <li> line information
  # <li> document change listeners
  # <li> document partition change listeners
  # </ul>
  # 
  # A document allows to set its content and to manipulate it. For manipulation
  # a document provides the <code>replace</code> method which substitutes a given
  # string for a specified text range in the document. On each document change, all
  # registered document listeners are informed exactly once.
  # <p>
  # Positions are stickers to the document's text that are updated when the
  # document is changed. Positions are updated by {@link org.eclipse.jface.text.IPositionUpdater}s. Position
  # updaters are managed as a list. The list defines the sequence in which position
  # updaters are invoked. This way, position updaters may rely on each other.
  # Positions are grouped into categories.  A category is a ordered list of positions.
  # the document defines the order of position in a category based on the position's offset
  # based on the implementation of the method <code>computeIndexInCategory</code>.
  # Each document must support a default position category whose name is specified by this
  # interface.</p>
  # <p>
  # A document can be considered consisting of a sequence of not overlapping partitions.
  # A partition is defined by its offset, its length, and its type. Partitions are
  # updated on every document manipulation and ensured to be up-to-date when the document
  # listeners are informed. A document uses an <code>IDocumentPartitioner</code> to
  # manage its partitions. A document may be unpartitioned which happens when there is no
  # partitioner. In this case, the document is considered as one single partition of a
  # default type. The default type is specified by this interface. If a document change
  # changes the document's partitioning all registered partitioning listeners are
  # informed exactly once. The extension interface {@link org.eclipse.jface.text.IDocumentExtension3}
  # introduced in version 3.0 extends the concept of partitions and allows a document to
  # not only manage one but multiple partitioning. Each partitioning has an id which must
  # be used to refer to a particular partitioning.</p>
  # <p>
  # An <code>IDocument</code> provides methods to map line numbers and character
  # positions onto each other based on the document's line delimiters. When moving text
  # between documents using different line delimiters, the text must be converted to
  # use the target document's line delimiters.</p>
  # <p>
  # An <code>IDocument</code> does not care about mixed line delimiters. Clients who
  # want to ensure a single line delimiter in their document should use the line
  # delimiter returned by {@link org.eclipse.jface.text.TextUtilities#getDefaultLineDelimiter(IDocument)}.</p>
  # <p>
  # <code>IDocument</code> throws <code>BadLocationException</code> if the parameters of
  # queries or manipulation requests are not inside the bounds of the document. The purpose
  # of this style of exception handling is
  # <ul>
  # <li> prepare document for multi-thread access
  # <li> allow clients to implement backtracking recovery methods
  # <li> prevent clients from up-front contract checking when dealing with documents.
  # </ul></p>
  # <p>
  # A document support for searching has deprecated since version 3.0. The recommended way
  # for searching is to use a {@link org.eclipse.jface.text.FindReplaceDocumentAdapter}.</p>
  # <p>
  # In order to provide backward compatibility for clients of <code>IDocument</code>, extension
  # interfaces are used to provide a means of evolution. The following extension interfaces
  # exist:
  # <ul>
  # <li> {@link org.eclipse.jface.text.IDocumentExtension} since version 2.0 introducing the concept
  # of post notification replaces in order to allow document listeners to manipulate the document
  # while receiving a document change notification </li>
  # <li> {@link org.eclipse.jface.text.IDocumentExtension2} since version 2.1 introducing configuration
  # methods for post notification replaces and document change notification. </li>
  # <li> {@link org.eclipse.jface.text.IDocumentExtension3} since version 3.0 replacing the original
  # partitioning concept by allowing multiple partitionings at the same time and introducing zero-
  # length partitions in conjunction with the distinction between open and closed partitions. </li>
  # <li> {@link org.eclipse.jface.text.IDocumentExtension4} since version 3.1 introducing the
  # concept of rewrite sessions. A rewrite session is a sequence of document replace operations
  # that form a semantic unit. It also introduces a modification stamp and the ability to
  # set the initial line delimiter and to query the default line delimiter.</li>
  # </ul></p>
  # <p>
  # Clients may implement this interface and its extension interfaces or use the default
  # implementation provided by <code>AbstractDocument</code> and <code>Document</code>.</p>
  # 
  # @see org.eclipse.jface.text.IDocumentExtension
  # @see org.eclipse.jface.text.IDocumentExtension2
  # @see org.eclipse.jface.text.IDocumentExtension3
  # @see org.eclipse.jface.text.IDocumentExtension4
  # @see org.eclipse.jface.text.Position
  # @see org.eclipse.jface.text.IPositionUpdater
  # @see org.eclipse.jface.text.IDocumentPartitioner
  # @see org.eclipse.jface.text.ILineTracker
  # @see org.eclipse.jface.text.IDocumentListener
  # @see org.eclipse.jface.text.IDocumentPartitioningListener
  module IDocument
    include_class_members IDocumentImports
    
    class_module.module_eval {
      # The identifier of the default position category.
      const_set_lazy(:DEFAULT_CATEGORY) { "__dflt_position_category" }
      const_attr_reader  :DEFAULT_CATEGORY
      
      # $NON-NLS-1$
      # 
      # The identifier of the default partition content type.
      const_set_lazy(:DEFAULT_CONTENT_TYPE) { "__dftl_partition_content_type" }
      const_attr_reader  :DEFAULT_CONTENT_TYPE
    }
    
    typesig { [::Java::Int] }
    # $NON-NLS-1$
    # --------------- text access and manipulation ---------------------------
    # 
    # Returns the character at the given document offset in this document.
    # 
    # @param offset a document offset
    # @return the character at the offset
    # @exception BadLocationException if the offset is invalid in this document
    def get_char(offset)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of characters in this document.
    # 
    # @return the number of characters in this document
    def get_length
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this document's complete text.
    # 
    # @return the document's complete text
    def get
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns this document's text for the specified range.
    # 
    # @param offset the document offset
    # @param length the length of the specified range
    # @return the document's text for the specified range
    # @exception BadLocationException if the range is invalid in this document
    def get(offset, length)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Replaces the content of the document with the given text.
    # Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
    # This method is a convenience method for <code>replace(0, getLength(), text)</code>.
    # 
    # @param text the new content of the document
    # 
    # @see DocumentEvent
    # @see IDocumentListener
    def set(text)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Substitutes the given text for the specified document range.
    # Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
    # 
    # @param offset the document offset
    # @param length the length of the specified range
    # @param text the substitution text
    # @exception BadLocationException if the offset is invalid in this document
    # 
    # @see DocumentEvent
    # @see IDocumentListener
    def replace(offset, length, text)
      raise NotImplementedError
    end
    
    typesig { [IDocumentListener] }
    # Registers the document listener with the document. After registration
    # the IDocumentListener is informed about each change of this document.
    # If the listener is already registered nothing happens.<p>
    # An <code>IDocumentListener</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param listener the listener to be registered
    def add_document_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IDocumentListener] }
    # Removes the listener from the document's list of document listeners.
    # If the listener is not registered with the document nothing happens.<p>
    # An <code>IDocumentListener</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param listener the listener to be removed
    def remove_document_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IDocumentListener] }
    # Adds the given document listener as one which is notified before
    # those document listeners added with <code>addDocumentListener</code>
    # are notified. If the given listener is also registered using
    # <code>addDocumentListener</code> it will be notified twice.
    # If the listener is already registered nothing happens.<p>
    # 
    # This method is not for public use.
    # 
    # @param documentAdapter the listener to be added as pre-notified document listener
    # 
    # @see #removePrenotifiedDocumentListener(IDocumentListener)
    def add_prenotified_document_listener(document_adapter)
      raise NotImplementedError
    end
    
    typesig { [IDocumentListener] }
    # Removes the given document listener from the document's list of
    # pre-notified document listeners. If the listener is not registered
    # with the document nothing happens. <p>
    # 
    # This method is not for public use.
    # 
    # @param documentAdapter the listener to be removed
    # 
    # @see #addPrenotifiedDocumentListener(IDocumentListener)
    def remove_prenotified_document_listener(document_adapter)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # -------------------------- positions -----------------------------------
    # 
    # Adds a new position category to the document. If the position category
    # already exists nothing happens.
    # 
    # @param category the category to be added
    def add_position_category(category)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Deletes the position category from the document. All positions
    # in this category are thus deleted as well.
    # 
    # @param category the category to be removed
    # @exception BadPositionCategoryException if category is undefined in this document
    def remove_position_category(category)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns all position categories of this document. This
    # includes the default position category.
    # 
    # @return the document's position categories
    def get_position_categories
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Checks the presence of the specified position category.
    # 
    # @param category the category to check
    # @return <code>true</code> if category is defined
    def contains_position_category(category)
      raise NotImplementedError
    end
    
    typesig { [Position] }
    # Adds the position to the document's default position category.
    # This is a convenience method for <code>addPosition(DEFAULT_CATEGORY, position)</code>.
    # 
    # @param position the position to be added
    # @exception BadLocationException if position describes an invalid range in this document
    def add_position(position)
      raise NotImplementedError
    end
    
    typesig { [Position] }
    # Removes the given position from the document's default position category.
    # This is a convenience method for <code>removePosition(DEFAULT_CATEGORY, position)</code>.
    # 
    # @param position the position to be removed
    def remove_position(position)
      raise NotImplementedError
    end
    
    typesig { [String, Position] }
    # Adds the position to the specified position category of the document.
    # Positions may be added multiple times. The order of the category is
    # maintained.
    # <p>
    # <strong>Note:</strong> The position is only updated on each change
    # applied to the document if a {@link IPositionUpdater} has been
    # registered that handles the given category.
    # </p>
    # 
    # @param category the category to which to add
    # @param position the position to be added
    # @throws BadLocationException if position describes an invalid range in this document
    # @throws BadPositionCategoryException if the category is undefined in this document
    def add_position(category, position)
      raise NotImplementedError
    end
    
    typesig { [String, Position] }
    # Removes the given position from the specified position category.
    # If the position is not part of the specified category nothing happens.
    # If the position has been added multiple times, only the first occurrence is deleted.
    # 
    # @param category the category from which to delete
    # @param position the position to be deleted
    # @exception BadPositionCategoryException if category is undefined in this document
    def remove_position(category, position)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns all positions of the given position category.
    # The positions are ordered according to the category's order.
    # Manipulating this list does not affect the document, but manipulating the
    # position does affect the document.
    # 
    # @param category the category
    # @return the list of all positions
    # @exception BadPositionCategoryException if category is undefined in this document
    def get_positions(category)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Determines whether a position described by the parameters is managed by this document.
    # 
    # @param category the category to check
    # @param offset the offset of the position to find
    # @param length the length of the position to find
    # @return <code>true</code> if position is found
    def contains_position(category, offset, length)
      raise NotImplementedError
    end
    
    typesig { [String, ::Java::Int] }
    # Computes the index at which a <code>Position</code> with the
    # specified offset would be inserted into the given category. As the
    # ordering inside a category only depends on the offset, the index must be
    # chosen to be the first of all positions with the same offset.
    # 
    # @param category the category in which would be added
    # @param offset the position offset to be considered
    # @return the index into the category
    # @exception BadLocationException if offset is invalid in this document
    # @exception BadPositionCategoryException if category is undefined in this document
    def compute_index_in_category(category, offset)
      raise NotImplementedError
    end
    
    typesig { [IPositionUpdater] }
    # Appends a new position updater to the document's list of position updaters.
    # Position updaters may be added multiple times.<p>
    # An <code>IPositionUpdater</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param updater the updater to be added
    def add_position_updater(updater)
      raise NotImplementedError
    end
    
    typesig { [IPositionUpdater] }
    # Removes the position updater from the document's list of position updaters.
    # If the position updater has multiple occurrences only the first occurrence is
    # removed. If the position updater is not registered with this document, nothing
    # happens.<p>
    # An <code>IPositionUpdater</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param updater the updater to be removed
    def remove_position_updater(updater)
      raise NotImplementedError
    end
    
    typesig { [IPositionUpdater, ::Java::Int] }
    # Inserts the position updater at the specified index in the document's
    # list of position updaters. Positions updaters may be inserted multiple times.<p>
    # An <code>IPositionUpdater</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param updater the updater to be inserted
    # @param index the index in the document's updater list
    def insert_position_updater(updater, index)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the list of position updaters attached to the document.
    # 
    # @return the list of position updaters
    def get_position_updaters
      raise NotImplementedError
    end
    
    typesig { [] }
    # -------------------------- partitions ----------------------------------
    # 
    # Returns the set of legal content types of document partitions.
    # This set can be empty. The set can contain more content types than
    # contained by the result of <code>getPartitioning(0, getLength())</code>.
    # <p>
    # Use {@link IDocumentExtension3#getLegalContentTypes(String)} when the document
    # supports multiple partitionings. In that case this method is equivalent to:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # return extension.getLegalContentTypes(IDocumentExtension3.DEFAULT_PARTITIONING);
    # </pre>
    # 
    # @return the set of legal content types
    def get_legal_content_types
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the type of the document partition containing the given offset.
    # This is a convenience method for <code>getPartition(offset).getType()</code>.
    # <p>
    # Use {@link IDocumentExtension3#getContentType(String, int, boolean)} when
    # the document supports multiple partitionings. In that case this method is
    # equivalent to:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # return extension.getContentType(IDocumentExtension3.DEFAULT_PARTITIONING, offset, false);
    # </pre>
    # 
    # @param offset the document offset
    # @return the partition type
    # @exception BadLocationException if offset is invalid in this document
    def get_content_type(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the document partition in which the position is located.
    # <p>
    # Use {@link IDocumentExtension3#getPartition(String, int, boolean)} when
    # the document supports multiple partitionings. In that case this method is
    # equivalent:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # return extension.getPartition(IDocumentExtension3.DEFAULT_PARTITIONING, offset, false);
    # </pre>
    # 
    # @param offset the document offset
    # @return a specification of the partition
    # @exception BadLocationException if offset is invalid in this document
    def get_partition(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Computes the partitioning of the given document range using the
    # document's partitioner.
    # <p>
    # Use {@link IDocumentExtension3#computePartitioning(String, int, int, boolean)} when
    # the document supports multiple partitionings. In that case this method is
    # equivalent:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # return extension.computePartitioning(IDocumentExtension3.DEFAULT_PARTITIONING, offset, length, false);
    # </pre>
    # 
    # @param offset the document offset at which the range starts
    # @param length the length of the document range
    # @return a specification of the range's partitioning
    # @exception BadLocationException if the range is invalid in this document
    def compute_partitioning(offset, length)
      raise NotImplementedError
    end
    
    typesig { [IDocumentPartitioningListener] }
    # Registers the document partitioning listener with the document. After registration
    # the document partitioning listener is informed about each partition change
    # cause by a document manipulation or by changing the document's partitioner.
    # If a document partitioning listener is also
    # a document listener, the following notification sequence is guaranteed if a
    # document manipulation changes the document partitioning:
    # <ul>
    # <li>listener.documentAboutToBeChanged(DocumentEvent);
    # <li>listener.documentPartitioningChanged();
    # <li>listener.documentChanged(DocumentEvent);
    # </ul>
    # If the listener is already registered nothing happens.<p>
    # An <code>IDocumentPartitioningListener</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param listener the listener to be added
    def add_document_partitioning_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IDocumentPartitioningListener] }
    # Removes the listener from this document's list of document partitioning
    # listeners. If the listener is not registered with the document nothing
    # happens.<p>
    # An <code>IDocumentPartitioningListener</code> may call back to this method
    # when being inside a document notification.
    # 
    # @param listener the listener to be removed
    def remove_document_partitioning_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [IDocumentPartitioner] }
    # Sets this document's partitioner. The caller of this method is responsible for
    # disconnecting the document's old partitioner from the document and to
    # connect the new partitioner to the document. Informs all document partitioning
    # listeners about this change.
    # <p>
    # Use {@link IDocumentExtension3#setDocumentPartitioner(String, IDocumentPartitioner)} when
    # the document supports multiple partitionings. In that case this method is equivalent to:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # extension.setDocumentPartitioner(IDocumentExtension3.DEFAULT_PARTITIONING, partitioner);
    # </pre>
    # 
    # @param partitioner the document's new partitioner
    # 
    # @see IDocumentPartitioningListener
    def set_document_partitioner(partitioner)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this document's partitioner.
    # <p>
    # Use {@link IDocumentExtension3#getDocumentPartitioner(String)} when
    # the document supports multiple partitionings. In that case this method is
    # equivalent to:
    # <pre>
    # IDocumentExtension3 extension= (IDocumentExtension3) document;
    # return extension.getDocumentPartitioner(IDocumentExtension3.DEFAULT_PARTITIONING);
    # </pre>
    # 
    # @return this document's partitioner
    def get_document_partitioner
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # ---------------------- line information --------------------------------
    # 
    # Returns the length of the given line including the line's delimiter.
    # 
    # @param line the line of interest
    # @return the length of the line
    # @exception BadLocationException if the line number is invalid in this document
    def get_line_length(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the number of the line at which the character of the specified position is located.
    # The first line has the line number 0. A new line starts directly after a line
    # delimiter. <code>(offset == document length)</code> is a valid argument although there is no
    # corresponding character.
    # 
    # @param offset the document offset
    # @return the number of the line
    # @exception BadLocationException if the offset is invalid in this document
    def get_line_of_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Determines the offset of the first character of the given line.
    # 
    # @param line the line of interest
    # @return the document offset
    # @exception BadLocationException if the line number is invalid in this document
    def get_line_offset(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns a description of the specified line. The line is described by its
    # offset and its length excluding the line's delimiter.
    # 
    # @param line the line of interest
    # @return a line description
    # @exception BadLocationException if the line number is invalid in this document
    def get_line_information(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns a description of the line at the given offset.
    # The description contains the offset and the length of the line
    # excluding the line's delimiter.
    # 
    # @param offset the offset whose line should be described
    # @return a region describing the line
    # @exception BadLocationException if offset is invalid in this document
    def get_line_information_of_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of lines in this document
    # 
    # @return the number of lines in this document
    def get_number_of_lines
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the number of lines which are occupied by a given text range.
    # 
    # @param offset the offset of the specified text range
    # @param length the length of the specified text range
    # @return the number of lines occupied by the specified range
    # @exception BadLocationException if specified range is invalid in this tracker
    def get_number_of_lines(offset, length)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Computes the number of lines in the given text. For a given
    # implementer of this interface this method returns the same
    # result as <code>set(text); getNumberOfLines()</code>.
    # 
    # @param text the text whose number of lines should be computed
    # @return the number of lines in the given text
    def compute_number_of_lines(text)
      raise NotImplementedError
    end
    
    typesig { [] }
    # ------------------ line delimiter conversion ---------------------------
    # 
    # Returns the document's legal line delimiters.
    # 
    # @return the document's legal line delimiters
    def get_legal_line_delimiters
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line delimiter of that line or <code>null</code> if the
    # line is not closed with a line delimiter.
    # 
    # @param line the line of interest
    # @return the line's delimiter or <code>null</code> if line does not have a delimiter
    # @exception BadLocationException if the line number is invalid in this document
    def get_line_delimiter(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # ---------------------------- search ------------------------------------
    # 
    # Returns the offset of a given search string in the document based on a set of search criteria.
    # 
    # @param startOffset document offset at which search starts
    # @param findString the string to find
    # @param forwardSearch the search direction
    # @param caseSensitive indicates whether lower and upper case should be distinguished
    # @param wholeWord indicates whether the findString should be limited by white spaces as
    # defined by Character.isWhiteSpace
    # @return the offset of the first occurrence of findString based on the parameters or -1 if no match is found
    # @exception BadLocationException if startOffset is an invalid document offset
    # @deprecated as of 3.0 search is provided by {@link FindReplaceDocumentAdapter}
    def search(start_offset, find_string, forward_search, case_sensitive, whole_word)
      raise NotImplementedError
    end
  end
  
end
