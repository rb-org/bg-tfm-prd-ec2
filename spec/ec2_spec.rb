require 'spec_helper'

describe ec2('bg-d202-web-grn') do
  it { should exist }
  it { should be_running }
  its(:instance_id) { should eq 'i-096ce715757f8331b' }
  its(:image_id) { should eq 'ami-00e1e88c5a3485572' }
  its(:private_dns_name) { should eq 'ip-10-202-101-4.eu-west-1.compute.internal' }
  its(:public_dns_name) { should eq '' }
  its(:instance_type) { should eq 't2.medium' }
  its(:private_ip_address) { should eq '10.202.101.4' }
  it { should have_security_group('bg-d202-sg-web-asg') }
  it { should belong_to_vpc('bg-d202') }
  it { should belong_to_subnet('bg-d202-private-eu-west-1a') }
  it { should have_ebs('vol-071bb10e07b05e25f') }
  it { should have_network_interface('eni-07db685ace2dbd69a') }
end

describe ec2('bg-d202-web-blu') do
  it { should exist }
  it { should be_running }
  its(:instance_id) { should eq 'i-0ea72ec62a5f9f096' }
  its(:image_id) { should eq 'ami-00e1e88c5a3485572' }
  its(:private_dns_name) { should eq 'ip-10-202-102-17.eu-west-1.compute.internal' }
  its(:public_dns_name) { should eq '' }
  its(:instance_type) { should eq 't2.medium' }
  its(:private_ip_address) { should eq '10.202.102.17' }
  it { should have_security_group('bg-d202-sg-web-asg') }
  it { should belong_to_vpc('bg-d202') }
  it { should belong_to_subnet('bg-d202-private-eu-west-1b') }
  it { should have_ebs('vol-040f8baa7e0883d0c') }
  it { should have_network_interface('eni-0dfc7e4c95b9d1f48') }
end

describe ec2('bg-glbl-ssh-01') do
  it { should exist }
  it { should be_stopped }
  its(:instance_id) { should eq 'i-0027ebee1d95f86bb' }
  its(:image_id) { should eq 'ami-1b791862' }
  its(:private_dns_name) { should eq 'ip-10-202-1-104.eu-west-1.compute.internal' }
  its(:public_dns_name) { should eq 'ec2-52-16-116-88.eu-west-1.compute.amazonaws.com' }
  its(:instance_type) { should eq 't2.medium' }
  its(:private_ip_address) { should eq '10.202.1.104' }
  its(:public_ip_address) { should eq '52.16.116.88' }
  it { should have_security_group('bg-glbl-sg-bstn') }
  it { should belong_to_vpc('bg-d202') }
  it { should belong_to_subnet('bg-d202-public-eu-west-1a') }
  it { should have_eip('52.16.116.88') }
  it { should have_ebs('vol-0b04d7058342b6d54') }
  it { should have_network_interface('eni-0280451c9575e142f') }
end

describe ec2('bg-glbl-rndk-01') do
  it { should exist }
  it { should be_stopped }
  its(:instance_id) { should eq 'i-001b982908cd8274f' }
  its(:image_id) { should eq 'ami-1b791862' }
  its(:private_dns_name) { should eq 'ip-10-202-101-120.eu-west-1.compute.internal' }
  its(:public_dns_name) { should eq '' }
  its(:instance_type) { should eq 't2.medium' }
  its(:private_ip_address) { should eq '10.202.101.120' }
  it { should have_security_group('bg-glbl-sg-rndk') }
  it { should belong_to_vpc('bg-d202') }
  it { should belong_to_subnet('bg-d202-private-eu-west-1a') }
  it { should have_ebs('vol-0d59bd70cf6ba90f1') }
  it { should have_network_interface('eni-03ff512796b8c39c0') }
end
