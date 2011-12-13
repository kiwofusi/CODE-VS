# 定数
# タワーの種類はシンボルで扱う
TOWER_TYPE = {0=>:rapid, 1=>:attack, 2=>:freeze} # 入力用
TOWER_TYPE_NUM = TOWER_TYPE.invert # 出力用
COST_OF_SETTING = {:rapid=>10, :attack=>15, :freeze=>20} # 設置費用
MASS_TYPE = {'0'=>:path, '1'=>:block, 's'=>:source, 'g'=>:gloal, 't'=>:tower}
MASS_TYPE_CHAR = MASS_TYPE.invert

# クラス

class Map
	attr_reader :width, :height, :info
	def initialize(width, height, info)
		@width, @height = width, height
		y = -1
		@info = info.map do |row| # Mass オブジェクトを埋め込む
			y += 1
			x = -1 # 注意！
			row.map do |mass_type|
				x += 1
				mass = Mass.new(x, y, mass_type, self)
			end
		end
	end
	def show()
		@info.each do |row|
			row.each do |mass|
				print mass.type_char
			end
			puts ""
		end
	end
	def mass(x, y)
		@info[y][x] # 座標の順番に注意！
	end
	def setable?(mass1, mass2) # タワーを設置可能か
		setable = true # すべての敵マスについて、防衛マスへのルートがあること
		sources.each do |source|
			has_route = false
			goals.each do |goal| # 防衛マスへのルートが少なくともひとつあること
				has_route = true if has_route?(sources, goal)
			end
			setable = false unless has_route
		end
		return setable
	end
	def sources() # 敵出現マス一覧
		search(:source)
	end
	def goals() # 防衛マス一覧
		search(:goal)
	end	
	def has_route?(mass1, mass2) # 二点が通行可能か
		# 上下左右いずれかの :path を通って mass2 に到達できること
		return move_foward(mass1, mass2)
	end
	def distance(mass1, mass2, type="step") # 二点間の距離
		if type == "step" # ユニットの移動距離
		
		else # ユークリッド距離
		
		end
	end

	private

	def search(type) # マスを探す
		result = []
		@info.each do |row| # find_all とかうまく使えないか？
			row.each do |mass|
				result << mass if mass.type == type
			end
		end
		return result
	end
	def move_foward(mass1, mass2, passed_path=nil, depth=0) # mass1 から mass2 への移動を試みる
		passed_path ||= define_passed_path(mass1) # 通行マップ：通ってはいけないマスを1、通れるマスを0とする
		passed_path[mass1.y][mass1.x] = 1 # 同じ場所には戻れない
		movable = false
		if mass1 == mass2
			puts ("  " * depth) + "goal!!"
			if $DEBUG
				passed_path.each do |row|
					row.each do |mass|
						print mass
					end
					puts ""
				end
			end
			return true
		else
			if $DEBUG
				passed_path.each do |row|
					row.each do |mass|
						print mass
					end
					puts ""
				end
			end
			
			move_directions = [:up, :down, :left, :right]
			move_directions.each do |direction|
				next_mass = mass1.send(direction)
				
				puts ("  " * depth) + "#{next_mass.to_s} is movable?" if $DEBUG
				if passed_path[next_mass.y][next_mass.x] == 0
					puts ("  " * (depth+1)) + "->yes!!" if $DEBUG
					movable = true if move_foward(next_mass, mass2, passed_path, depth+=1)
				end
				
				return movable if movable
			end
			return movable
		end
	end
	def define_passed_path(current_mass) # 通行マップを定義する
		passed_path = Array.new(@height){ Array.new(@width){0} }
		
		# Array.new(7){ Array.new(7){0} }
		# Array#newには注意 http://doc.okkez.net/static/192/class/Array.html
		unpassable = [:block, :tower] # 通行不可能
		y = -1
		passed_path.each do |row|
			y += 1
			x = -1
			row.each do |mass|
				x += 1
				passed_path[y][x] = 1 if unpassable.include?(mass(x, y).type)
			end
		end

	end
end



