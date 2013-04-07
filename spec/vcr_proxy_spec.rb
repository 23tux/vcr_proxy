require 'spec_helper'

describe VCRProxy do
  it "should work" do
    VCRProxy.start({}).should be_kind_of?(VCRProxy)
  end
end
