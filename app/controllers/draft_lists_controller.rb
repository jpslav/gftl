class DraftListsController < ApplicationController
  # GET /draft_lists
  # GET /draft_lists.xml
  def index
    @draft_lists = DraftList.find_all_by_year_and_user_id(Time.now.year, current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @draft_lists }
    end
  end

  # GET /draft_lists/1
  # GET /draft_lists/1.xml
#  def show
#    @draft_list = DraftList.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @draft_list }
#    end
#  end

  # GET /draft_lists/new
  # GET /draft_lists/new.xml
  def new
    @draft_list = DraftList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @draft_list }
    end
  end

  # GET /draft_lists/1/edit
  def edit
    @draft_list = DraftList.find(params[:id])
    @selected_preference_id = @draft_list.ranked_preferences.first.id
  end

  # POST /draft_lists
  # POST /draft_lists.xml
  def create
    params[:draft_list].store(:user_id, current_user.id)
    params[:draft_list].store(:year, Time.now.year)
    @draft_list = DraftList.new(params[:draft_list])

    respond_to do |format|
      if @draft_list.save
        
        # Populate this list with all of the available cars
        
        Car.find_all_by_year(@draft_list.year, :order => "number").each do |car|
          @draft_list.add_car(car)
        end
        
        flash[:notice] = 'Draft list was successfully created.'
        format.html { redirect_to(draft_lists_path) }
        format.xml  { render :xml => @draft_list, :status => :created, :location => @draft_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @draft_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /draft_lists/1
  # PUT /draft_lists/1.xml
  def update
    @draft_list = DraftList.find(params[:id])

    respond_to do |format|
      if @draft_list.update_attributes(params[:draft_list])
        flash[:notice] = 'Draft list was successfully updated.'
        format.html { redirect_to(draft_lists_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @draft_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /draft_lists/1
  # DELETE /draft_lists/1.xml
  def destroy
    @draft_list = DraftList.find(params[:id])
    
    errorMessage = ""
    
    if !@draft_list.league_memberships.empty?
      errorMessage += 'Cannot delete the list named ' + @draft_list.name +
                      ' because it is being used by the following memberships: ' + 
                      @draft_list.league_memberships.collect{|m| m.toString}.join(", ");
    end
    
    if errorMessage.length == 0 
      @draft_list.destroy_preferences
      @draft_list.destroy    
    end

    respond_to do |format|
      if errorMessage.length != 0
        flash[:error] = errorMessage
      end
      
      format.html { redirect_to(draft_lists_url) }
      format.xml  { head :ok }
    end
  end
  
  def test
    logger.info "In test"
  end
  
  def sort
    sorted_preference_ids = params['pref']
    @draft_list = DraftPreference.find(sorted_preference_ids.first).draft_list
    @draft_list.reorder_preferences(sorted_preference_ids)
    render :partial => 'preference_list.html.erb'
  end
  
  def sort_preferences
    sorted_preference_ids = params['preferences']
    @draft_list = DraftPreference.find(sorted_preference_ids.first).draft_list
    @draft_list.reorder_preferences(sorted_preference_ids)
    render :partial => 'preference_list'
  end
  
  def show_hover_drivers
    logger.debug(params)
    hover_preference_car = DraftPreference.find(params[:num]).car
    @drivers = "# " + hover_preference_car.number + ": " + hover_preference_car.normal_drivers
    render :partial => 'hover_drivers.html.erb'
  end
end
