# 定数
# タワーとマスの種類はシンボルで扱う
TOWER_TYPE = {0=>:rapid, 1=>:attack, 2=>:freeze} # 入力用
TOWER_TYPE_NUM = TOWER_TYPE.invert # 出力用
COST_OF_SETTING = {:rapid=>10, :attack=>15, :freeze=>20} # 設置費用
MASS_TYPE = {'0'=>:path, '1'=>:block, 's'=>:source, 'g'=>:goal, 't'=>:tower}
MASS_TYPE_CHAR = MASS_TYPE.invert
SETTABLE_MASSES = [:path]

# クラス

class Map
	attr_reader :width, :height, :info, :info_settable, :num_levels, :idx # 何面か
	def initialize(width, height, info, num_levels, idx)
		@width, @height, @idx = width, height, idx+1
		@num_levels = num_levels
		y = -1
		@info = info.map do |row| # マップ情報を Mass オブジェクトで記録する
			y += 1
			x = -1 # 初期化
			row.map do |mass_type|
				x += 1
				mass = Mass.new(x, y, mass_type, self)
			end
		end
		@info_settable = [] # タワー配置可能マスを1、それ以外を0で埋めた二次元配列
		@info_settable = @info.map do |row|
			row.map do |mass|
				{true=>1, false=>0}[SETTABLE_MASSES.include?(mass.type)]
				# さらに敵→ゴール通過判定が必要。これは随時おこなう
			end
		end
		
	end
	def settable_masses_quick() # 通過判定をおこなわない
		settable_masses_quick = []
		@info.each do |row|
			row.each do |mass|
				settable_masses_quick << mass if mass.settable_quick?
			end
		end
		return settable_masses_quick
	end
	def settable_masses() # タワーを配置可能なマス
		settable_masses = []
		@info.each do |row|
			row.each do |mass|
				settable_masses << mass if mass.settable?
			end
		end
		return settable_masses
	end
	def settable_mass_rand()
		while settable_masses_quick().size > 0
			sample_mass = settable_masses_quick().sample
			if sample_mass.settable?
				return sample_mass
			else
				x, y = sample_mass.x, sample_mass.y
				sample_mass.map.info_settable[y][x] = 0
			end
		end
		return nil
	end
	def show_info()
		@info.each do |row|
			row.each do |mass|
				print mass.type_char
			end
			puts ""
		end
	end
	def show_info_settable()
		@info_settable.each do |row|
			row.each do |mass|
				print mass
			end
			puts ""
		end
	end
	def mass(x, y)
		@info[y][x] # 座標の順番に注意！
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
	def distance_euclid(mass1, mass2) # 二点間のユークリッド距離
	end
	def distance_step(mass1, mass2) # 二点間の敵の通行距離
	end
	def direction(mass1, mass2) # mass1 から mass2 への方向
		x_diff = mass2.x - mass1.x # 正なら右
		y_diff = mass2.y - mass1.y # 正なら上
		if (x_diff.abs - y_diff.abs) >= 0 # 左右を優先
			return :right if x_diff >= 0
			return :left
		else # 上下を優先
			return :up if y_diff >= 0
			return :down
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
		return false if passed_path[mass1.y][mass1.x] == 1 # 壁に埋まってるとき
		passed_path[mass1.y][mass1.x] = 1 # 同じ場所には戻れない
		movable = false
		if mass1 == mass2
			#puts ("  " * depth) + "goal!!"
# 			if $DEBUG
# 				passed_path.each do |row|
# 					row.each do |mass|
# 						print mass
# 					end
# 					puts ""
# 				end
# 			end
			return true
		else
# 			if $DEBUG
# 				passed_path.each do |row|
# 					row.each do |mass|
# 						print mass
# 					end
# 					puts ""
# 				end
# 			end
			
			move_directions = [:up, :down, :left, :right]
			move_directions.each do |direction|
				next_mass = mass1.send(direction)
				
				#puts ("  " * depth) + "#{next_mass.to_s} is movable?" if $DEBUG
				if passed_path[next_mass.y][next_mass.x] == 0
					#puts ("  " * (depth+1)) + "->yes!!" if $DEBUG
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
	attr_reader :type_char, :tower, :x, :y
	attr_accessor :type
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
		if settable?
			@tower = Tower.new(tower_type)
			@type = :tower
			@type_char = MASS_TYPE_CHAR[@type]
			@map.info_settable[y][x] = 0
			return "#{@x} #{@y} 0 #{@tower.type_num}"
		else
			return nil
		end
	end
	def settable_quick?() # 通過判定をおこなわない
		{1=>true, 0=>false}[@map.info_settable[@y][@x]]
	end
	def settable?() # タワーを設置可能か
		settable = true

		default_type = @type
		return false unless settable_quick? # :path ではない
		# todo: 金の判定→mainでやるか？ Level じゃなくて Map に @money もたせるか。
		
		@type = :tower # 仮にタワーを設置する

		settable = true # すべての敵マスについて、防衛マスへのルートがあること
		@map.sources.each do |source|
			has_route = false
			@map.goals.each do |goal| # 防衛マスへのルートが少なくともひとつあること
				has_route = true if @map.has_route?(source, goal)
			end
			unless has_route
				settable = false
				@map.info_settable[@y][@x] = 0
			end
		end
		
		@type = default_type # 元に戻す todo: remove にする？

		return settable
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
		@cost_of_levelup = COST_OF_SETTING[@type] * (@level+1)
	end
	def levelup()
		@level += 1
	end
end

class Level
	attr_reader :life, :num_towers, :num_enemies, :idx # レベル何か
	attr_accessor :enemies, :decisions, :money
	def initialize(input, idx)
		@life, @money, @num_towers, @num_enemies = input.split(/ /).map{|i| i.to_i}
		@idx = idx+1
		@enemies = []
		@decisions = []
	end
	def output()
		@decisions.compact!
		puts @decisions.size
		@decisions.each {|d| puts d }
	end
end
class Enemy
	attr_reader :x, :y, :time, :life, :speed
	def initialize(input)
		@x, @y, @time, @life, @speed = input.split(/ /).map{|i| i.to_i}
	end
end

