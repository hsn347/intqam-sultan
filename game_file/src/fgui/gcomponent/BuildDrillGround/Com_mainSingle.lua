local arenaltCtrl = include("arenaltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_mainSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildDrillGround/Com_mainSingle", Com_mainSingle)
function Com_mainSingle:onInit()
	self.fields.Load_click:addClickListener(handler(self, self.onClickItem))
	self.fields.Button_select:setString(i18n("arena_text_37"))
	self.fields.Button_select:addClickListener(handler(self, self.onClickBtnSelect))
	self.fields.Button_challenge:setString(i18n("arena_btn_04"))
	self.fields.Button_challenge:addClickListener(handler(self, self.onClickBtnChallenge))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_mainSingle:onShow()
end
function Com_mainSingle:initData(data)
	self.info = data.info
	self.myInfo = data.myInfo
	self.battleType = data.battleType
	self.challengeHandle = data.challengeHandle
	local showName = arenaltCtrl.specialCreateName(self.info, true)
	self.fields.Text_name:setString(showName)
	arenaltCtrl = nil
	;(nil).pow = string.formatnumberthousands(self.info.fightCapacity)
	self.fields.Text_force:setString(i18n("arena_columntext_04", nil))
	self.fields.Com_head:setHeadSprite(self.info.iconID or 1, self.info.avatar)
	local rank = self.info.rank
	if 3 < rank then
		self.controllers.c_rank:setSelectedIndex(1)
		self.fields.Text_rank:setString(rank)
	elseif rank <= 3 and 0 < rank then
		self.controllers.c_rank:setSelectedIndex(0)
		self.fields.Sprite_rank:setURL("icon_ranking_" .. rank .. ".png")
	end
end
function Com_mainSingle:onClickItem(...)
	if self.myInfo == nil then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).lordInfo = self.info
	;(nil).armyList = self.info.armyInfo
	;(nil).armyBuff = self.myInfo.arenaBuff
	;(nil).battleType = self.battleType
	uiManager:show("ArenaArmyInfoView", nil)
end
function Com_mainSingle:onClickBtnSelect(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleType = self.battleType
	uiManager:show("ArenaSelectView", nil)
	uiManager:close("ArenaMainView")
end
function Com_mainSingle:onClickBtnChallenge(...)
	SoraDPlaySound()
	if self.challengeHandle then
		self.challengeHandle(self.info)
	end
end
return Com_mainSingle
