module LeagueMembershipsHelper
  
  def getDarkhorseCar(lm)
    !lm.owned_stable.nil? ? lm.owned_stable.darkhorse_car : nil
  end
  
  def getFranchiseCar(lm)
    !lm.owned_stable.nil? ? lm.owned_stable.franchise_car : nil
  end
  
  def getFranchiseCarString(lm, withDrivers=false) 
    franchise = getFranchiseCar(lm)
    getCarString(franchise, withDrivers)
  end
  
  def getDarkhorseCarString(lm, withDrivers=false)  
    darkhorse = getDarkhorseCar(lm)
    getCarString(darkhorse, withDrivers)   
  end
  
  def getCarString(car, withDrivers) 
    result = "---"
    
    if (!car.nil?)
      result = car.number.to_s
      
      if (withDrivers)
        result = result + " (" + car.normal_drivers + ")"
      end
    end
  end
  
  def getDarkhorseSelectOptions(lm)
     darkhorseCandidates = Car.darkhorseCandidates(lm.league.year)
     currentDarkhorse = getDarkhorseCar(lm)
     
     if (!currentDarkhorse.nil? && !darkhorseCandidates.include?(currentDarkhorse))
       darkhorseCandidates.insert(0,currentDarkhorse)
     end
     
     selectedCar = !currentDarkhorse.nil? ? currentDarkhorse.id : nil
     
     options_from_collection_for_select(
        darkhorseCandidates, :id, :number, selectedCar)
  end
end
