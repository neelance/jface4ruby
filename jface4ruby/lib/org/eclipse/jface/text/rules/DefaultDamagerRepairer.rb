require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module DefaultDamagerRepairerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextAttribute
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
      include_const ::Org::Eclipse::Jface::Text::Presentation, :IPresentationDamager
      include_const ::Org::Eclipse::Jface::Text::Presentation, :IPresentationRepairer
    }
  end
  
  # A standard implementation of a syntax driven presentation damager
  # and presentation repairer. It uses a token scanner to scan
  # the document and to determine its damage and new text presentation.
  # The tokens returned by the scanner are supposed to return text attributes
  # as their data.
  # 
  # @see ITokenScanner
  # @since 2.0
  class DefaultDamagerRepairer 
    include_class_members DefaultDamagerRepairerImports
    include IPresentationDamager
    include IPresentationRepairer
    
    # The document this object works on
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The scanner it uses
    attr_accessor :f_scanner
    alias_method :attr_f_scanner, :f_scanner
    undef_method :f_scanner
    alias_method :attr_f_scanner=, :f_scanner=
    undef_method :f_scanner=
    
    # The default text attribute if non is returned as data by the current token
    attr_accessor :f_default_text_attribute
    alias_method :attr_f_default_text_attribute, :f_default_text_attribute
    undef_method :f_default_text_attribute
    alias_method :attr_f_default_text_attribute=, :f_default_text_attribute=
    undef_method :f_default_text_attribute=
    
    typesig { [ITokenScanner, TextAttribute] }
    # Creates a damager/repairer that uses the given scanner and returns the given default
    # text attribute if the current token does not carry a text attribute.
    # 
    # @param scanner the token scanner to be used
    # @param defaultTextAttribute the text attribute to be returned if non is specified by the current token,
    # may not be <code>null</code>
    # 
    # @deprecated use DefaultDamagerRepairer(ITokenScanner) instead
    def initialize(scanner, default_text_attribute)
      @f_document = nil
      @f_scanner = nil
      @f_default_text_attribute = nil
      Assert.is_not_null(default_text_attribute)
      @f_scanner = scanner
      @f_default_text_attribute = default_text_attribute
    end
    
    typesig { [ITokenScanner] }
    # Creates a damager/repairer that uses the given scanner. The scanner may not be <code>null</code>
    # and is assumed to return only token that carry text attributes.
    # 
    # @param scanner the token scanner to be used, may not be <code>null</code>
    def initialize(scanner)
      @f_document = nil
      @f_scanner = nil
      @f_default_text_attribute = nil
      Assert.is_not_null(scanner)
      @f_scanner = scanner
      @f_default_text_attribute = TextAttribute.new(nil)
    end
    
    typesig { [IDocument] }
    # @see IPresentationDamager#setDocument(IDocument)
    # @see IPresentationRepairer#setDocument(IDocument)
    def set_document(document)
      @f_document = document
    end
    
    typesig { [::Java::Int] }
    # ---- IPresentationDamager
    # 
    # Returns the end offset of the line that contains the specified offset or
    # if the offset is inside a line delimiter, the end offset of the next line.
    # 
    # @param offset the offset whose line end offset must be computed
    # @return the line end offset for the given offset
    # @exception BadLocationException if offset is invalid in the current document
    def end_of_line_of(offset)
      info = @f_document.get_line_information_of_offset(offset)
      if (offset <= info.get_offset + info.get_length)
        return info.get_offset + info.get_length
      end
      line = @f_document.get_line_of_offset(offset)
      begin
        info = @f_document.get_line_information(line + 1)
        return info.get_offset + info.get_length
      rescue BadLocationException => x
        return @f_document.get_length
      end
    end
    
    typesig { [ITypedRegion, DocumentEvent, ::Java::Boolean] }
    # @see IPresentationDamager#getDamageRegion(ITypedRegion, DocumentEvent, boolean)
    def get_damage_region(partition, e, document_partitioning_changed)
      if (!document_partitioning_changed)
        begin
          info = @f_document.get_line_information_of_offset(e.get_offset)
          start = Math.max(partition.get_offset, info.get_offset)
          end_ = e.get_offset + ((e.get_text).nil? ? e.get_length : e.get_text.length)
          if (info.get_offset <= end_ && end_ <= info.get_offset + info.get_length)
            # optimize the case of the same line
            end_ = info.get_offset + info.get_length
          else
            end_ = end_of_line_of(end_)
          end
          end_ = Math.min(partition.get_offset + partition.get_length, end_)
          return Region.new(start, end_ - start)
        rescue BadLocationException => x
        end
      end
      return partition
    end
    
    typesig { [TextPresentation, ITypedRegion] }
    # ---- IPresentationRepairer
    # 
    # @see IPresentationRepairer#createPresentation(TextPresentation, ITypedRegion)
    def create_presentation(presentation, region)
      if ((@f_scanner).nil?)
        # will be removed if deprecated constructor will be removed
        add_range(presentation, region.get_offset, region.get_length, @f_default_text_attribute)
        return
      end
      last_start = region.get_offset
      length = 0
      first_token = true
      last_token = Token::UNDEFINED
      last_attribute = get_token_text_attribute(last_token)
      @f_scanner.set_range(@f_document, last_start, region.get_length)
      while (true)
        token = @f_scanner.next_token
        if (token.is_eof)
          break
        end
        attribute = get_token_text_attribute(token)
        if (!(last_attribute).nil? && (last_attribute == attribute))
          length += @f_scanner.get_token_length
          first_token = false
        else
          if (!first_token)
            add_range(presentation, last_start, length, last_attribute)
          end
          first_token = false
          last_token = token
          last_attribute = attribute
          last_start = @f_scanner.get_token_offset
          length = @f_scanner.get_token_length
        end
      end
      add_range(presentation, last_start, length, last_attribute)
    end
    
    typesig { [IToken] }
    # Returns a text attribute encoded in the given token. If the token's
    # data is not <code>null</code> and a text attribute it is assumed that
    # it is the encoded text attribute. It returns the default text attribute
    # if there is no encoded text attribute found.
    # 
    # @param token the token whose text attribute is to be determined
    # @return the token's text attribute
    def get_token_text_attribute(token)
      data = token.get_data
      if (data.is_a?(TextAttribute))
        return data
      end
      return @f_default_text_attribute
    end
    
    typesig { [TextPresentation, ::Java::Int, ::Java::Int, TextAttribute] }
    # Adds style information to the given text presentation.
    # 
    # @param presentation the text presentation to be extended
    # @param offset the offset of the range to be styled
    # @param length the length of the range to be styled
    # @param attr the attribute describing the style of the range to be styled
    def add_range(presentation, offset, length, attr)
      if (!(attr).nil?)
        style = attr.get_style
        font_style = style & (SWT::ITALIC | SWT::BOLD | SWT::NORMAL)
        style_range = StyleRange.new(offset, length, attr.get_foreground, attr.get_background, font_style)
        style_range.attr_strikeout = !((style & TextAttribute::STRIKETHROUGH)).equal?(0)
        style_range.attr_underline = !((style & TextAttribute::UNDERLINE)).equal?(0)
        style_range.attr_font = attr.get_font
        presentation.add_style_range(style_range)
      end
    end
    
    private
    alias_method :initialize__default_damager_repairer, :initialize
  end
  
end
