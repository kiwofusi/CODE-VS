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
		@info = info.map do |row|
			row.map do |mass_type|
				Mass.new(mass_type)
			end
		end
		
	end
	def mass(x, y)
		@info[x][y]
	end
	def setable?(mass1, mass2) # タワーを設置可能か
		setable = true # すべての敵マスについて、防衛マスへのルートがあること
		sources.each do |source|
			has_route = false
			goals.each do |goal| # 防衛マスへのルートが少なくともひとつあること
				has_route = true if has_route?(sources, goal)
			end
			setable = false unless has_route = true
		end
		return setable
	end
	def sources() # 敵出現マス一覧
		# return [x1, y2], [x2, y2] ...
	end
	def goals() # 防衛マス一覧
		# return [x1, y2], [x2, y2] ...
	end	
	def has_route?(mass1, mass2) # 二点が通行可能か
	end
	def distance(mass1, mass2, type="step") # 二点間の距離
		if type == "step" # ユニットの移動距離
		
		else # ユークリッド距離
		
		end
	end
end

class Mass
	attr_reader :type, :type_char, :tower
	def initialize(mass_type_char)
		@type_char = mass_type_char # 自分でタワー配置を出力したいとき用（ないか
		@type = MASS_TYPE[mass_type_char]
		@tower = nil
	end
	def set(tower)
		@tower = tower
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
tower = Tower.new(:rapid)
map.mass(x, y).set(tower)

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