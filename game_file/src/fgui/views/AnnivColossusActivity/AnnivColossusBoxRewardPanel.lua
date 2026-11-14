local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
_ENV = "fgui.base.baseFguiPanel"
;("fgui.base.baseFguiPanel").PERSON = 1
local ("fgui.base.baseFguiPanel").GLOBAL, REWARDTYPE = 2, "fgui.base.baseFguiPanel"
local AnnivColossusBoxRewardPanel = class("AnnivColossusBoxRewardPanel", baseFguiPanel)
function AnnivColossusBoxRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AnnivColossusBoxRewardPanel:ctor", self.viewName)
end
function AnnivColossusBoxRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnnivColossusActivity"
	end
	return self._packageList
end
function AnnivColossusBoxRewardPanel:onInit()
	print("=======AnnivColossusBoxRewardPanel:onInit")
	self.fields.panel_normal:setString(i18n("build_colossus_07"))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self.rewardCfg = self.proxy.param.rewardCfg
	local myScore = annivColossusCtrl:getMyScore()
	if myScore < self.rewardCfg.NeedNum then
		self.fields.icon_got:setVisible(false)
		self.fields.txt_got:setVisible(false)
		self.fields.btn_get:setVisible(true)
		self.fields.btn_get:setGrayed(true)
		self.fields.btn_get:setTouchable(false)
		self.fields.btn_get:setTitle(i18n("friend_back_text18"))
	else
		local isGot = annivColossusCtrl:isRewardGot(REWARDTYPE.PERSON, self.rewardCfg.Rank)
		self.fields.icon_got:setVisible(isGot)
		self.fields.txt_got:setVisible(isGot)
		self.fields.btn_get:setVisible(not isGot)
		self.fields.btn_get:setGrayed(false)
		self.fields.btn_get:setTouchable(true)
		self.fields.btn_get:setTitle(i18n("common_text_854"))
	end
	_ENV = i18n("common_text_854")
	_ENV, _ENV, i18n("common_text_854").var = i18n("common_text_854")
	self.rewardCfg.NeedNum.var, i18n("common_text_854").color = i18n("common_text_854")
	self.fields.txt_need:setString(i18n_html("build_colossus_08", i18n("common_text_854")))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.btn_get:addClickEventListener(handler(self, self.onBtnClick))
end
function AnnivColossusBoxRewardPanel:onShow()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.rewardCfg.Reward, nil)
	self.fields.scroll:setNumItems(#self.rewards)
end
function AnnivColossusBoxRewardPanel:onHide()
	print("=======AnnivColossusBoxRewardPanel:onHide")
end
function AnnivColossusBoxRewardPanel:onDispose()
	print("=======AnnivColossusBoxRewardPanel:onDispose")
end
function AnnivColossusBoxRewardPanel:onNormalItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
function AnnivColossusBoxRewardPanel:onBtnClick()
	annivColossusCtrl:reqAnnivColossusTakeReward(self.rewardCfg.Rank)
end
return AnnivColossusBoxRewardPanel
