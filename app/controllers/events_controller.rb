class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  NEARBY_DISTANCE = 10
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    respond_to do |format|
      format.html 
      format.json do
        render :json => {events: @events}
      end
    end
  end

  def nearby_events
    user_interests = params[:user_interests].split(',')
    logger.info user_interests
    subs = []
    user_interests.each do |interest|
      subs.push(interest.to_i)
    end

    @events = Event.where(subcategories: subs).select { |event| calc_distance(event.location_lati, event.location_long, params[:latitude].to_f, params[:longitude].to_f) <= NEARBY_DISTANCE  }
    @events.sort_by{ |event| calc_distance(event.location_lati, event.location_long, params[:latitude].to_f, params[:longitude].to_f) }
    render :json => {events: @events}
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def calc_distance(lat1, lon1, lat2, lon2)
      #earth’s radius (mean radius = 6,371km), so ditance will calc in km
      radius = 6371
      lat1 = to_rad(lat1)
      lat2 = to_rad(lat2)
      lon1 = to_rad(lon1)
      lon2 = to_rad(lon2)
      dLat = lat2-lat1
      dLon = lon2-lon1

      a = Math::sin(dLat/2) * Math::sin(dLat/2) +
           Math::cos(lat1) * Math::cos(lat2) *
           Math::sin(dLon/2) * Math::sin(dLon/2);
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a));
      d = radius * c
    end
    # convert angle into radian
    def to_rad(angle)
      angle * Math::PI / 180
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :event_image, :venue, :location_lati, :location_long, :category, :subcategories, :cost, :date, :time, :address)
    end
end
