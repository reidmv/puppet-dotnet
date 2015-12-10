Facter.add(:dotnet4version) do
  confine :kernel => :windows
  setcode do
    require 'win32/registry'
    keyname = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.open(keyname) do |reg|
      begin
        value = reg['Release'].to_i
      rescue
        puts '4.0'
        exit
      end
      case reg['Release'].to_i
        when 378389
          '4.5'
        when 378675,378675
          '4.5.1'
        when 379893
          '4.5.2'
        when 393295
          '4.6'
        when 394254,394271
          '4.6.1'
        else
          'unknown'
		end
      end
	rescue
	  puts 'not installed'
	end
  end
end