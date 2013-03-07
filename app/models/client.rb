class Client < ActiveRecord::Base

  def self.simple_search(params)
    if (params['content'].blank?)
      clients = Client.where({})
    else
      type = params[:type]
      content = params[:content]
      if (type == 'name')
        clients = Client.where([type + ' like ?', '%' + content + '%'])
      else
        clients = Client.where({type => content})
      end
    end
    return clients
  end

end
