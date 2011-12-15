require 'random_core.rb'

# main

FILE = File.open("buf.txt", "w")
alias puts_o puts; def puts(s) # flushしないとクライアントが動かない
	puts_o s.to_s
	STDOUT.flush # cf. http://atomic.jpn.ph/prog/io/print.html
end
def rl() # read line 改行を削る
	STDIN.gets.chop # cf. http://vipprog.net/wiki/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E/Ruby/Ruby%E3%81%9D%E3%81%9E%E3%82%8D%E6%AD%A9%E3%81%8D.html
end
unless Array.new.methods.include?("sample") # Ruby1.8対策
	class Array
		def sample
			choice()
		end
	end
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
map_idx = 0
maps_num.times do
	map_idx += 1
	map, levels_num = read_map()
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
	levels_num.times do
		level = Level.new(rl)
		level.towers_num.times do
			rl # 何もしない
		end
		level.enemies_num.times do
			level.enemies << Enemy.new(rl) # 敵情報
		end
		# タワーを配置する
		if map_idx < 100 # 中止用
		money = level.money
		sample = 1
		while sample && money >= 20
			sample = map.settable_mass_rand
			if sample
				level.decisions << sample.set(:attack)
				money -= 15
			end
		end
		end
		rl #if rl == "END" # 結果を出力する
			level.decisions.compact!
			puts level.decisions.size
			level.decisions.each {|d| puts d }
		#end
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
判断の数 T
x, y, 強化する回数 A_t, 種類 C_i

▼出力
6
4 4 0 1
2 5 0 1
2 3 0 1
5 5 0 1
3 3 0 1
2 4 0 1
0
0


▼入力
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
10 14 6 3
4 4 0 、1
1 4 1 54 116
1 4 10 82 68
1 3 16 77 82
END
10 31 6 4
4 4 0 1
2 5 0 1
2 3 0 1
5 5 0 1
3 3 0 1
2 4 0 1
1 2 3 96 31
1 4 21 41 115
1 2 6 70 118
1 3 16 90 104
END



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
=end