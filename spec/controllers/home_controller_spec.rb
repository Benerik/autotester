require 'spec_helper'

describe HomeController do
  def valid_params
    { "name"=> "test","description"=> "description"}
  end

  describe "show all items in index page" do
    before(:each) do
      item = FactoryGirl.create(:item)
      item = FactoryGirl.create(:item_1)
      item = FactoryGirl.create(:item_2)
      item = FactoryGirl.create(:item_3)
      item = FactoryGirl.create(:item_4)
      item = FactoryGirl.create(:item_5)
      item = FactoryGirl.create(:item_6)
      item = FactoryGirl.create(:item_7)
      item = FactoryGirl.create(:item_8)
      item = FactoryGirl.create(:item_9)
    end
    it "get success home page" do
      get 'index'
      response.should be_success
    end
    it "render success home page" do
      get 'index'
      response.should render_template :index
     end
    it "check item include items" do
      item2 = FactoryGirl.create(:item_10)
      get 'index'
      @items = Item.all
      @items.should include(item2)
    end
    it "check value attributes of item" do
      get 'index'
      @items = Item.all
      @item_1 = @items.first
      @item_1.name.should ==('nib 1')
      @item_1.description.should ==('blabla........')
      @item_last = @items.last
      @item_last.name.should ==('nib 10')
    end
  end

  describe "new item" do
    it "add item success save" do
      post :add_item ,{"name"=>"test", "description"=>"test description"},:format => :json
      @item = Item.all.last
      @item.should_not be_nil
    end
    it "add item success with correct values" do
      post :add_item ,{"name"=>"test", "description"=>"test description"},:format => :json
      @item = Item.all.last
      @item.name.should == 'test'
    end
  end
  describe 'delete item' do
    before(:each) do
      item = FactoryGirl.create(:item)
      item = FactoryGirl.create(:item_1)
      item = FactoryGirl.create(:item_2)
      item = FactoryGirl.create(:item_3)
    end
    it "delete one item" do
      @item = Item.all
      puts(@item.first.to_yaml)
      post :remove_item ,{"list"=>["1"], "page"=>"", "content"=>"", "type"=>"id"},:format => :json
    end
  end

end