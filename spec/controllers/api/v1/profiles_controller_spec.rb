require 'spec_helper'

describe Api::V1::ProfilesController do
  describe 'GET #index using doorkeeper' do
    let(:token) { stub(:accessible? => true) }

    before do
      controller.stub(:doorkeeper_token) { token }
    end

    it 'responds with 200' do
      get :index, :format => :json
      response.status.should eq(200)
    end

    it 'returns recent profiles as json' do
      Profile.should_receive(:recent) { [] }
      get :index, :format => :json
      response.body.should == [].to_json
    end

    it 'responds with 401 when unauthorized' do
      token.stub :accessible? => false
      get :index, :format => :json
      response.status.should eq(401)
    end
  end

  describe 'GET #index using SSO' do
    let!(:user) { User.create!(:email => "ax@b.com", :password => "abcde123", :password_confirmation => "abcde123") }

    it 'responds with 200' do
      get :index, :format => :json, :auth_token => user.authentication_token
      response.status.should eq(200)
    end

    it 'returns recent profiles as json' do
      Profile.should_receive(:recent) { [] }
      get :index, :format => :json, :auth_token => user.authentication_token
      response.body.should == [].to_json
    end

    it 'responds with 401 when unauthorized' do
      get :index, :format => :json
      response.status.should eq(401)
    end
  end


  describe 'POST #create (with scopes)' do
    let(:token) do
      stub :accessible? => true, :scopes => [:write]
    end

    before do
      controller.stub(:doorkeeper_token) { token }
    end

    it 'creates the profile' do
      Profile.should_receive(:create!) { stub_model(Profile) }
      post :create, :format => :json
      response.status.should eq(201)
    end
  end
end
