require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module TextEditVisitorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
    }
  end
  
  # A visitor for text edits.
  # <p>
  # For each different concrete text edit type <it>T</it> there is a method:
  # <ul>
  # <li><code>public boolean visit(<it>T</it> node)</code> - Visits the given edit to
  # perform some arbitrary operation. If <code>true </code> is returned, the given edit's
  # child edits will be visited next; however, if <code>false</code> is returned, the
  # given edit's child edits will not be visited. The default implementation provided by
  # this class calls a generic method <code>visitNode(<it>TextEdit</it> node)</code>.
  # Subclasses may reimplement these method as needed.</li>
  # </ul>
  # </p>
  # <p>
  # In addition, there are methods for visiting text edits in the
  # abstract, regardless of node type:
  # <ul>
  # <li><code>public void preVisit(TextEdit edit)</code> - Visits
  # the given edit to perform some arbitrary operation.
  # This method is invoked prior to the appropriate type-specific
  # <code>visit</code> method.
  # The default implementation of this method does nothing.
  # Subclasses may reimplement this method as needed.</li>
  # 
  # <li><code>public void postVisit(TextEdit edit)</code> - Visits
  # the given edit to perform some arbitrary operation.
  # This method is invoked after the appropriate type-specific
  # <code>endVisit</code> method.
  # The default implementation of this method does nothing.
  # Subclasses may reimplement this method as needed.</li>
  # </ul>
  # </p>
  # <p>
  # For edits with children, the child nodes are visited in increasing order.
  # </p>
  # 
  # @see TextEdit#accept(TextEditVisitor)
  # @since 3.0
  class TextEditVisitor 
    include_class_members TextEditVisitorImports
    
    typesig { [TextEdit] }
    # Visits the given text edit prior to the type-specific visit.
    # (before <code>visit</code>).
    # <p>
    # The default implementation does nothing. Subclasses may reimplement.
    # </p>
    # 
    # @param edit the node to visit
    def pre_visit(edit)
      # default implementation: do nothing
    end
    
    typesig { [TextEdit] }
    # Visits the given text edit following the type-specific visit
    # (after <code>endVisit</code>).
    # <p>
    # The default implementation does nothing. Subclasses may reimplement.
    # </p>
    # 
    # @param edit the node to visit
    def post_visit(edit)
      # default implementation: do nothing
    end
    
    typesig { [TextEdit] }
    # Visits the given text edit. This method is called by default from
    # type-specific visits. It is not called by an edit's accept method.
    # The default implementation returns <code>true</code>.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit_node(edit)
      return true
    end
    
    typesig { [CopySourceEdit] }
    # Visits a <code>CopySourceEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [CopyTargetEdit] }
    # Visits a <code>CopyTargetEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [MoveSourceEdit] }
    # Visits a <code>MoveSourceEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [MoveTargetEdit] }
    # Visits a <code>MoveTargetEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [RangeMarker] }
    # Visits a <code>RangeMarker</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [CopyingRangeMarker] }
    # Visits a <code>CopyingRangeMarker</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [DeleteEdit] }
    # Visits a <code>DeleteEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [InsertEdit] }
    # Visits a <code>InsertEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [ReplaceEdit] }
    # Visits a <code>ReplaceEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [UndoEdit] }
    # Visits a <code>UndoEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [MultiTextEdit] }
    # Visits a <code>MultiTextEdit</code> instance.
    # 
    # @param edit the node to visit
    # @return If <code>true</code> is returned, the given node's child
    # nodes will be visited next; however, if <code>false</code> is
    # returned, the given node's child nodes will not be visited.
    def visit(edit)
      return visit_node(edit)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__text_edit_visitor, :initialize
  end
  
end
