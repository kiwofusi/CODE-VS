require 'random_core.rb'

# いろいろ

LOG = File.open("log.txt", "w")
alias puts_o puts; def puts(s) # flushしないとクライアントが動かない
	puts_o s.to_s
	STDOUT.flush # cf. http://atomic.jpn.ph/prog/io/print.html
end
unless Array.new.methods.include?("sample"); class Array; def sample; choice(); end; end; end # Array#sample を実装する。Ruby1.8用

# main用関数

def rl() # read line 改行は削る
	STDIN.gets.chop # cf. http://vipprog.net/wiki/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E/Ruby/Ruby%E3%81%9D%E3%81%9E%E3%82%8D%E6%AD%A9%E3%81%8D.html
end
def read_map(idx) # マップを読み込む
	width, height = rl.split(/ /).map{|i| i.to_i}
	map_info = [] # マップ情報の二次元配列
	height.times do
		map_info << rl.split(//) # マップ1行分
	end
	num_levels = rl.to_i # このマップの全レベル数
	return Map.new(width, height, map_info, num_levels, idx)
end
def decision_random(map, level) # ランダムにタワーを配置する
	sample_mass = 1 # ダミー
	while sample_mass && level.money >= 20
		sample_mass = map.settable_mass_rand
		if sample_mass
			level.decisions << sample_mass.set(:attack)
			level.money -= 15
		end
	end
	return level
end
def decision(map, level) # タワーを配置する
	decision_random(map, level)
end

# main

num_maps = rl.to_i # S
num_maps.times do |map_idx|
	map = read_map(map_idx) # マップ読み込み
	rl # "END"
	map.num_levels.times do |level_idx|
		level = Level.new(rl, level_idx) # レベル情報受け取り
		level.num_towers.times do # タワー情報受け取り
			rl # 何もしない
		end
		level.num_enemies.times do # 敵情報受け取り
			level.enemies << Enemy.new(rl)
		end
		rl # "END"
		decision(map, level) # タワーを配置する
		level.output # 判断を出力する
	end
end

=begin 出力フォーマット
判断の数 T
x, y, 強化する回数 A_t, 種類 C_i（3:破壊）
=end

=begin 入力例
40 # マップの数 S
7 7 # マップの広さ (W, H)
1111111 # マス 左上から F_1,1
1000001
1s00001
1s000g1
1s00001
1000001
1111111
25 # レベルの数 L
END
10 100 0 1 # ライフ L_p, 資金 M, タワーの数 T, 敵の数 E
# T行 タワー情報
	# 座標 X_i, Y_i, 強化回数 A_t, 種類 C_t(0:ラピッド,1:アタック,2:フリーズ)
# E行 敵情報
	1 4 12 44 40 # 座標 X_e, Y_e, 出現時刻 T_e, ライフ L_e, 移動時間 S_e
END
=end