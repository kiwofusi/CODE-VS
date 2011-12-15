require 'random_core.rb'


input = <<EOF
40
7 7
1111111
1000001
1s00001
1s000g1
1s00001
1000001
1111111
25
END
10 100 0 1
1 4 12 44 40
END
9 100 0 3
1 4 1 54 116
1 4 10 82 68
1 3 16 77 82
END
6 100 0 4
1 2 3 96 31
1 4 21 41 115
1 2 6 70 118
1 3 16 90 104
END
2 100 0 4
1 4 1 61 118
1 4 14 150 82
1 3 1 66 53
1 4 17 109 54
END
EOF


describe Map, "‚ğ ‚Æ‚«" do
	before do
		#@map = Map.new(width, height, map_info, num_levels, idx)
	end
	it "# ‚Í ‚Å‚ ‚é" do
	end
end

describe Map, "" do
	before do
		@map = Map.new(8, 8, [Array.new(8){0}], 1, 1)
	end

	it "Mass(3,3) ‚©‚ç Mass(4,5) ‚Ì #directions ‚Í [:up, :right, :left, :down] ‚Å‚ ‚é" do
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(4, 5, :path, @map)
		@map.directions(mass1, mass2).should == [:up, :right, :left, :down]
	end
	it "Mass(3,3) ‚©‚ç Mass(2,1) ‚Ì #directions ‚Í [:down, :left, :right, :up] ‚Å‚ ‚é" do
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(2, 1, :path, @map)
		@map.directions(mass1, mass2).should == [:down, :left, :right, :up]
	end
	it "Mass(3,3) ‚©‚ç Mass(5,4) ‚Ì #directions ‚Í [:right, :up, :down, :left] ‚Å‚ ‚é" do
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(5, 4, :path, @map)
		@map.directions(mass1, mass2).should == [:right, :up, :down, :left]
	end
	it "Mass(3,3) ‚©‚ç Mass(1,2) ‚Ì #directions ‚Í [:left, :down, :up, :right] ‚Å‚ ‚é" do
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(1, 2, :path, @map)
		@map.directions(mass1, mass2).should == [:left, :down, :up, :right]
	end

	it "#direction(mass1, mass2) ‚Í mass1 ‚©‚ç mass2 ‚Ö‚Ì•ûŒü‚ğ¦‚·" do
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(3, 3, :path, @map)
		@map.direction(mass1, mass2).should == :right
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(3, 4, :path, @map)
		@map.direction(mass1, mass2).should == :up
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(4, 5, :path, @map)
		@map.direction(mass1, mass2).should == :up
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(3, 2, :path, @map)
		@map.direction(mass1, mass2).should == :down
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(2, 1, :path, @map)
		@map.direction(mass1, mass2).should == :down
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(4, 3, :path, @map)
		@map.direction(mass1, mass2).should == :right
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(5, 4, :path, @map)
		@map.direction(mass1, mass2).should == :right
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(2, 3, :path, @map)
		@map.direction(mass1, mass2).should == :left
		mass1 = Mass.new(3, 3, :path, @map)
		mass2 = Mass.new(1, 2, :path, @map)
		@map.direction(mass1, mass2).should == :left
	end
end






=begin
	if $DEBUG
		map.show
		mass = map.mass(1,2)
		puts mass == mass.up.right.down.send(:left)
		map.goals.each {|goal| puts goal.to_s }
		from = map.mass(1,2)
		to = map.mass(2,5)
		#puts "from #{from.to_s} to #{to.to_s}", map.has_route?(from, to)
		#puts "settable?"
		#puts map.mass(1,1).settable?

		#puts "has route?"
# 		map.mass(5,2).set(:attack)
# 		map.mass(4,3).set(:attack)
# 		map.mass(4,3).set(:attack)
# 		map.mass(5,4).set(:attack)
		puts "setable_masses"
		map.mass(1,1).set(:attack)
		map.mass(2,3).set(:attack)
		map.mass(2,4).set(:attack)
		map.mass(3,2).set(:attack)
		map.mass(3,5).set(:attack)
		map.mass(4,3).set(:attack)
		map.mass(4,4).set(:attack)
		map.mass(4,5).set(:attack)
		map.mass(5,1).set(:attack)
		puts map.mass(2,1).settable?
		
		map.show

	end
=end