local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingStarWinPopPanel = class("KingStarWinPopPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
function KingStarWinPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("KingStarWinPopPanel:ctor", self.viewName)
end
function KingStarWinPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function KingStarWinPopPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======KingStarWinPopPanel:onInit")
	SoraDPlaySound("elimiateGame", 5)
	if display.height > 1136 then
		self.fields.Usm_1:setScale(display.height / 1136)
		self.fields.Usm_2:setScale(display.height / 1136)
		self.fields.Usm_3:setScale(display.height / 1136)
	end
	self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.fields.text:setString(i18n("exitic_pavillion_text_0113"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.button_1:addClickEventListener(handler(self, self.doReLogin))
	self.fields.button_1:setTitle(i18n("common_text_204"))
	local sharePicBtn = include("commonShareButton").createSnapshootButton(3)
	self.fields.btn_snapshot:setContent(sharePicBtn)
end
function KingStarWinPopPanel:onShow()
	print("=======KingStarWinPopPanel:onShow")
	local data = self.param.data
	local mapid = gametop.playertop_:getMapID()
	local name = i18n("kingstarbattle_text_55")
	local time = data.occupySecs
	local rank = data.rank
	local strTime = SoraDConvertSecondToString(time)
	_ENV = nil
	;(nil).time = strTime
	;(nil).rank = rank
	;(nil).name = name
	self.fields.text:setString(i18n("common_text_4238", nil))
	self.rewards = data.rewards
	self.fields.scroll:setNumItems(#self.rewards)
end
function KingStarWinPopPanel:onItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	local fields = fguiHelper.get_fields(obj)
	fields.item:initData(reward.id, reward.count)
	local name = publicRead.getName(reward.id)
	fields.title:setString(name)
end
function KingStarWinPopPanel:doReLogin()
	SoraDPlaySound()
	self:close()
end
return KingStarWinPopPanel
