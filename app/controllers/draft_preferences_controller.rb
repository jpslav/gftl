class DraftPreferencesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

public 
  
  def move_preference_up
    handle_preference_action(params[:preferences],:movePreferenceUp)
  end
  
  def move_preference_down
    handle_preference_action(params[:preferences],:movePreferenceDown)
  end
  
private
  
  def handle_preference_action(preference_id, action)
    return if preference_id.nil?

    selectedPreference = DraftPreference.find(preference_id)
      
    case action
    when :movePreferenceUp
     selectedPreference.moveEarlier
    when :movePreferenceDown
     selectedPreference.moveLater
    end
    
    # Generate the partial for the preference list (for this, we need to ordered 
    # list of preferences and the index of the one that should be selected)
    
    @draft_list = selectedPreference.draft_list
    @selected_preference_id = preference_id.to_i
    render :partial => 'preference_list'
  end

end
