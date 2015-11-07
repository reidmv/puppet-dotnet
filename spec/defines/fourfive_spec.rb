require 'spec_helper'

describe 'dotnet', :type => :define do

  let :title do 'dotnet4' end
  let :params do
    { :ensure => 'present', :version => '4.5' }
  end

  ['2008', '2008 R2', '2012', '2012 R2', 'XP', 'Vista', '7', '8', '8.1'].each do |release|
    context "with ensure => present, version => 4.5, os.release.full => #{release}" do
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      context "package" do
        if ['2012', '2012 R2', '8', '8.1'].include? release
          it { should_not contain_package('Microsoft .NET Framework 4.5') }
        else
          it { should contain_package('Microsoft .NET Framework 4.5').with(
            'ensure' => 'present',
          )}
        end
      end

      context "download" do
        if ['2012', '2012 R2', '8', '8.1'].include? release
          it { should_not contain_remote_file('C:/Windows/Temp/dotnetfx45_full_x86_x64.exe') }
        else
          it { should contain_remote_file('C:/Windows/Temp/dotnetfx45_full_x86_x64.exe') }
        end
      end
    end
  end

  ['2008', '2008 R2', '2012', '2012 R2', 'XP', 'Vista', '7', '8', '8.1'].each do |release|
    context "with ensure => absent, version => 4.5, os.release.full => #{release}" do
      let :params do
        { :ensure => 'absent', :version => '4.5' }
      end
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      context "package" do
        if not ['2012', '2012 R2', '8', '8.1'].include? release
          it { should contain_package('Microsoft .NET Framework 4.5').with(
            'ensure' => 'absent',
          )}
        end
      end

      context "download" do
        if not ['2012', '2012 R2', '8', '8.1'].include? release
          it { should contain_remote_file('C:/Windows/Temp/dotnetfx45_full_x86_x64.exe').with(
            'ensure' => 'absent',
          )}
        end
      end
    end
  end

end
