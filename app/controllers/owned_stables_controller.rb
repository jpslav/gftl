class OwnedStablesController < ApplicationController

  before_filter :admin_required

  # GET /owned_stables
  # GET /owned_stables.xml
  def index
    @owned_stables = OwnedStable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @owned_stables }
    end
  end

  # GET /owned_stables/1
  # GET /owned_stables/1.xml
#  def show
#    @owned_stable = OwnedStable.find(params[:id])#
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @owned_stable }
#    end
#  end

  # GET /owned_stables/new
  # GET /owned_stables/new.xml
  def new
    @owned_stable = OwnedStable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @owned_stable }
    end
  end

  # GET /owned_stables/1/edit
  def edit
    @owned_stable = OwnedStable.find(params[:id])
    @cars = Car.find_all_by_year(Time.now.year)
  end

  # POST /owned_stables
  # POST /owned_stables.xml
  def create
    @owned_stable = OwnedStable.new(params[:owned_stable])

    respond_to do |format|
      if @owned_stable.save
        flash[:notice] = 'OwnedStable was successfully created.'
        format.html { redirect_to owned_stables_path }
        format.xml  { render :xml => @owned_stable, :status => :created, :location => @owned_stable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @owned_stable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /owned_stables/1
  # PUT /owned_stables/1.xml
  def update
    @owned_stable = OwnedStable.find(params[:id])

    respond_to do |format|
      if @owned_stable.update_attributes(params[:owned_stable])
        flash[:notice] = 'OwnedStable was successfully updated.'
        format.html { redirect_to owned_stables_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @owned_stable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /owned_stables/1
  # DELETE /owned_stables/1.xml
  def destroy
    @owned_stable = OwnedStable.find(params[:id])
    @owned_stable.destroy

    respond_to do |format|
      format.html { redirect_to(owned_stables_url) }
      format.xml  { head :ok }
    end
  end
end
