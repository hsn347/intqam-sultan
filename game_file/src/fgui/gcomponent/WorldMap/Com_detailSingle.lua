local remainsWarCtrl = SoraDGetCtrl("remainsWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_detailSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/Com_detailSingle", Com_detailSingle)
function Com_detailSingle:onInit()
	self._pos = nil
	self.fields.Text_pos:setTouchEnabled(true)
	self.fields.Text_pos:addClickListener(handler(self, self.btnGoPosClick))
end
function Com_detailSingle:onShow()
end
function Com_detailSingle:initYJData()
	self.controllers.c1:setSelectedIndex(0)
	self:fixChildrenPos()
	self._pos = RUINS_POS
	self.fields.icon:setSpriteFrame("frame_yizz_yiji.png")
	_ENV = nil
	;(nil).x = self._pos.x
	;(nil).y = self._pos.y
	_ENV = "common_text_2155"
	;("common_text_2155").u = true
	self.fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_2155", nil), "common_text_2155"))
	self.fields.Text_des:setString(i18n("remains_optimize_text4"))
end
function Com_detailSingle:initBossData(enum)
	self._pos = nil
	local remainsWarCtrl, remainsWarCtrl, isOpen = nil, "remainsWarUtil", remainsWarCtrl:isInWar() and not include("remainsWarUtil").checkIsInRemainsXianXia()
	;(nil).bossType = gBossType.ruinsWarMyBoss
	;(nil).pos = RUINS_BOSS_POS[1]
	remainsWarCtrl, ("remainsWarUtil")[1], (nil).scale = nil, nil, 0.3
	;(nil).bossType = gBossType.ruinsWarZjssgBoss
	;(nil).pos = RUINS_BOSS_POS[2]
	remainsWarCtrl, ("remainsWarUtil")[2], (nil).scale = nil, nil, 0.42
	;(nil).bossType = gBossType.ruinsWarBxmsBoss
	;(nil).pos = RUINS_BOSS_POS[1]
	remainsWarCtrl, ("remainsWarUtil")[3], (nil).scale = nil, nil, 0.33
	;(nil).bossType = gBossType.ruinsWarMmjxBoss
	;(nil).pos = RUINS_BOSS_POS[2]
	;("remainsWarUtil")[4], (nil).scale = nil, 0.33
	local cfg = "remainsWarUtil"
	local bossCfg = cfg[enum]
	self.fields.icon:setSpriteFrame(worldMapDefine.getWorldBossImage(bossCfg.bossType))
	self.fields.icon:setScale(bossCfg.scale)
	if enum == 1 or enum == 3 then
		local timeMy = remainsWarCtrl:getBossRefreshTime_My()
		local bossType = remainsWarCtrl:getWestBossType()
		if isOpen and timeMy <= 0 and bossType and bossType == bossCfg.bossType then
			self._pos = bossCfg.pos
		end
	elseif enum == 2 or enum == 4 then
		local timeZjssg = remainsWarCtrl:getBossRefreshTime_Zjssg()
		local bossType = remainsWarCtrl:getEastBossType()
		if isOpen and timeZjssg <= 0 and bossType and bossType == bossCfg.bossType then
			self._pos = bossCfg.pos
		end
	end
	if self._pos then
		remainsWarCtrl = worldMapDefine.getWorldBossImage(bossCfg.bossType)
		worldMapDefine.getWorldBossImage(bossCfg.bossType).x = self._pos.x
		worldMapDefine.getWorldBossImage(bossCfg.bossType).y = self._pos.y
		remainsWarCtrl = "common_text_2155"
		;("common_text_2155").u = true
		self.fields.Text_pos:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_2155", worldMapDefine.getWorldBossImage(bossCfg.bossType)), "common_text_2155"))
	end
	self.fields.Text_des:setString(i18n("remains_optimize_text5"))
	self.controllers.c1:setSelectedIndex(self._pos and 0 or 1)
	self:fixChildrenPos()
end
function Com_detailSingle:initSHZData()
	self.controllers.c1:setSelectedIndex(1)
	self:fixChildrenPos()
	self._pos = nil
	self.fields.icon:setSpriteFrame("lyj_bust.png")
	self.fields.icon:setScale(0.33)
	self.fields.Text_des:setString(i18n("remains_optimize_text6"))
end
function Com_detailSingle:btnGoPosClick()
	if self._pos then
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(self._pos)
		SoraDRemoveAllPanelFromManager()
	end
end
return Com_detailSingle
