class WeightEntriesController < ApplicationController
  before_action :set_weight_entry, only: %i[update destroy]

  def index
    load_board
  end

  def create
    # One entry per day: adding "today" again updates it instead of failing.
    @entry = WeightEntry.find_or_initialize_by(recorded_on: entry_params[:recorded_on])
    @entry.assign_attributes(entry_params)

    if @entry.save
      @entry = WeightEntry.new(recorded_on: Date.current) # reset the add row
      render_board
    else
      load_board(keep_entry: true)
      respond_to do |format|
        format.turbo_stream { render :board, status: :unprocessable_entity }
        format.html { redirect_to weight_entries_path, alert: @entry.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    @entry.update(entry_params)
    render_board
  end

  def destroy
    @entry.destroy
    render_board
  end

  private

  def set_weight_entry
    @entry = WeightEntry.find(params[:id])
  end

  def entry_params
    params.require(:weight_entry).permit(:recorded_on, :weight_kg, :note)
  end

  def load_board(keep_entry: false)
    @entries = WeightEntry.recent_first
    @entry = WeightEntry.new(recorded_on: Date.current) unless keep_entry
  end

  def render_board
    load_board
    respond_to do |format|
      format.turbo_stream { render :board }
      format.html { redirect_to weight_entries_path }
    end
  end
end
