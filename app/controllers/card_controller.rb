class CardController < ApplicationController
  before_action :set_card, only: %i[show edit update destroy]

  def show; end

  def edit
    @lists = List.where(user: current_user).select(:id, :title)
    @positions = Card.where(list_id: @card.list_id).select('position as `key`, position as value').order(:position)
  end

  def update
    if @card.update_with_sort(card_params)
      redirect_to :root
    else
      render action: :edit
    end
  end

  def new
    @card = Card.new
    @list = List.find_by(id: params[:list_id])
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to :root
    else
      render action: :new
    end
  end

  def destroy
    @card.destroy_with_sort
    redirect_to :root
  end

  private

  def card_params
    if params[:card][:position].blank?
      position = Card.where(list_id: params[:card][:list_id]).maximum(:position)
      position = position.nil? ? 1 : position + 1
      params.require(:card).permit(:title, :memo, :list_id).merge(position: position)
    else
      params.require(:card).permit(:title, :memo, :list_id, :position)
    end
  end

  def set_card
    @card = Card.find_by(id: params[:id])
  end
end
