require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Revisions
  module RevisionRangeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Revisions
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Source, :ILineRange
    }
  end
  
  # An unmodifiable line range that belongs to a {@link Revision}.
  # 
  # @since 3.3
  # @noinstantiate This class is not intended to be instantiated by clients.
  class RevisionRange 
    include_class_members RevisionRangeImports
    include ILineRange
    
    attr_accessor :f_revision
    alias_method :attr_f_revision, :f_revision
    undef_method :f_revision
    alias_method :attr_f_revision=, :f_revision=
    undef_method :f_revision=
    
    attr_accessor :f_start_line
    alias_method :attr_f_start_line, :f_start_line
    undef_method :f_start_line
    alias_method :attr_f_start_line=, :f_start_line=
    undef_method :f_start_line=
    
    attr_accessor :f_number_of_lines
    alias_method :attr_f_number_of_lines, :f_number_of_lines
    undef_method :f_number_of_lines
    alias_method :attr_f_number_of_lines=, :f_number_of_lines=
    undef_method :f_number_of_lines=
    
    typesig { [Revision, ILineRange] }
    def initialize(revision, range)
      @f_revision = nil
      @f_start_line = 0
      @f_number_of_lines = 0
      Assert.is_legal(!(revision).nil?)
      @f_revision = revision
      @f_start_line = range.get_start_line
      @f_number_of_lines = range.get_number_of_lines
    end
    
    typesig { [] }
    # Returns the revision that this range belongs to.
    # 
    # @return the revision that this range belongs to
    def get_revision
      return @f_revision
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getStartLine()
    def get_start_line
      return @f_start_line
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getNumberOfLines()
    def get_number_of_lines
      return @f_number_of_lines
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return "RevisionRange [" + RJava.cast_to_string(@f_revision.to_s) + ", [" + RJava.cast_to_string(get_start_line) + "+" + RJava.cast_to_string(get_number_of_lines) + ")]" # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    end
    
    private
    alias_method :initialize__revision_range, :initialize
  end
  
end
