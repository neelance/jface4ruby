require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module HunkImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A hunk describes a contiguous range of changed, added or deleted lines. <code>Hunk</code>s are separated by
  # one or more unchanged lines.
  # 
  # @since 3.3
  class Hunk 
    include_class_members HunkImports
    
    # The line at which the hunk starts in the current document. Must be in
    # <code>[0, numberOfLines]</code> &ndash; note the inclusive end; there may be a hunk with
    # <code>line == numberOfLines</code> to describe deleted lines at then end of the document.
    attr_accessor :line
    alias_method :attr_line, :line
    undef_method :line
    alias_method :attr_line=, :line=
    undef_method :line=
    
    # The difference in lines compared to the corresponding line range in the original. Positive
    # for added lines, negative for deleted lines.
    attr_accessor :delta
    alias_method :attr_delta, :delta
    undef_method :delta
    alias_method :attr_delta=, :delta=
    undef_method :delta=
    
    # The number of changed lines in this hunk, must be &gt;= 0.
    attr_accessor :changed
    alias_method :attr_changed, :changed
    undef_method :changed
    alias_method :attr_changed=, :changed=
    undef_method :changed=
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new hunk.
    # 
    # @param line the line at which the hunk starts, must be &gt;= 0
    # @param delta the difference in lines compared to the original
    # @param changed the number of changed lines in this hunk, must be &gt;= 0
    def initialize(line, delta, changed)
      @line = 0
      @delta = 0
      @changed = 0
      Assert.is_legal(line >= 0)
      Assert.is_legal(changed >= 0)
      @line = line
      @delta = delta
      @changed = changed
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return "Hunk [" + RJava.cast_to_string(@line) + ">" + RJava.cast_to_string(@changed) + RJava.cast_to_string((@delta < 0 ? "-" : "+")) + RJava.cast_to_string(Math.abs(@delta)) + "]" # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      prime = 31
      result = 1
      result = prime * result + @changed
      result = prime * result + @delta
      result = prime * result + @line
      return result
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (obj.is_a?(Hunk))
        other = obj
        return (other.attr_line).equal?(@line) && (other.attr_delta).equal?(@delta) && (other.attr_changed).equal?(@changed)
      end
      return false
    end
    
    private
    alias_method :initialize__hunk, :initialize
  end
  
end
