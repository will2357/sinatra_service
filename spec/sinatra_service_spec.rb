require './spec/spec_helper.rb'

describe 'SinatraService' do
  include Rack::Test::Methods

  def app
    SinatraService
  end

  context "/" do
    it "should contain a link" do
      get '/'
      last_response.should be_ok
      last_response.body.should include 'Resque Overview'
    end
  end
end
