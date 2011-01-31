class OwnersController < ApplicationController
  # GET /owners
  # GET /owners.xml
  def index
    @owners = Owner.find_all_by_user_id(current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @owners }
    end
  end

  # GET /owners/1
  # GET /owners/1.xml
  def show
    @owner = Owner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @owner }
    end
  end

  # GET /owners/new
  # GET /owners/new.xml
  def new
    @owner = Owner.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @owner }
    end
  end

  # GET /owners/1/edit
  def edit
    @owner = Owner.find(params[:id])
    
    if @owner.user != current_user
      redirect_to @owner
    end
  end

  # POST /owners
  # POST /owners.xml
  def create
    params[:owner].store(:user_id, current_user.id)
    @owner = Owner.new(params[:owner])

    respond_to do |format|
      if @owner.save
        flash[:notice] = "You successfully created the owner #{@owner.name}."
        format.html { redirect_to owners_path }
        format.xml  { render :xml => @owner, :status => :created, :location => @owner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /owners/1
  # PUT /owners/1.xml
  def update
    @owner = Owner.find(params[:id])

    respond_to do |format|
      if @owner.update_attributes(params[:owner])
        flash[:notice] = 'Owner was successfully updated.'
        format.html { redirect_to(@owner) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.xml
  def destroy
    @owner = Owner.find(params[:id])
    
    errorMessage = ""
    
    if !@owner.league_memberships.empty?
      errorMessage += "Cannot delete the owner '" + @owner.name +
                      "' because it is in the following leagues: " + 
                      @owner.league_memberships.collect{|m| m.league.name}.join(", ");
    else
      @owner.destroy
    end
    
    respond_to do |format|

      if errorMessage.length != 0
        flash[:error] = errorMessage 
      end
      
      format.html { redirect_to(owners_url) }
      format.xml  { head :ok }
    end
  end
end
