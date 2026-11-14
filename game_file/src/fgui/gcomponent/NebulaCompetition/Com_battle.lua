local baseComponent = require("fgui.base.baseComponent")
local Com_battle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_battle", Com_battle)
function Com_battle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_battle:onShow()
	self.fields.text_enemy:setString(i18n("Nebula_Competition_text_14"))
	self.fields.text_my:setString(i18n("Nebula_Competition_text_13"))
	self.fields.ani_blue:setAllFrameName("dh_xmdk_lanse_%02d.png", 1)
	self.fields.ani_blue:setPlaySettings(0, -1, -1)
	self.fields.ani_red:setAllFrameName("dh_xmdk_hongse_%02d.png", 1)
	self.fields.ani_red:setPlaySettings(0, -1, -1)
end
function Com_battle:initData(data, stage, curStage)
	self.data = data
	self.myScore = self.data.bFindNorth and self.data.northScore or self.data.southScore
	self.enemyScore = self.data.bFindNorth and self.data.southScore or self.data.northScore
	self.fields.score_my:setString(self.myScore)
	self.fields.score_enemy:setString(self.enemyScore)
	local statusStr = ""
	if self.myScore + self.enemyScore == 0 then
		self.fields.progress:initData(0.5)
	else
		self.fields.progress:initData(self.myScore / (self.myScore + self.enemyScore))
	end
	if curStage < stage and stage ~= 7 then
		self.controllers.c1:setSelectedIndex(2)
		statusStr = i18n("build_colossus_11")
	elseif stage == curStage and stage ~= 7 or stage == 7 and curStage ~= 7 then
		self.controllers.c1:setSelectedIndex(self.myScore >= self.enemyScore and 0 or 1)
		self.fields.win_bg_my:setVisible(self.myScore ~= self.enemyScore)
		self.fields.text_win_my:setVisible(self.myScore ~= self.enemyScore)
		self.fields.text_win_my:setString(i18n("Nebula_Competition_text_15"))
		self.fields.text_win_enemy:setString(i18n("Nebula_Competition_text_15"))
		statusStr = i18n("activity_text_05")
	else
		self.controllers.c1:setSelectedIndex(3)
		statusStr = i18n("Anchor_text_21")
		if self.myScore > self.enemyScore then
			self.fields.icon_enemy_lose:setVisible(true)
			self.fields.icon_enemy_win:setVisible(false)
			self.fields.icon_my_lose:setVisible(false)
			self.fields.icon_my_win:setVisible(true)
		elseif self.myScore < self.enemyScore then
			self.fields.icon_enemy_lose:setVisible(false)
			self.fields.icon_enemy_win:setVisible(true)
			self.fields.icon_my_lose:setVisible(true)
			self.fields.icon_my_win:setVisible(false)
		else
			self.fields.icon_enemy_lose:setVisible(false)
			self.fields.icon_enemy_win:setVisible(false)
			self.fields.icon_my_lose:setVisible(false)
			self.fields.icon_my_win:setVisible(false)
		end
		self.fields.enemy_isWin_bg:setVisible(true)
		self.fields.my_isWin_bg:setVisible(true)
		if self.myScore > self.enemyScore then
			self.fields.my_isWin_bg:setURL("framer_Nebula_Competition_guang.png")
			self.fields.enemy_isWin_bg:setURL("framer_Nebula_Competition_lose_di.png")
		elseif self.myScore < self.enemyScore then
			self.fields.enemy_isWin_bg:setURL("framer_Nebula_Competition_guang.png")
			self.fields.my_isWin_bg:setURL("framer_Nebula_Competition_lose_di.png")
		else
			self.fields.enemy_isWin_bg:setVisible(false)
			self.fields.my_isWin_bg:setVisible(false)
		end
	end
	self.fields.text_status:setString(statusStr)
end
return Com_battle
