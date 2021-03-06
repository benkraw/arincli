# Copyright (C) 2011,2012,2013 American Registry for Internet Numbers
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
# IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


require 'rexml/document'
require 'stringio'
require 'rexml/formatters/transitive'
require 'uri'

module ARINcli

  def ARINcli::new_element_with_text( element_name, text )
    e = REXML::Element.new( element_name )
    e.text=text
    return e
  end

  def ARINcli::new_wrapped_element( wrapper_name, element_name, data )
    e = REXML::Element.new( wrapper_name )
    data.each do |datum|
      e.add_element( ARINcli::new_element_with_text( element_name, datum ) )
    end
    return e
  end

  def ARINcli::new_number_wrapped_element( wrapper_name, data )
    e = REXML::Element.new( wrapper_name )
    line_no = 1
    data.each do |datum|
      child = ARINcli::new_element_with_text( "line", datum )
      child.add_attribute( "number", line_no.to_s )
      e.add_element( child )
      line_no += 1
    end
    return e
  end

  def ARINcli::pretty_print_xml_to_s( node )
    sio = StringIO.new
    output = REXML::Output.new sio
    formatter = REXML::Formatters::Transitive.new
    formatter.write( node, output )
    return sio.string
  end

  def ARINcli.make_safe( url )
    safe = URI.escape( url )
    safe = URI.escape( safe, "!*'();:@&=+$,/?#[]" )
    return safe
  end
end
