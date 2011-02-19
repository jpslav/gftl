module LeagueMembershipsHelper
  
  def getFranchiseCarString(lm, withDrivers=false) 
    getCarString(lm.franchise_car, withDrivers)
  end
  
  def getDarkhorseCarString(lm, withDrivers=false)  
    getCarString(lm.darkhorse_car, withDrivers)   
  end
  
  def getCarString(car, withDrivers) 
    result = "---"
    
    if (!car.nil?)
      result = car.number.to_s
      
      if (withDrivers)
        result = result + " (" + car.normal_drivers + ")"
      end
    end
    
    result
  end
  
  def getDarkhorseSelectOptions(year,lm=nil)
     league = lm.nil? ? nil : lm.league
     darkhorseCandidates = Car.darkhorseCandidates(year,league)
     currentDarkhorse = lm.nil? ? nil : lm.darkhorse_car
     
     if (!currentDarkhorse.nil? && !darkhorseCandidates.include?(currentDarkhorse))
       darkhorseCandidates.insert(0,currentDarkhorse)
     end
     
     darkhorseCandidates.sort!{|a,b| a.number.to_i <=> b.number.to_i}
     
     selectedCar = !currentDarkhorse.nil? ? currentDarkhorse.id : nil
     
     options_from_collection_for_select(
        darkhorseCandidates, :id, :number, selectedCar)
  end
end
