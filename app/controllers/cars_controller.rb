class CarsController < ApplicationController
  
  before_filter :admin_required
  
  # GET /cars
  # GET /cars.xml
  def index
    @cars = Car.all(:order => "number")
    @cars.sort!{|a,b| a.number.to_i <=> b.number.to_i}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cars }
    end
  end

  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    @car = Car.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
  end

  # POST /cars
  # POST /cars.xml
  def create
    @car = Car.new(params[:car])

    respond_to do |format|
      if @car.save
        
        @car.populate_references
        
        flash[:notice] = 'Car was successfully created.'
        format.html { redirect_to(@car) }
        format.xml  { render :xml => @car, :status => :created, :location => @car }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cars/1
  # PUT /cars/1.xml
  def update
    @car = Car.find(params[:id])

    respond_to do |format|
      if @car.update_attributes(params[:car])
        flash[:notice] = 'Car was successfully updated.'
        format.html { redirect_to(@car) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
#    @car = Car.find(params[:id])
    
#    DraftList.remove_car(car)
#    PreseasonRanking.remove_car(car)
    # TODO what about owned cars, race pairings, results -- can't really remove those
    
#    @car.destroy

    respond_to do |format|
      flash[:error] = 'Cars cannot currently be deleted once created.  As a workaround, you can edit an existing car to have a different number and driver.'
      format.html { redirect_to(cars_url) }
      format.xml  { head :ok }
    end
  end
end
