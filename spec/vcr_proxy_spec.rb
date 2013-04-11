require 'spec_helper'

describe VCRProxy do
  before :each do
    @server = VCRProxy.start(:Port => 9999)
  end

  after :each do
    @server.shutdown
  end

  it "should work" do
    @server.should be_kind_of(VCRProxy::Server)
  end
end
