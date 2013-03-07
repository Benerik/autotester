class HomeController < ApplicationController
  def index
    session[:number_per_page] = 10 if session[:number_per_page].blank?
    @item = Client.paginate(:page => 1, :per_page => session[:number_per_page])
    @total = Client.count
  end

  def add_item
    puts(params)
    Client.create(:name => params["name"], :description => params["description"])
    render json: {}
  end

  def remove_item
    session[:number_per_page] = params['per'] if !params['per'].blank?
    params[:page] = 1 if params[:page].blank?

    Client.destroy_all(["id IN (?)", params['list']])
    length = params['list'].length
    @clients = Client.simple_search(params)
    @client = @clients.paginate(:page => params['page'], :per_page => session[:number_per_page])

    render json: {data: @client[(session[:number_per_page].to_i - length)..(session[:number_per_page].to_i)], page: (@clients.count / session[:number_per_page].to_f).ceil}
  end

  def item_per_page
    session[:number_per_page] = params['per'] if !params['per'].blank?
    params[:page] = 1 if params[:page].blank?

    @items = Client.simple_search(params)
    @item = @items.paginate(:page => params['page'], :per_page => session[:number_per_page])
    render json: {"data" => @item, "page" => (@items.count / session[:number_per_page].to_f).ceil, "per" => session[:number_per_page]}
  end

  def get_infor
    conn = Faraday.new(:url => 'http://127.0.0.1:4000')
    response = conn.get '/server/restful_api' do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['API-KEY'] = '27n02i1990b'
    end
    @item = ActiveSupport::JSON.decode(response.body)
    @item.each do |item|
      exist = Client.where("server_id" => item["id"]).count
      Client.create(:name => item["name"], :description => item["description"], :server_id => item["id"]) if exist == 0
    end
    render json: {}
  end
end
