require 'spec_helper'

describe 'dotnet', :type => :define do

  before {
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'

    @four_url = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
    @four_prog = 'dotNetFx40_Full_x86_x64.exe'
    @four_reg = '{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'
  }

  let :title do 'dotnet4' end
  let :params do
    { :ensure => 'present', :version => '4.0' }
  end

  ['2008', '2008 R2', '2012', '2012 R2', 'XP', 'Vista', '7', '8', '8.1'].each do |release|
    context "with ensure => present, version => 4.0, os.release.full => #{release}" do
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      context "package" do
        if ['2012', '2012 R2', '8', '8.1'].include? release
          it { should_not contain_package('Microsoft .NET Framework 4 Extended') }
        else
          it { should contain_package('Microsoft .NET Framework 4 Extended').with(
            'ensure' => 'present',
          )}
        end
      end

      context "download" do
        if ['2012', '2012 R2', '8', '8.1'].include? release
          it { should_not contain_remote_file('C:/Windows/Temp/dotNetFx40_Full_x86_x64.exe') }
        else
          it { should contain_remote_file('C:/Windows/Temp/dotNetFx40_Full_x86_x64.exe') }
        end
      end
    end
  end

  ['2008', '2008 R2', '2012', '2012 R2', 'XP', 'Vista', '7', '8', '8.1'].each do |release|
    context "with ensure => absent, version => 4.0, os.release.full => #{release}" do
      let :params do
        { :ensure => 'absent', :version => '4.0' }
      end
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      context "package" do
        if not ['2012', '2012 R2', '8', '8.1'].include? release
          it { should contain_package('Microsoft .NET Framework 4 Extended').with(
            'ensure' => 'absent',
          )}
        end
      end

      context "download" do
        if not ['2012', '2012 R2', '8', '8.1'].include? release
          it { should contain_remote_file('C:/Windows/Temp/dotNetFx40_Full_x86_x64.exe').with(
            'ensure' => 'absent',
          )}
        end
      end
    end
  end

end
