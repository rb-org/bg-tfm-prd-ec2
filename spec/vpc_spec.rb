require 'spec_helper'

describe vpc('bg-d202') do
  it { should exist }
  it { should be_available }
  its(:vpc_id) { should eq 'vpc-05ad354a0f52ffa5f' }
  its(:cidr_block) { should eq '10.202.0.0/16' }
  it { should have_route_table('bg-d202-private-eu-west-1a') }
  it { should have_route_table('bg-d202-public') }
  it { should have_route_table('bg-d202-default') }
  it { should have_route_table('bg-d202-private-eu-west-1b') }
  it { should have_network_acl('acl-043415474961a2f3c') }
end
