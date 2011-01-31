module TableHelper 

  def formatted_table(contentList, tableFormatting, columnInfoList, rowActions=nil)
  
    # TODO change :accessor to :data
    # TODO allow people to pass in different collections for both the :data and :heading aspects (not everything has
    # to be handled by this method (not everything has to go through contentList); in fact, changing to this means we
    # wouldn't have to pass in contentList as the first argument.
  
    html = "<table id=\"list\">\n"

    # Write out column header row

    html << "  <tr>\n"    
    for columnInfo in columnInfoList
      columnHeadings = getHeading(contentList[0], columnInfo[:heading])
      
      for columnHeading in columnHeadings
        html << "    <td class=\"topRow\""
        html << " width=\"" << columnInfo[:width] << "\"" if columnInfo.has_key?(:width)
        html << ">" << columnHeading << "</td>" << "\n"
      end
    end
 
    # Create cells for as many row action icons as we have (plus one for padding)   
    if !rowActions.nil? && !rowActions.empty?
      html << "    <td width=\"10px\">&nbsp;</td>\n"
      rowActions.size.times do html << "    <td width=\"20px\">&nbsp;</td>\n" end
    end
 
    html << "  </tr>\n"
    
    # Write out the data rows
  
    rowNumber = 0
    odd_or_even_class_name = ["oddRow", "evenRow"]   
    
    for content in contentList
      odd_or_even_class = odd_or_even_class_name[(rowNumber += 1) % 2]
      html << "  <tr>\n"

      # Write out the data

      for columnInfo in columnInfoList
        data = getMemberArray(content, columnInfo[:accessor])
        
        for d in data
          html << "    <td class=#{odd_or_even_class}>" << d.to_s << "</td>\n"
        end
      end

      # Write out the action links

      if !rowActions.nil? && !rowActions.empty?
        html << "    <td></td>\n"
        
        if rowActions.has_key?(:show)
          html << "    <td>"
          html << link_to(image_tag("/images/show.gif", :border => 0),
                                    :controller => rowActions[:show][:controller],
                                    :action => rowActions[:show][:action],
                                    :id => getData(content, rowActions[:show][:id]))
          html << "</td>\n"
        end
        if rowActions.has_key?(:edit)
          html << "    <td>"
          html << link_to(image_tag("/images/edit.gif", :border => 0),
                                    :controller => rowActions[:edit][:controller],
                                    :action => rowActions[:edit][:action],
                                    :id => getData(content, rowActions[:edit][:id]))
          html << "</td>\n"
        end
        if rowActions.has_key?(:delete)
          html << "    <td>"
          html << link_to(image_tag("/images/trash.gif", :border => 0),
                                    {:controller => rowActions[:delete][:controller],
                                     :action => rowActions[:delete][:action],
                                     :id => getData(content, rowActions[:delete][:id])},
                                    :confirm => "Are you sure you want to remove the record for " << getData(content, rowActions[:delete][:confirm]).to_s << "?", 
            		                :post => true)
          html << "</td>\n"
        end
      end

      html << "  </tr>\n"
    end
      
    html << "</table>"
  end
  
private




#  def getData(object, accessor)
#    data = nil
#    return "$"
#    if accessor.is_a? Hash
#      raise "Too many entries in accessor hash" if accessor.size > 1
#      
#      accessor.each do |key, value|
#        data = getData(object.send(key), value)
#      end
#    else
#      data = object.send(accessor).to_s
#    end
#    
#    raise "Couldn't find data in " + object.to_s + " using accessor " + accessor.to_s if data.nil?
#    
#    return data
#  end  
  
  def getHeading(object, accessor)
    getMemberArray(object, accessor)
  end
  
  def getData(object, accessor)
    getMemberArray(object, accessor)
  end
  
  # If the incoming object is a collection, return a collection of members
  
#  def getMember(object, accessor)
#    data = nil
#    
#    if object.is_a? Enumerable
#    
#      if accessor.is_a? Hash
#        raise "Too many entries in accessor hash" if accessor.size > 1
#        
#        accessor.each do |key, value|
#          data = getData(object.send(key), value)
#        end
#      elsif object.has_method? accessor
#        data = object.send(accessor).to_s
#      else 
#        data = accessor
#      end
#      
#    end
#    
#    raise "Couldn't find data in " + object.to_s + " using accessor " + accessor.to_s if data.nil?
#    
#    return data
#  end  

  def getMemberArray(object, accessor, memberArray=nil)
    logger.debug("start getMemberArray: " + object.to_s + " " + accessor.to_s + " " + memberArray.to_s )
  
    return if object.nil?
  
    if memberArray.nil?
      memberArray = Array.new
    end
    
    if object.respond_to? :each
      for o in object
        getMemberFromObject(o,accessor,memberArray)      
      end    
    else
      getMemberFromObject(object, accessor, memberArray)    
    end
    
    raise "Couldn't find data in " + object.to_s + " using accessor " + accessor.to_s if memberArray.empty?
    # TODO flatten the collection if there is only one entry
    logger.debug("end   getMemberArray: " + object.to_s + " " + accessor.to_s + " " + memberArray.to_s )
    return memberArray
  end  
  
  def getMemberFromObject(object, accessor, memberArray = nil)
    if object.nil?
      memberArray.push("")
    elsif accessor.is_a? Hash
      raise "Too many entries in accessor hash" if accessor.size > 1
      
      accessor.each do |key, value|
        getMemberArray(object.send(key), value, memberArray)
      end
    elsif object.respond_to? accessor
      memberArray.push(object.send(accessor).to_s) # TODO should this be a call to getMemberArray too?
    else 
      memberArray.push(accessor.to_s)
    end
  end

end