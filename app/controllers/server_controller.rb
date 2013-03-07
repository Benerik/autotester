class ServerController < ApplicationController
  # curl -H "API-KEY: \"27n02i1990b\"" -i -X GET "127.0.0.1:3000/home/restful_api"
  def restful_api
    api_key = request.headers["API-KEY"]

    if (api_key == "27n02i1990b")
      respond_to do |format|
        format.json { render :json => Item.where({}).select("id, name, description").to_json, :status => 200 }
      end
    else
      respond_to do |format|
        format.json { render :json => {}, :status => 401 }
      end
    end
  end
end
