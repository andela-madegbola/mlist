class Api::V1::ItemsController < ApplicationController
  before_action :get_bucketlist_items
  before_action :set_item, except: [:create, :index]

  def create
    @item = @bucketlist.items.new(item_params)
    return create_error unless @item.save
    render json: @item, status: :created
  end

  def index
    render json: @items.paginate(params[:limit], params[:page])
  end

  def show
    render json: @item
  end

  def update
    return update_error unless @item.update(item_params)
    render json: @item
  end

  def destroy
    render json: { message: delete_message } if @item.destroy
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def get_bucketlist_items
    @bucketlist = @current_user.bucketlists.
                  find_by(id: params[:bucketlist_id])
    @items = @bucketlist.items if @bucketlist
    return not_permitted unless @items
  end

  def set_item
    @item = @items.find_by(id: params[:id]) if @items
    return not_permitted unless @item
  end
end
