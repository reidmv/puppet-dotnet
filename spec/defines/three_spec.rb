require 'spec_helper'

describe 'dotnet', :type => :define do

  let :title do 'dotnet35' end
  let :params do
    { :ensure => 'present', :version => '3.5' }
  end

  ['2008 R2', '2012', '2012 R2'].each do |release|
    context "with ensure => present, version => 3.5, os.release.full => #{release}" do
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      it { should contain_exec('install-dotnet-feature-3.5').with(
        'provider' => 'powershell',
      )}
    end
  end

  ['2008 R2', '2012', '2012 R2'].each do |release|
    context "with ensure => absent, version => 3.5, os.release.full => #{release}" do
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
      end

      it { should contain_exec('uninstall-dotnet-feature-3.5').with(
        'provider' => 'powershell',
      )}
    end
  end

  pending("3.5 package-based install validation and code") do
    ['2003', '2003 R2', '2008', 'XP', 'Vista', '7', '8', '8.7'].each do |release|
      context "with ensure => present, version => 3.5, os.release.full => #{release}" do
        let :facts do
          { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
        end

        it { should contain_package('Microsoft .NET Framework 3.5').with(
          'ensure' => 'present',
        )}

        it { should contain_remote_file('C:/Windows/Temp/dotNetFx35setup.exe').with(
          'ensure' => 'present',
        )}
      end
    end

    ['2003', '2003 R2', '2008', 'XP', 'Vista', '7', '8', '8.7'].each do |release|
      context "with ensure => absent, version => 3.5, os.release.full => #{release}" do
        let :params do
          { :ensure => 'absent', :version => '3.5' }
        end
        let :facts do
          { :os => {'family' => 'windows', 'release' => { 'full' => release } } }
        end

        it { should contain_package('Microsoft .NET Framework 3.5').with(
          'ensure' => 'absent',
        )}

        it { should contain_remote_file('C:/Windows/Temp/dotNetFx35setup.exe').with(
          'ensure' => 'absent',
        )}
      end
    end
  end

end
