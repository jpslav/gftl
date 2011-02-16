class RaceResultsController < ApplicationController
  
  before_filter :admin_required
  
  #in_place_edit_with_validation_for :race_result, :points_delta
  
  can_edit_on_the_spot
  
  # GET /race_results
  # GET /race_results.xml
  def index
    @load_javascript = true
    @race_results = RaceResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @race_results }
    end
  end

  def pick_cars
    @race = Race.find(params[:id])
    cars_already_in_race = RaceResult.find_all_by_race_id(params[:id]).collect{|r| r.car}
    @cars_not_yet_in_race = Car.find_all_by_year(@race.racetime.year).delete_if{|car| cars_already_in_race.include?(car)}
  end

  def import_results
    @race = Race.find(params[:id])
    respond_to do |format|
      format.html 
    end
  end
  
  def parse_results_table
    table = params[:results_table]
    
    logger.info table.inspect
    
    logger.info "\n\n\n\n"
    
    lines = table.split(/\r\n\d/)
    first_line = lines.delete_at(0).split("\t")
    
    car_number_index = first_line.index(first_line.grep(/CAR/).to_s)
    pts_index = first_line.index(first_line.grep(/PTS\/BNS/).to_s)
    
    logger.info "Car # Col: " + car_number_index.to_s
    logger.info "Pts Col:   " + pts_index.to_s
    
    flash[:error] = flash[:error] + "Could not find car column. " if car_number_index.nil? 
    flash[:error] = flash[:error] + "Could not find PTS/BNS column. " if pts_index.nil? 
    
    if flash[:error].nil? || flash[:error].empty?
      lines.each do |line|
        columns = line.split("\t")
        logger.info columns.inspect
        
        car_number = columns[car_number_index]
        pts_match = /(\d+)\/(\d+)/.match(columns[pts_index])
        pts = pts_match[1].to_i #+ pts_match[2].to_i  # the bonus pts are already included in [1]!
        logger.info "Car: " + car_number + " Pts: " + pts.to_s
        
        car = Car.find_by_number(car_number.strip)
        
        if (car.nil?)
          flash[:error] = "" if (flash[:error].nil?)
          flash[:error] = flash[:error] + "Could not save result for car " + car_number.strip.to_s
        else
          car_id = car.id

         # if (RaceResult.find_by_race_id_and_car_id(params[:race_id], :car_id).nil?)
            setup = {:race_id => params[:race_id].to_i, :car_id => car_id, :points_delta => pts}
            logger.info("About to create a race result with info: " + setup.inspect)
            race_result = RaceResult.new(setup)
            race_result.save
        #  end
        end
        
      end
    end
   
    
      respond_to do |format|
        format.html { redirect_to race_results_path }
        
      end
  end

  def get_race_result_points_delta
    RaceResult.find(params[:id]).points_delta
  end

  def add_cars
    #@race_result = RaceResult.new(params[:race_result])
    
    params[:chosen_cars].each do |car_id|
      setup = {:race_id => params[:race_id].to_i, :car_id => car_id.to_i, :points_delta => 0}
      logger.info("About to create a race result with info: " + setup.inspect)
      race_result = RaceResult.new(setup)
      race_result.save!
    end
    

    respond_to do |format|
      if true #@race_result.save
        flash[:notice] = 'The requested cars were successfully added.'
        format.html { redirect_to(race_results_path) }
        format.xml  { render :xml => @race_result, :status => :created, :location => @race_result }
      else
        format.html { render :action => "pick_cars" }
        format.xml  { render :xml => @race_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /race_results/1
  # GET /race_results/1.xml
  def show
    @race_result = RaceResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @race_result }
    end
  end

  # GET /race_results/new
  # GET /race_results/new.xml
  def new
    @race_result = RaceResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @race_result }
    end
  end

  # GET /race_results/1/edit
  def edit
    @race_result = RaceResult.find(params[:id])
  end

  # POST /race_results
  # POST /race_results.xml
  def create
    @race_result = RaceResult.new(params[:race_result])

    respond_to do |format|
      if @race_result.save
        flash[:notice] = 'RaceResult was successfully created.'
        format.html { redirect_to(@race_result) }
        format.xml  { render :xml => @race_result, :status => :created, :location => @race_result }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @race_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /race_results/1
  # PUT /race_results/1.xml
  def update
    @race_result = RaceResult.find(params[:id])

    respond_to do |format|
      if @race_result.update_attributes(params[:race_result])
        flash[:notice] = 'RaceResult was successfully updated.'
        format.html { redirect_to(@race_result) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @race_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /race_results/1
  # DELETE /race_results/1.xml
  def destroy
    @race_result = RaceResult.find(params[:id])
    @race_result.destroy

    respond_to do |format|
      format.html { redirect_to(race_results_url) }
      format.xml  { head :ok }
    end
  end
  
  def destroy_by_race
    RaceResult.find_all_by_race_id(params[:id].to_i).each{|rr| rr.destroy}
    
    respond_to do |format|
      format.html { redirect_to(race_results_url) }
      format.xml  { head :ok }
    end
  end
end