class Mass
	attr_reader :type, :type_char, :tower, :x, :y
	attr :map # 所属マップ
	def initialize(x, y, mass_type_char, map)
		@x, @y = x, y
		@type_char = mass_type_char # 自分でタワー配置を出力したいとき用（ないか
		@type = MASS_TYPE[@type_char]
		@tower = nil
		@map = map
	end
	
	def up; @map.mass(@x, @y-1); end
	def down; @map.mass(@x, @y+1); end
	def right; @map.mass(@x+1, @y); end
	def left; @map.mass(@x-1, @y); end

	def to_s; "#{@type}(#{x}, #{y})"; end
	
	def set(tower_type)
		@tower = Tower.new(tower_type)
		@type = :tower
		@type_char = MASS_TYPE_CHAR[@type]
	end
	def remove()
	end
	def levelup()
		@tower.levelup()
	end
end
class Tower
	attr_reader :type, :type_num, :level
	attr_reader :cost_of_levelup # 強化費用
	def initialize(type)
		@type = type
		@type_num = TOWER_TYPE_NUM[@type]
		@level = 1
		@cost_of_levelup = COST_OF_SETTING[@type] * (level+1)
	end
	def levelup()
		@level += 1
	end
end

class Level
	attr_reader :life, :money, :towers_num, :enemies_num
	attr_accessor :enemies
	def initialize(input)
		@life, @money, @towers_num, @enemies_num = input.split(/ /).map{|i| i.to_i}
		@enemies = []
	end
end
class Enemy
	attr_reader :x, :y, :time, :life, :speed
	def initialize(input)
		@x, @y, @time, @life, @speed = input.split(/ /).map{|i| i.to_i}
	end
end


# main

FILE = File.open("buf.txt", "w")
alias puts_o puts
def puts(s)
	puts_o s.to_s
	STDOUT.flush # cf. http://atomic.jpn.ph/prog/io/print.html
end
def rl() # read line
	STDIN.gets.chop # cf. http://vipprog.net/wiki/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E/Ruby/Ruby%E3%81%9D%E3%81%9E%E3%82%8D%E6%AD%A9%E3%81%8D.html
end
def read_map() # マップを読み込む
	width, height = rl.split(/ /).map{|i| i.to_i}
	map_info = [] # マップ情報の二次元配列
	height.times do
		map_info << rl.split(//) # 行
	end
	map = Map.new(width, height, map_info)
	levels_num = rl.to_i
	rl # "END"
	return map, levels_num
end

maps_num = rl.to_i # S
maps_num.times do
	map, levels_num = read_map()
	if $DEBUG

		map.show
		mass = map.mass(1,2)
		puts mass == mass.up.right.down.send(:left)
		map.sources.each {|goal| puts goal.to_s }
		from = map.mass(1,2)
		to = map.mass(2,5)
		puts "from #{from.to_s} to #{to.to_s}"
		puts map.has_route?(from, to)
	end
	levels_num.times do
		level = Level.new(rl)
		level.enemies_num.times do
			level.enemies << Enemy.new(rl) # 敵情報
			# タワーを配置する
		end
		puts "0" if rl == "END" # 結果を出力する
	end
end


=begin サンプル

# タワーを配置する
map.mass(x, y).set(:attack)

# タワーを強化する
map.mass(x, y).levelup()

# タワーを破棄する
map.mass(x, y).remove()

=end

=begin 出力


=end

=begin 入力例
40 # マップの数 S
7 7 # マップの広さ (W, H)
1111111 # マス 左上から F_1,1 = F_i+1,j+1
1000001 # F_2,1
1s00001
1s000g1
1s00001
1000001
1111111 # 右下 F_W,H
25 # レベルの数 L
END
10 100 0 1 # ライフ L_p, 資金 M, タワーの数 T, 敵の数 E
# T行 タワー情報
# 座標 X_i, Y_i, 強化回数 A_t, 種類 C_t(0:ラピッド,1:アタック,2:フリーズ)
# E行 敵情報
1 4 12 44 40 # 座標 X_e, Y_e, 出現時刻 T_e, ライフ L_e, 移動時間 S_e
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
=end